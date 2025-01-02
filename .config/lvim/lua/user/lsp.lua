local M = {}

M.config = function ()
  vim.g['test#javascript#runner'] = 'nx'
  vim.g['test#strategy'] = 'floaterm'

  vim.filetype.add({
    pattern = {
      [".*%.component%.html"] = "htmlangular",
    },
  })

  local lspconfig = require("lspconfig");

  require("lvim.lsp.manager").setup("angularls")
  local util = require('lspconfig.util')

  lspconfig.angularls.setup {
    root_dir = util.root_pattern('angular.json', 'nx.json'),
    filetypes = { 'typescript', 'html', 'htmlangular' },
  }

  lspconfig.html.setup({
    filetypes = { 'html', 'htmlangular' },
  })

  lspconfig.stylelint_lsp.setup({
    settings = {
      stylelintplus = {
        autoFixOnFormat = true,
      },
    },
    filetypes = { 'scss', 'sass' },
  })

  lspconfig.emmet_language_server.setup({
    filetypes = { 'html', 'htmlangular', 'css', 'scss', 'sass' },
  })

  lspconfig.graphql.setup {
    cmd = { "graphql-lsp", "server", "-m", "stream" },
    filetypes = { "graphql", "typescript" },
    root_dir = util.root_pattern('.git', '.graphqlconfig'),
  }

end

return M
