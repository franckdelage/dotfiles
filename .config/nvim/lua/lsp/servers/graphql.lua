local M = {}

-- GraphQL language server
M.servers = {
  graphql = {
    cmd = { 'graphql-lsp', 'server', '-m', 'stream' },
    filetypes = { 'graphql', 'typescript' },
    root_patterns = { '.git', '.graphqlconfig' },
    name = 'graphql',
  },
}

return M