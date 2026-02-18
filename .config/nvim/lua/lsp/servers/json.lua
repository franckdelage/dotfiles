local M = {}

M.servers = {
  jsonls = {
    cmd = { 'vscode-json-languageserver', '--stdio' },
    filetypes = { 'json', 'jsonc' },
    root_patterns = { '.git' },
    name = 'jsonls',
    settings = {
      json = {
        validate = { enable = true },
        schemas = {
        },
      },
    },
    init_options = {
      provideFormatter = true,
    },
  },
}

return M
