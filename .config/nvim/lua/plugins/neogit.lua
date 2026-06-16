return {
  "NeogitOrg/neogit",
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim", -- required

    -- Only one of these is needed.
    -- "sindrets/diffview.nvim", -- optional
    "esmuellert/codediff.nvim", -- optional

    -- Only one of these is needed.
    "folke/snacks.nvim", -- optional
  },
  cmd = "Neogit",
  keys = {
    { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
  },
  config = function()
    require("neogit").setup {
      integrations = {
        codediff = true,
        snacks = true,
      },
      diff_viewer = "codediff",
      graph_style = "unicode",
      signs = {
        -- { CLOSED, OPENED }
        hunk = { "", "" },
        item = { "", "" },
        section= { "", "" },
      },
      remember_settings = false,
      commit_editor = {
        staged_diff_split_kind = "auto",
        spell_check = true,
      },
      log_pager = { 'delta', '--width', '300' },
    }
  end,
}
