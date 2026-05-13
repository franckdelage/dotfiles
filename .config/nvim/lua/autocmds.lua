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
-- which-key's own LspAttach handler calls buf.clear() synchronously, but at
-- that moment Neovim's mode API can still return a stale value. which-key
-- then re-attaches triggers against the wrong mode and all keymaps stop
-- working for that buffer. Wiping just that buffer's entry from buf.bufs one
-- tick later (via vim.schedule) forces which-key's internal 50ms polling
-- timer to rebuild the trigger keymaps from scratch with the correct mode.
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Re-attach which-key triggers after LSP attach (race condition fix)',
  group = vim.api.nvim_create_augroup('WhichKeyLspFix', { clear = true }),
  callback = function(event)
    vim.schedule(function()
      local ok, buf = pcall(require, 'which-key.buf')
      if ok and buf.bufs[event.buf] then
        buf.bufs[event.buf] = nil
      end
    end)
  end,
})

-- Manual escape hatch: instantly resets all which-key trigger caches.
-- Use :WKReset when keymaps stop responding, instead of :Lazy reload which-key.nvim.
vim.api.nvim_create_user_command('WKReset', function()
  local ok, buf = pcall(require, 'which-key.buf')
  if ok then
    buf.bufs = {}
    vim.notify('which-key trigger cache reset', vim.log.levels.INFO)
  end
end, { desc = 'Reset which-key trigger cache' })
