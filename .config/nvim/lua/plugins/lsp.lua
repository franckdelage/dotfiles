return {
  {
    name = 'native-lsp',
    dir = vim.fn.stdpath('config') .. '/lua/lsp',
    config = function()
      require('lsp').setup()
    end,
  },
  {
    'folke/lazydev.nvim',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'williamboman/mason.nvim',
    opts = {},
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    opts = {
      ensure_installed = {
        'typescript-language-server',
        'lua-language-server',
        'eslint-lsp',
        'angular-language-server',
        'html-lsp',
        'emmet-language-server',
        'stylelint-lsp',
        'css-lsp',
        'some-sass-language-server',
        'stylelint-lsp',
        'graphql-language-service-cli',
        'stylua',
        'marksman',
        'cucumber-language-server',
      },
    },
  },
}
