return {
  "nvim-focus/focus.nvim",
  version = false,
  config = function()
    require("focus").setup {}

    vim.keymap.set("n", "<leader>rf", function() require("focus").focus_toggle() end, { desc = "Toggle Focus Mode" })
    vim.keymap.set("n", "<leader>re", function() require("focus").focus_equalise() end, { desc = "Equalize" })
    vim.keymap.set("n", "<leader>rs", function() require("focus").split_nicely() end, { desc = "Split Nicely" })

    local focusmap = function(direction)
      vim.keymap.set("n", "<leader>r" .. direction, function() require("focus").split_command(direction) end, { desc = string.format("Create or move to split (%s)", direction) })
    end
    focusmap "h"
    focusmap "j"
    focusmap "k"
    focusmap "l"
  end,
}
