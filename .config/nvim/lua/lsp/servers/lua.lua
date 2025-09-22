local M = {}

-- Lua language server
M.servers = {
  lua = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_patterns = { '.git', 'lua/' },
    name = 'lua_ls',
    settings = {
      Lua = {
        completion = {
          callSnippet = 'Replace',
        },
        diagnostics = {
          disable = {
            'missing-fields',
          },
        },
      },
    },
  },
}

return M