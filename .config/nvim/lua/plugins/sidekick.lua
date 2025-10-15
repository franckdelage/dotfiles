return {
  "folke/sidekick.nvim",
  dependencies = { "zbirenbaum/copilot.lua" },
  enabled = true,
  lazy = true,
  opts = {
    -- add any options here
    cli = {
      mux = {
        backend = "tmux",
        enabled = true,
      },
    },
    nes = {
      enabled = true,
    }
  },
  keys = {
    {
      "<tab>",
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if not require("sidekick").nes_jump_or_apply() then
          return "<Tab>" -- fallback to normal tab
        end
      end,
      expr = true,
      desc = "Goto/Apply Next Edit Suggestion",
    },
    {
      "<c-.>",
      function() require("sidekick.cli").toggle() end,
      desc = "Sidekick Toggle",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>ma",
      function() require("sidekick.cli").toggle() end,
      desc = "Sidekick Toggle CLI",
    },
    {
      "<leader>ms",
      function() require("sidekick.cli").select() end,
      -- Or to select only installed tools:
      -- require("sidekick.cli").select({ filter = { installed = true } })
      desc = "Select CLI",
    },
    {
      "<leader>md",
      function() require("sidekick.cli").close() end,
      desc = "Detach a CLI Session",
    },
    {
      "<leader>mt",
      function() require("sidekick.cli").send({ msg = "{this}" }) end,
      mode = { "x", "n" },
      desc = "Send This",
    },
    {
      "<leader>mf",
      function() require("sidekick.cli").send({ msg = "{file}" }) end,
      desc = "Send File",
    },
    {
      "<leader>mv",
      function() require("sidekick.cli").send({ msg = "{selection}" }) end,
      mode = { "x" },
      desc = "Send Visual Selection",
    },
    {
      "<leader>mp",
      function() require("sidekick.cli").prompt() end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
    {
      "<leader>mc",
      function() require("sidekick.cli").toggle({ name = "copilot", focus = true }) end,
      desc = "Sidekick Toggle Copilot",
    },
    {
      "<leader>mo",
      function() require("sidekick.cli").toggle({ name = "opencode", focus = true }) end,
      desc = "Sidekick Toggle OpenCode",
    },
  },
}
