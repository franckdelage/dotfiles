-- Luacheck configuration for Neovim config
-- See: https://luacheck.readthedocs.io/en/stable/config.html

-- Use LuaJIT standard library
std = "luajit"

-- Define global variables that are valid in Neovim context
globals = {
  "vim",      -- Neovim API
  "Snacks",   -- Snacks.nvim plugin
  "reload",   -- Custom reload function
}

-- Ignore unused self warnings (common in OOP Lua)
self = false

-- Maximum line length (matching your style guide)
max_line_length = 200

-- Maximum cyclomatic complexity
max_cyclomatic_complexity = 15

-- Don't report unused arguments that start with underscore
unused_args = false

-- Files/directories to exclude from checking
exclude_files = {
  "lua/snippets/**",  -- Generated or template files
}
