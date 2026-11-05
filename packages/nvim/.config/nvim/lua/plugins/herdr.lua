return {
  "ChmaraX/herdr-nvim",
  opts = {
    keymaps = false,
  },
  keys = {
    {
      "<leader>cc",
      function() require("herdr-nvim").comment_line() end,
      mode = "n",
      desc = "Herdr: comment line",
    },
    {
      "<leader>cc",
      function() require("herdr-nvim").comment_selection() end,
      mode = "x",
      desc = "Herdr: comment selection",
    },
    {
      "<leader>cl",
      function() require("herdr-nvim").list_comments() end,
      desc = "Herdr: list comments",
    },
    {
      "<leader>cs",
      "<Cmd>Herdr send<CR>",
      desc = "Herdr: paste comments to agent",
    },
    {
      "<leader>cS",
      "<Cmd>Herdr submit<CR>",
      desc = "Herdr: send comments to agent",
    },
    {
      "<leader>ci",
      function() require("herdr-nvim").ref_line() end,
      mode = "n",
      desc = "Herdr: reference line",
    },
    {
      "<leader>ci",
      function() require("herdr-nvim").ref_selection() end,
      mode = "x",
      desc = "Herdr: reference selection",
    },
  },
}
