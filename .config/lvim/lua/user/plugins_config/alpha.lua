local M = {}

M.config = function ()
  table.insert(
    lvim.builtin.alpha.dashboard.section.buttons.entries,
    2,
    { "s", lvim.icons.ui.Project .. "  Open Session", "<cmd>Telescope possession list<cr>" }
  )
end

return M
