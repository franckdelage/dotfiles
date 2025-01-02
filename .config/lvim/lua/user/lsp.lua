local M = {}

M.config = function ()
  vim.g['test#javascript#runner'] = 'nx'
  vim.g['test#strategy'] = 'floaterm'

  vim.filetype.add({
    pattern = {
      [".*%.component%.html"] = "htmlangular",
    },
  })

  local capabilities = require("blink.cmp").get_lsp_capabilities()

  local lspconfig = require("lspconfig");

  require("lvim.lsp.manager").setup("angularls")
  local util = require('lspconfig.util')

  lspconfig.angularls.setup {
    root_dir = util.root_pattern('angular.json', 'nx.json'),
    filetypes = { 'typescript', 'html', 'htmlangular' },
    capabilities = capabilities,
  }

  lspconfig.html.setup({
    filetypes = { 'html', 'htmlangular' },
    capabilities = capabilities,
  })

  lspconfig.stylelint_lsp.setup({
    settings = {
      stylelintplus = {
        autoFixOnFormat = true,
      },
    },
    filetypes = { 'scss', 'sass' },
    capabilities = capabilities,
  })

  lspconfig.emmet_language_server.setup({
    filetypes = { 'html', 'htmlangular', 'css', 'scss', 'sass' },
    capabilities = capabilities,
  })

  lspconfig.graphql.setup {
    cmd = { "graphql-lsp", "server", "-m", "stream" },
    filetypes = { "graphql", "typescript" },
    root_dir = util.root_pattern('.git', '.graphqlconfig'),
    capabilities = capabilities,
  }

end

return M
