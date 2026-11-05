return {
  "stevearc/aerial.nvim",
  cmd = { "AerialOpen", "AerialCloseAll", "AerialNavToggle", "AerialToggle" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    filter_kind = false,
    layout = {
      default_direction = "prefer_left",
      min_width = 12,
    },
  },
  keys = {
    { "<leader>ta", "<cmd>AerialOpen<cr>", desc = "Aerial Open" },
    { "<leader>tn", "<cmd>AerialNavToggle<cr>", desc = "Aerial Open navigation" },
    {
      "<leader>tt",
      function() require("aerial").snacks_picker() end,
      desc = "Aerial list symbols",
    },
    { "<leader>tx", "<cmd>AerialCloseAll<cr>", desc = "Aerial Close all" },
  },
}
