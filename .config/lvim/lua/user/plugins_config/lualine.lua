local M = {}

M.config = function ()
  local components = require("lvim.core.lualine.components")
  lvim.builtin.lualine.sections.lualine_x = {
    components.diagnostics,
    components.lsp,
    components.spaces,
    components.filetype,
    components.treesitter,
  }
  lvim.builtin.lualine.sections.lualine_y = {
    components.location,
    components.filename,
  }
  lvim.builtin.lualine.sections.lualine_c = {
    function ()
      return require("auto-session.lib").current_session_name(true)
    end,
  }
end

return M
