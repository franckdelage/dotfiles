local M = {}

function M.vtsls_language_service_index()
  return vim.fs.joinpath(
    vim.fn.stdpath "data",
    "mason",
    "packages",
    "vtsls",
    "node_modules",
    "@vtsls",
    "language-server",
    "node_modules",
    "@vtsls",
    "language-service",
    "dist",
    "index.js"
  )
end

return M
