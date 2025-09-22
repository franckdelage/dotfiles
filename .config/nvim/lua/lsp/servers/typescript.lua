local M = {}

-- TypeScript language server
M.servers = {
  typescript = {
    cmd = { 'typescript-language-server', '--stdio' },
    filetypes = { 'typescript', 'javascript' },
    root_patterns = { 'angular.json', 'nx.json', 'package.json', 'tsconfig.json' },
    name = 'ts_ls',
  },
}

return M