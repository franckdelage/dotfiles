local M = {}

M.config = function ()
  require("treesitter-context").setup {
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    max_lines = 2, -- How many lines the window should span. Values <= 0 mean no limit.
    trim_scope = 'outer',
  }
end

return M
