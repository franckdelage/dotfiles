local M = {}

-- Helper function to find root directory
function M.find_root(patterns, start_path)
  local path = start_path or vim.fn.getcwd()
  for _, pattern in ipairs(patterns) do
    local found = vim.fs.find(pattern, { path = path, upward = true })
    if #found > 0 then
      return vim.fs.dirname(found[1])
    end
  end
  return vim.fn.getcwd()
end

-- Helper function for checking LSP method support (0.11+ compatibility)
function M.client_supports_method(client, method, bufnr)
  if vim.fn.has 'nvim-0.11' == 1 then
    return client:supports_method(method, bufnr)
  else
    return client.supports_method(method, { bufnr = bufnr })
  end
end

-- Function to start LSP server
function M.start_lsp_server(server_config, bufnr)
  local root_dir = M.find_root(server_config.root_patterns)

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
        if package_content:match('"eslint"') or package_content:match('"eslintConfig"') then
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