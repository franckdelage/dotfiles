-- [[ Built-in opt-in plugins ]]
-- Neovim ships some plugins as opt-in (like tohtml). Load them here,
-- after lazy.nvim has set up its loader, to avoid module resolution conflicts.

vim.cmd 'packadd nvim.undotree'
