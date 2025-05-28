return {
  'pmizio/typescript-tools.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  opts = {},
  config = function()
    require('typescript-tools').setup {
      settings = {
        separate_diagnostic_server = false,
        expose_as_code_actions = {
          'fix_all',
          'add_missing_imports',
          'remove_unused',
          'remove_unused_imports',
        },
      },
    }
    vim.keymap.set('n', '<leader>lm', '<cmd>TSToolsAddMissingImports<cr>', { desc = 'Add missing imports' })
    vim.keymap.set('n', '<leader>lx', '<cmd>TSToolsRemoveUnusedImports<cr>', { desc = 'Remove unused imports' })
    vim.keymap.set('n', '<leader>la', '<cmd>TSToolsFixAll<cr>', { desc = 'Fix all TS' })
  end,
}
