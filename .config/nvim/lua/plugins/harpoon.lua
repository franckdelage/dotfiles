return {
  "ThePrimeagen/harpoon",
  lazy = false,  -- Load immediately to ensure proper persistence
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require 'harpoon'
    harpoon:setup {
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
      }
    }

    -- basic telescope configuration
    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require("telescope.pickers")
        .new({}, {
          prompt_title = "Harpoon",
          finder = require("telescope.finders").new_table {
            results = file_paths,
          },
          previewer = conf.file_previewer {},
          sorter = conf.generic_sorter {},
        })
        :find()
    end

    -- Mark/add file to harpoon with notification
    vim.keymap.set("n", "<leader>m", function()
      local list = harpoon:list()
      list:add()

      -- Get the current file name and slot position
      local filename = vim.fn.expand "%:t"
      local slot = list:length()

      -- Show notification
      vim.notify(string.format("✓ Added to Harpoon: %s (slot %d)", filename, slot), vim.log.levels.INFO)
    end, { desc = "Mark file to Harpoon" })

    -- Harpoon quick menu
    vim.keymap.set("n", "<leader>vh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon menu" })

    -- Telescope picker (keep as requested - Option C)
    vim.keymap.set("n", "<leader>vv", function() toggle_telescope(harpoon:list()) end, { desc = "Harpoon telescope picker" })

    -- Quick jump to Harpoon slots 1-4
    vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon file 1" })

    vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon file 2" })

    vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon file 3" })

    vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon file 4" })
  end,
}
