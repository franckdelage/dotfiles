--[[
--
-- This file is not required for your own configuration,
-- but helps people determine if their system is setup correctly.
--
--]]

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

local check_executables = function(title, executables)
  vim.health.start(title)
  for _, exe in ipairs(executables) do
    local is_executable = vim.fn.executable(exe) == 1
    if is_executable then
      vim.health.ok(string.format("Found executable: '%s'", exe))
    else
      vim.health.warn(string.format("Could not find executable: '%s'", exe))
    end
  end
end

local check_any_executable = function(title, executables)
  vim.health.start(title)

  for _, exe in ipairs(executables) do
    if vim.fn.executable(exe) == 1 then
      vim.health.ok(string.format("Found executable: '%s'", exe))
      return
    end
  end

  vim.health.warn(string.format("Could not find any executable: '%s'", table.concat(executables, "', '")))
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
  check_executables('Core executables', { 'git', 'make', 'unzip', 'rg', 'fd' })
  check_executables('Node/web executables', { 'node', 'yarn' })
  check_executables('Format/lint executables', { 'jq', 'stylua', 'luacheck', 'markdownlint', 'stylelint' })
  check_any_executable('Prettier executable', { 'prettierd', 'prettier' })
  check_executables('Git UI executables', { 'gh', 'lazygit' })
  check_executables('AI/session/debug executables', { 'tmux', 'python3' })
  check_vtsls_patch()

  return true
end

return {
  check = function()
    vim.health.start 'kickstart.nvim'

    vim.health.info [[NOTE: Not every warning is a 'must-fix' in `:checkhealth`

  Fix only warnings for plugins and languages you intend to use.
    Mason will give warnings for languages that are not installed.
    You do not need to install, unless you want to use those languages!]]

    local uv = vim.uv or vim.loop
    vim.health.info('System Information: ' .. vim.inspect(uv.os_uname()))

    check_version()
    check_external_reqs()
  end,
}
