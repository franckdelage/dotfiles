-- Native LSP Configuration (Neovim 0.11+)
return {
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',

    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Mason for tool installation (keeping this for convenience)
    'williamboman/mason.nvim',
    opts = {},
  },
  {
    -- Tool installer for LSP servers and formatters
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
        'marksman',  -- Markdown language server
        'cucumber-language-server',  -- Cucumber/Gherkin language server
      },
    },
  },
  {
    -- Useful status updates for LSP.
    'j-hui/fidget.nvim',
    opts = {},
  },

}
-- vim: ts=2 sts=2 sw=2 et

