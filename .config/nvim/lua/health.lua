local check_version = function()
  local verstr = tostring(vim.version())
  if not vim.version.ge then
    vim.health.error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", verstr))
    return
  end

  if vim.version.ge(vim.version(), '0.10-dev') then
    vim.health.ok(string.format("Neovim version is: '%s'", verstr))
  else
    vim.health.error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", verstr))
  end
end

local function report_missing(level, message)
  if level == 'error' then
    vim.health.error(message)
  elseif level == 'warn' then
    vim.health.warn(message)
  else
    vim.health.info(message)
  end
end

local check_executables = function(title, executables, missing_level)
  vim.health.start(title)
  for _, exe in ipairs(executables) do
    local is_executable = vim.fn.executable(exe) == 1
    if is_executable then
      vim.health.ok(string.format("Found executable: '%s'", exe))
    else
      report_missing(missing_level or 'warn', string.format("Could not find executable: '%s'", exe))
    end
  end
end

local check_any_executable = function(title, executables, missing_level)
  vim.health.start(title)

  for _, exe in ipairs(executables) do
    if vim.fn.executable(exe) == 1 then
      vim.health.ok(string.format("Found executable: '%s'", exe))
      return
    end
  end

  report_missing(
    missing_level or 'warn',
    string.format("Could not find any executable: '%s'", table.concat(executables, "', '"))
  )
end

local check_vtsls_patch = function()
  vim.health.start 'vtsls patch'

  local index_path = vim.fn.stdpath('data')
    .. '/mason/packages/vtsls/node_modules/@vtsls/language-server/node_modules/@vtsls/language-service/dist/index.js'
  if vim.uv.fs_stat(index_path) == nil then
    vim.health.info('vtsls is not installed in Mason')
    return
  end

  local ok, lines = pcall(vim.fn.readfile, index_path)
  if not ok then
    vim.health.warn('Could not read vtsls language-service file: ' .. index_path)
    return
  end

  local content = table.concat(lines, '\n')
  if content:find('Do not re%-throw TypeScriptServerError') then
    vim.health.ok('vtsls TypeScriptServerError patch is applied')
  else
    vim.health.warn('vtsls patch is missing; run scripts/patch-vtsls.py if tsserver crashes')
  end
end

local check_external_reqs = function()
  check_executables('Required executables', { 'git', 'make', 'unzip', 'rg', 'fd', 'node', 'yarn' }, 'warn')
  check_any_executable('Required formatter executable', { 'prettierd', 'prettier' }, 'warn')
  check_executables('Feature executables', { 'jq', 'stylua', 'luacheck', 'markdownlint', 'stylelint' }, 'info')
  check_executables('Optional Git UI executables', { 'gh', 'lazygit' }, 'info')
  check_executables('Optional AI/session/debug executables', { 'tmux', 'python3' }, 'info')
  check_vtsls_patch()

  return true
end

return {
  check = function()
    vim.health.start 'personal.nvim'

    vim.health.info [[Required warnings affect core editing/search/JS formatting.
Feature and optional entries are informational unless you use that workflow.]]

    local uv = vim.uv or vim.loop
    vim.health.info('System Information: ' .. vim.inspect(uv.os_uname()))

    check_version()
    check_external_reqs()
  end,
}
