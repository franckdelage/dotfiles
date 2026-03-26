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

-- Fix which-key trigger race condition on LspAttach.
--
-- which-key clears its trigger keymaps for a buffer synchronously inside its
-- own LspAttach handler (which-key/state.lua). At that exact moment Neovim's
-- mode API can still report the previous mode, so which-key re-attaches
-- triggers against a stale mode and the leader key stops working for that
-- buffer. Clearing the which-key buffer state one tick later (via
-- vim.schedule) gives Neovim time to settle, so which-key re-reads the
-- correct mode when it rebuilds the trigger keymaps.
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Re-attach which-key triggers after LSP attach (race condition fix)',
  group = vim.api.nvim_create_augroup('WhichKeyLspFix', { clear = true }),
  callback = function(event)
    vim.schedule(function()
      local ok, buf = pcall(require, 'which-key.buf')
      if ok then
        buf.clear({ buf = event.buf })
      end
    end)
  end,
})
