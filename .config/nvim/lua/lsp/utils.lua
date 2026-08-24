local M = {}

local missing_commands = {}

--- Find a root directory by searching for marker files.
---@param patterns string[]
---@param start_path string|nil
---@return string root_dir
---@return boolean marker_found
function M.find_root(patterns, start_path)
  local path = start_path or vim.fn.getcwd()
  local stat = vim.uv.fs_stat(path)
  if not stat or stat.type ~= "directory" then path = vim.fs.dirname(path) or vim.fn.getcwd() end

  for _, pattern in ipairs(patterns) do
    local found = vim.fs.find(pattern, { path = path, upward = true })
    if #found > 0 then return vim.fs.dirname(found[1]), true end
  end

  return path, false
end

local function command_available(cmd)
  local executable = type(cmd) == "table" and cmd[1] or nil
  if not executable or executable == "" then return false end
  return vim.fn.executable(executable) == 1
end

local function warn_missing_command(server_name, cmd)
  if missing_commands[server_name] then return end
  missing_commands[server_name] = true
  local executable = type(cmd) == "table" and cmd[1] or cmd
  vim.notify(
    ("LSP %s not started: command not found: %s"):format(server_name, tostring(executable)),
    vim.log.levels.WARN
  )
end

local function has_eslint_config(root_dir)
  local configs = {
    ".eslintrc.js",
    ".eslintrc.json",
    ".eslintrc.cjs",
    ".eslintrc.yml",
    ".eslintrc.yaml",
    "eslint.config.js",
    "eslint.config.mjs",
  }
  if #vim.fs.find(configs, { path = root_dir, upward = true }) > 0 then return true end

  local package_json_path = vim.fs.find("package.json", { path = root_dir, upward = true })[1]
  if not package_json_path then return false end

  local ok, lines = pcall(vim.fn.readfile, package_json_path)
  if not ok then return false end
  local package_content = table.concat(lines, "\n")
  return package_content:match '"eslint"' ~= nil or package_content:match '"eslintConfig"' ~= nil
end

--- Start one configured LSP server for a buffer.
---@param server_config table
---@param bufnr number
function M.start_lsp_server(server_config, bufnr)
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  if bufname:match "^codediff://" or vim.bo[bufnr].buftype == "quickfix" then return end

  local root_dir, root_found =
    M.find_root(server_config.root_patterns, bufname ~= "" and bufname or nil)
  if server_config.workspace_required and not root_found then return end
  if server_config.condition and not server_config.condition(bufname, root_dir, root_found) then
    return
  end
  if server_config.name == "eslint" and not has_eslint_config(root_dir) then return end

  local cmd = server_config.cmd
  if type(cmd) == "function" then cmd = cmd(root_dir) end
  if not command_available(cmd) then
    warn_missing_command(server_config.name, cmd)
    return
  end

  local settings = server_config.settings
  if type(settings) == "function" then settings = settings(root_dir) end

  vim.lsp.start({
    name = server_config.name,
    cmd = cmd,
    root_dir = root_dir,
    capabilities = require("blink.cmp").get_lsp_capabilities(),
    settings = settings,
    init_options = server_config.init_options,
    get_language_id = server_config.get_language_id,
  }, { bufnr = bufnr })
end

return M
