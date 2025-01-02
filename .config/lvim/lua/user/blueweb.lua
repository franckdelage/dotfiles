local M = {}

M.config = function ()
  vim.g['test#javascript#runner'] = 'nx'
  vim.g['test#strategy'] = 'floaterm'

  vim.filetype.add({
    pattern = {
      [".*%.component%.html"] = "htmlangular",
    },
  })

  require("lvim.lsp.manager").setup("angularls")
  local util = require('lspconfig.util')

  -- local project_library_path = "/Users/franckdelage/Developer/bw-blueweb"
  -- local angularls_library_path = "~/.nvm/versions/node/v22.11.0/lib/node_modules"
  -- local angularls_library_path = "/Users/franckdelage/.local/share/lvim/mason/packages/angular-language-server/node_modules/@angular/language-server/node_modules/@angular/language-service"
  -- local cmd = { "ngserver", "--stdio", "--tsProbeLocations", angularls_library_path, "--ngProbeLocations", angularls_library_path }

  require 'lspconfig'.angularls.setup {
    -- cmd = cmd,
    root_dir = util.root_pattern('angular.json', 'nx.json'),
    filetypes = { 'typescript', 'html', 'htmlangular' },
    -- on_new_config = function(new_config)
    --  new_config.cmd = cmd
    -- end,
  }

  require("lspconfig").emmet_language_server.setup({
    filetypes = { 'html', 'htmlangular', 'css', 'scss', 'sass' },
  })

  -- require("lvim.lsp.manager").setup("graphql-lsp")
  require 'lspconfig'.graphql.setup {
    cmd = { "graphql-lsp", "server", "-m", "stream" },
    filetypes = { "graphql", "typescript" },
    root_dir = util.root_pattern('.git', '.graphqlconfig'),
  }

end

return M
