local M = {}

-- Combine all server configurations
local function merge_servers(...)
  local result = {}
  for _, module in ipairs({...}) do
    for name, config in pairs(module.servers) do
      result[name] = config
    end
  end
  return result
end

-- Import all server modules
local typescript = require('lsp.servers.typescript')
local html = require('lsp.servers.html')
local angular = require('lsp.servers.angular')
local eslint = require('lsp.servers.eslint')
local lua_servers = require('lsp.servers.lua')
local styling = require('lsp.servers.styling')
local markdown = require('lsp.servers.markdown')
local graphql = require('lsp.servers.graphql')
local testing = require('lsp.servers.testing')

-- Combine all servers
M.servers = merge_servers(
  typescript,
  html,
  angular,
  eslint,
  lua_servers,
  styling,
  markdown,
  graphql,
  testing
)

return M