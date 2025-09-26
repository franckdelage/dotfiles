local M = {}

-- GraphQL language server
M.servers = {
  graphql = {
    cmd = { 'graphql-lsp', 'server', '-m', 'stream' },
    filetypes = { 'graphql', 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    root_patterns = { '.graphqlrc', '.graphqlrc.json', '.graphqlrc.yaml', '.graphqlrc.yml', 'graphql.config.js', 'graphql.config.json', 'package.json', '.git' },
    name = 'graphql',
    settings = {
      graphql = {
        introspection = {
          file = 'schema.json'  -- Adjust path to your schema file
        }
      }
    },
    on_attach = function(client, bufnr)
      -- Only provide GraphQL features for template literals and .graphql files
      if vim.bo[bufnr].filetype ~= 'graphql' then
        -- Disable some LSP features for mixed files to avoid conflicts with tsserver
        client.server_capabilities.hoverProvider = false
        client.server_capabilities.definitionProvider = false
        client.server_capabilities.referencesProvider = false
      end
    end,
  },
}

return M