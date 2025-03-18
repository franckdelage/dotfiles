local M = {}

M.config = function ()
  require("aerial").setup({
    filter_kind = false,
    layout = {
      default_direction = "prefer_left",
      min_width = 12,
    },
  })
end

return M
