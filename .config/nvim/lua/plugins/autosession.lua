return {
  "rmagatti/auto-session",
  lazy = false,
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    suppressed_dirs = { "~/", "~/Developer", "~/Downloads", "/" },
    bypass_save_filetypes = { "alpha", "dashboard" },
    auto_create = false,
    auto_restore = false,  -- Disable auto-restore to prevent clearing marks on startup

    -- Harpoon integration: ensure marks are saved/restored with sessions
    pre_save_cmds = {
      function()
        local ok, harpoon = pcall(require, "harpoon")
        if ok then
          pcall(function()
            harpoon:sync()
          end)
        end
      end,
    },

    post_restore_cmds = {
      function()
        -- This only runs when explicitly restoring a session via <leader>ss
        local ok, harpoon = pcall(require, "harpoon")
        if ok then
          pcall(function()
            -- Force reload from disk (Harpoon auto-loads, just verify)
            local list = harpoon:list()
            
            -- Show notification
            local count = list:length()
            if count > 0 then
              vim.notify(
                string.format("✓ Restored %d Harpoon mark%s", count, count == 1 and "" or "s"),
                vim.log.levels.INFO
              )
            end
          end)
        end
      end,
    },

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
