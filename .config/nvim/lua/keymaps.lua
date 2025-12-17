-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<leader>h', '<cmd>nohlsearch<CR>', { desc = 'Clear Highlight' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
vim.keymap.set('n', '-', function()
  require('oil').open_float()
end, { desc = 'Open parent directory' })

vim.keymap.set('n', '<leader>w', '<cmd>w<cr>', { desc = 'Save' })
vim.keymap.set('n', '<leader>q', '<cmd>q<cr>', { desc = 'Close buffer' })
vim.keymap.set('n', '<leader>W', '<cmd>wall<cr>', { desc = 'Save all' })
vim.keymap.set('n', '<leader>X', '<cmd>xall<cr>', { desc = 'Save all and quit' })

vim.keymap.set('n', '<leader>tc', '<cmd>tabnew<cr>', { desc = 'Tab new' })
vim.keymap.set('n', '<leader>td', '<cmd>tabclose<cr>', { desc = 'Tab close' })
vim.keymap.set('n', '<leader>tl', '<cmd>tabmove -1<cr>', { desc = 'Tab move left' })
vim.keymap.set('n', '<leader>tr', '<cmd>tabmove 1<cr>', { desc = 'Tab move right' })
vim.keymap.set('n', 'tg', 'gT', { desc = 'Previous tab' })

vim.keymap.set('n', '<leader>pt', '<cmd>Vtemplate<cr>', { desc = 'Template' })
vim.keymap.set('n', '<leader>pc', '<cmd>Vcomponent<cr>', { desc = 'Component' })
vim.keymap.set('n', '<leader>ps', '<cmd>Vspec<cr>', { desc = 'Spec' })
vim.keymap.set('n', '<leader>pa', '<cmd>Vscss<cr>', { desc = 'Stylesheet' })

vim.keymap.set('n', '<leader>kf', '<cmd>TestFile<cr>', { desc = 'Test file' })

vim.keymap.set('n', '<leader>Nl', '<cmd>Lazy<cr>', { desc = 'Open Lazy' })
vim.keymap.set('n', '<leader>Nm', '<cmd>Mason<cr>', { desc = 'Open Mason' })

-- vim: ts=2 sts=2 sw=2 et
