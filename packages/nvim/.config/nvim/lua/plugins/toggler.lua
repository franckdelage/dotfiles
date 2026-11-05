return {
  'nguyenvukhang/nvim-toggler',
  config = function()
    require('nvim-toggler').setup {
      remove_default_keybinds = true,
    }

    vim.keymap.set({ 'n', 'v' }, '<leader>ut', require('nvim-toggler').toggle, { desc = 'Toggler' })
  end,
}
