return {
  "rmagatti/auto-session",
  lazy = false,
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    suppressed_dirs = { "~/", "~/Developer", "~/Downloads", "/" },
    bypass_save_filetypes = { "alpha", "dashboard" },
    auto_create = false,
    session_lens = {
      picker = "snacks",
      preset = "dropdown",
      picker_opts = {
        layout = {
          width = 0.4,
          height = 0.4,
        },
      },
    },
  },
  keys = {
    -- Will use Telescope if installed or a vim.ui.select picker otherwise
    { "<leader>ss", "<cmd>AutoSession search<CR>", desc = "Session search" },
  },
}
