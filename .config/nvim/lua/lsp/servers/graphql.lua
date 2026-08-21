local M = {}

-- GraphQL language server, including gql templates embedded in JS/TS files.
M.servers = {
  graphql = {
    cmd = { 'graphql-lsp', 'server', '-m', 'stream' },
    filetypes = { 'graphql', 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    root_patterns = {
      '.graphqlconfig',
      '.graphqlrc',
      '.graphqlrc.json',
      '.graphqlrc.yaml',
      '.graphqlrc.yml',
      '.graphqlrc.js',
      '.graphqlrc.ts',
      'graphql.config.js',
      'graphql.config.ts',
      'graphql.config.json',
      'graphql.config.yaml',
      'graphql.config.yml',
      'nx.json',
      'package.json',
      '.git',
    },
    name = 'graphql',
    settings = function(root_dir)
      return {
        ['graphql-config'] = {
          load = {
            legacy = true,
            rootDir = root_dir,
          },
        },
      }
    end,
  },
}

return M
