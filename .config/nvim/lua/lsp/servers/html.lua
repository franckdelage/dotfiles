local M = {}

-- HTML language server
M.servers = {
  html = {
    cmd = { 'vscode-html-language-server', '--stdio' },
    filetypes = { 'html' },
    root_patterns = { 'nx.json', '.git' },
    name = 'html',
    settings = {
      html = {
        format = {
          enable = true,
        },
        hover = {
          documentation = true,
          references = true,
        },
      },
    },
  },
}

return M
