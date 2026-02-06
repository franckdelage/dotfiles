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

-- Ensure leader key is properly set after session restoration
local function ensure_leader()
  if vim.g.mapleader ~= ' ' then
    vim.g.mapleader = ' '
    vim.g.maplocalleader = ' '
  end
end

-- Re-establish leader key after session restoration
vim.api.nvim_create_autocmd('SessionLoadPost', {
  desc = 'Ensure leader key is set after session load',
  group = vim.api.nvim_create_augroup('FixLeaderAfterSession', { clear = true }),
  callback = ensure_leader,
})

-- Backup: also check on BufEnter in case SessionLoadPost doesn't fire
vim.api.nvim_create_autocmd('BufEnter', {
  desc = 'Ensure leader key is set on buffer enter (backup)',
  group = vim.api.nvim_create_augroup('FixLeaderBackup', { clear = true }),
  callback = function()
    -- Only run once per session to avoid overhead
    if not vim.g.leader_fixed then
      ensure_leader()
      vim.g.leader_fixed = true
    end
  end,
})

local ignore_filetypes = { 'neo-tree', 'neotest-summary' }
local ignore_buftypes = { 'nofile', 'prompt', 'popup' }

local focusgroup =
    vim.api.nvim_create_augroup('FocusDisable', { clear = true })

vim.api.nvim_create_autocmd('WinEnter', {
    group = focusgroup,
    callback = function(_)
        if vim.tbl_contains(ignore_buftypes, vim.bo.buftype)
        then
            vim.w.focus_disable = true
        else
            vim.w.focus_disable = false
        end
    end,
    desc = 'Disable focus autoresize for BufType',
})

vim.api.nvim_create_autocmd('FileType', {
    group = focusgroup,
    callback = function(_)
        if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
            vim.b.focus_disable = true
        else
            vim.b.focus_disable = false
        end
    end,
    desc = 'Disable focus autoresize for FileType',
})
