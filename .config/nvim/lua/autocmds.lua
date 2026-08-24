-- Personal autocommands
-- See `:help nvim_create_autocmd` and `:help autocmd-events`

local augroup = vim.api.nvim_create_augroup("PersonalAutocmds", { clear = true })

vim.api.nvim_create_autocmd("User", {
  desc = "Open Oil preview when entering Oil buffer",
  group = augroup,
  pattern = "OilEnter",
  callback = vim.schedule_wrap(function(args)
    local data = args.data or {}
    local oil = require "oil"
    if data.buf and vim.api.nvim_get_current_buf() == data.buf and oil.get_cursor_entry() then
      oil.open_preview()
    end
  end),
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function() vim.highlight.on_yank() end,
})

-- Restart command
vim.api.nvim_create_user_command("Restart", function()
  vim.api.nvim_exec_autocmds("User", { pattern = "BeforeRestart" })
  vim.cmd "restart"
end, { desc = "Save the active session and restart Neovim" })

local before_restart_group = vim.api.nvim_create_augroup("PersonalBeforeRestart", { clear = true })

vim.api.nvim_create_autocmd("User", {
  desc = "Save the active AutoSession before restart",
  group = before_restart_group,
  pattern = "BeforeRestart",
  callback = function()
    local ok, session = pcall(require, "auto-session.lib")
    if not ok then return end

    local session_name = session.current_session_name(true)
    if not session_name or session_name == "" then return end

    local saved, err = pcall(vim.cmd, "AutoSession save " .. vim.fn.fnameescape(session_name))
    if not saved then
      vim.notify("Could not save session before restart: " .. tostring(err), vim.log.levels.WARN)
    end
  end,
})
