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
    -- Compatibility shim for Neogit's legacy CodeDiff explorer schema.
    -- Remove when https://github.com/NeogitOrg/neogit/issues/2008 is fixed.
    local codediff_view = require "codediff.ui.view"
    local codediff_path = require "codediff.core.path"
    local original_create = codediff_view.create

    codediff_view.create = function(session_config, filetype, on_ready)
      if session_config.mode == "explorer" and not session_config.panel then
        session_config.panel = {
          name = "explorer",
          data = session_config.explorer_data or {},
        }
        session_config.original = session_config.original or codediff_path.empty()
        session_config.modified = session_config.modified or codediff_path.empty()
      end

      return original_create(session_config, filetype, on_ready)
    end

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
    }
  end,
}
