return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      -- Install parsers (no-op if already installed)
      require('nvim-treesitter').install {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'typescript',
        'tsx',
        'javascript',
        'json',
        'graphql',
        'css',
        'scss',
        'yaml',
      }

      -- Enable treesitter highlighting for all filetypes.
      -- pcall guards against filetypes that have no parser installed.
      -- Note: treesitter indent (indentexpr) is intentionally not set here —
      -- it is broken on nvim-treesitter main for TypeScript/JavaScript.
      -- Waiting for upstream fix: https://github.com/nvim-treesitter/nvim-treesitter
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('nvim-treesitter-ft', { clear = true }),
        callback = function()
          pcall(vim.treesitter.start)
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.wo[0][0].foldmethod = 'expr'
        end,
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
