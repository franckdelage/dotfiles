local M = {}

local deno_markers = { "deno.json", "deno.jsonc" }

M.servers = {
  deno = {
    cmd = { "deno", "lsp" },
    filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
    root_patterns = deno_markers,
    name = "denols",
    condition = function(path)
      local start_path = vim.fn.isdirectory(path) == 1 and path or vim.fs.dirname(path)
      return #vim.fs.find(deno_markers, { path = start_path, upward = true }) > 0
    end,
    settings = {
      deno = {
        enable = true,
        suggest = {
          imports = {
            hosts = {
              ["https://deno.land"] = true,
            },
          },
        },
      },
    },
  },
  postgres = {
    cmd = { "postgres-language-server", "lsp-proxy" },
    filetypes = { "sql" },
    root_patterns = { "postgres-language-server.jsonc", "config.toml", ".git" },
    name = "postgres_lsp",
  },
}

return M
