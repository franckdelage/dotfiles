local function list() return require("harpoon"):list() end

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {
      "<leader>m",
      function()
        local harpoon_list = list()
        harpoon_list:add()
        vim.notify(
          ("✓ Added to Harpoon: %s (slot %d)"):format(vim.fn.expand "%:t", harpoon_list:length()),
          vim.log.levels.INFO
        )
      end,
      desc = "Mark file to Harpoon",
    },
    {
      "<leader>vh",
      function()
        local harpoon = require "harpoon"
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = "Harpoon menu",
    },
    { "<leader>1", function() list():select(1) end, desc = "Harpoon file 1" },
    { "<leader>2", function() list():select(2) end, desc = "Harpoon file 2" },
    { "<leader>3", function() list():select(3) end, desc = "Harpoon file 3" },
    { "<leader>4", function() list():select(4) end, desc = "Harpoon file 4" },
    { "<leader>5", function() list():select(5) end, desc = "Harpoon file 5" },
  },
  config = function()
    local harpoon = require "harpoon"
    harpoon:setup {
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
      },
    }
    harpoon:extend(require("harpoon.extensions").builtins.highlight_current_file())
  end,
}
