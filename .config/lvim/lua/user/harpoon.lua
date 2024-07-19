local M = {}

M.config = function ()
  require("harpoon").setup({
    global_settings = {
      save_on_toggle = false,
      save_on_change = true,
      enter_on_sendcmd = false,
      excluded_filetypes = { "harpoon" },
      mark_branch = false,
    },
  })
end

return M
