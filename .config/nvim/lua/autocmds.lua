-- Personal autocommands
-- See `:help nvim_create_autocmd` and `:help autocmd-events`

local augroup = vim.api.nvim_create_augroup('PersonalAutocmds', { clear = true })

vim.api.nvim_create_autocmd("User", {
  desc = "Open Oil preview when entering Oil buffer",
  group = augroup,
  pattern = "OilEnter",
  callback = vim.schedule_wrap(function(args)
    local oil = require("oil")
    if vim.api.nvim_get_current_buf() == args.data.buf and oil.get_cursor_entry() then
      oil.open_preview()
    end
  end),
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Restart command
vim.api.nvim_create_user_command("Restart", function()
  vim.api.nvim_exec_autocmds("User", {
    pattern = "BeforeRestart",
  })

  vim.cmd("restart")
end, {})

-- Hooks
local beforeRestartGroup = vim.api.nvim_create_augroup(
  "BeforeRestartHooks",
  { clear = true }
)

vim.api.nvim_create_autocmd("User", {
  group = beforeRestartGroup,
  pattern = "BeforeRestart",
  callback = function()
    vim.cmd("AutoSession save " .. require("auto-session.lib").current_session_name(true))
  end,
})
