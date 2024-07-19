local M = {}

M.config = function ()
  require('flash').setup({
    label = {
      min_pattern_length = 2,
      rainbow = {
        enabled = true,
        shade = 5
      },
    },
    modes = {
      search = {
        enabled = true,
      },
    },
  })
end

return M
