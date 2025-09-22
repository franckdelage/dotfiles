local M = {}

-- Markdown language server
M.servers = {
  marksman = {
    cmd = { 'marksman', 'server' },
    filetypes = { 'markdown' },
    root_patterns = { '.git', '.marksman.toml' },
    name = 'marksman',
    settings = {
      marksman = {
        -- Enable completion for wiki-style links
        completion = {
          wiki = {
            enabled = true
          }
        }
      }
    }
  },
}

return M