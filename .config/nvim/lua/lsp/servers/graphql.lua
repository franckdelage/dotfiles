local M = {}

-- GraphQL language server with Apollo Angular optimizations
M.servers = {
  graphql = {
    cmd = { 'graphql-lsp', 'server', '-m', 'stream' },
    filetypes = { 'graphql', 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    root_patterns = {
      '.graphqlconfig',
      'apps/gql/.graphqlconfig',
      'apollo.config.js',
      'apollo.config.json',
      '.graphqlrc*',
      'graphql.config.*',
      'codegen.yml',
      'codegen.yaml',
      'nx.json',
      'package.json',
      '.git',
    },
    name = 'graphql',
    settings = {
      graphql = {
        introspection = {
          file = './apps/gql/schema.graphql',
        },
        completion = {
          externalFragments = true,
          addTypename = true,
          useSchemaIntrospection = true,
        },
        validation = {
          rules = {
            'KnownTypeNames',
            'UniqueFragmentNames',
            'KnownFragmentNames',
            'NoUnusedFragments',
            'FieldsOnCorrectType',
            'FragmentsOnCompositeTypes',
          },
        },
        apollo = {
          service = {
            name = 'default',
            localSchemaFile = './apps/gql/schema.graphql',
          },
        },
      },
    },
    on_attach = function(client, bufnr)
      local filetype = vim.bo[bufnr].filetype

      if filetype == 'graphql' then
        -- Full GraphQL features for .graphql files
        return
      end

      -- For TypeScript files with Apollo
      if filetype == 'typescript' or filetype == 'typescriptreact' then
        -- Enable GraphQL features for gql template literals
        client.server_capabilities.hoverProvider = true
        client.server_capabilities.completionProvider = {
          triggerCharacters = { '{', '(', '$', '@', '.', ' ', 'g', 'q', 'l' },
          resolveProvider = true,
        }
        client.server_capabilities.documentFormattingProvider = false -- Let Prettier handle this

        -- Keep definition/references disabled to avoid conflicts with tsserver
        client.server_capabilities.definitionProvider = false
        client.server_capabilities.referencesProvider = false
      end
    end,
  },
}

return M

