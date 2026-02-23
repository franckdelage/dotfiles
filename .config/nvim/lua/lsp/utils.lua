local M = {}

--- Helper function to find root directory by searching for pattern files
---@param patterns string[] List of file patterns to search for (e.g., {".git", "package.json"})
---@param start_path string|nil Optional starting path, defaults to current working directory
---@return string root_dir The found root directory or current working directory as fallback
function M.find_root(patterns, start_path)
  local path = start_path or vim.fn.getcwd()

  -- If start_path is a file, use its directory
  local stat = vim.uv and vim.uv.fs_stat and vim.uv.fs_stat(path) or vim.loop.fs_stat(path)
  if stat and stat.type == 'file' then
    path = vim.fs.dirname(path)
  end

  for _, pattern in ipairs(patterns) do
    local found = vim.fs.find(pattern, { path = path, upward = true })
    if #found > 0 then
      return vim.fs.dirname(found[1])
    end
  end
  return vim.fn.getcwd()
end

--- Helper function for checking LSP method support (0.11+ compatibility)
---@param client table LSP client object
---@param method string LSP method name (e.g., "textDocument/formatting")
---@param bufnr number|nil Buffer number to check method support for
---@return boolean supports Whether the client supports the specified method
function M.client_supports_method(client, method, bufnr)
  if vim.fn.has 'nvim-0.11' == 1 then
    return client:supports_method(method, bufnr)
  else
    return client.supports_method(method, { bufnr = bufnr })
  end
end

--- Function to start LSP server with proper configuration
---@param server_config table Server configuration table with fields: name, cmd, root_patterns, settings, init_options
---@param bufnr number Buffer number to attach the LSP server to
function M.start_lsp_server(server_config, bufnr)
  local bufname = vim.api.nvim_buf_get_name(bufnr)

  -- Don't attach LSP to CodeDiff virtual buffers (codediff:// URIs cause URI parse errors)
  if bufname:match("^codediff://") then return end

  local root_dir = M.find_root(server_config.root_patterns, bufname ~= '' and bufname or nil)

  -- Special handling for ESLint - only start if config files exist
  if server_config.name == 'eslint' then
    local eslint_configs = { '.eslintrc.js', '.eslintrc.json', '.eslintrc.cjs', 'eslint.config.js', 'eslint.config.mjs', '.eslintrc.yml', '.eslintrc.yaml' }
    local has_eslint_config = false
    for _, config_file in ipairs(eslint_configs) do
      local found = vim.fs.find(config_file, { path = root_dir, upward = true })
      if #found > 0 then
        has_eslint_config = true
        break
      end
    end

    -- Also check for eslint in package.json
    if not has_eslint_config then
      local package_json_path = vim.fs.find('package.json', { path = root_dir, upward = true })[1]
      if package_json_path then
        local package_json = vim.fn.readfile(package_json_path)
        local package_content = table.concat(package_json, '\n')
        if package_content:match '"eslint"' or package_content:match '"eslintConfig"' then
          has_eslint_config = true
        end
      end
    end

    if not has_eslint_config then
      return -- Don't start ESLint if no config found
    end
  end

  local cmd = server_config.cmd
  if type(cmd) == 'function' then
    cmd = cmd()
  end

  -- Get capabilities from blink.cmp
  local capabilities = require('blink.cmp').get_lsp_capabilities()

  local config = {
    name = server_config.name,
    cmd = cmd,
    root_dir = root_dir,
    capabilities = capabilities,
    settings = server_config.settings,
    init_options = server_config.init_options,
  }

  vim.lsp.start(config, { bufnr = bufnr })
end

return M
