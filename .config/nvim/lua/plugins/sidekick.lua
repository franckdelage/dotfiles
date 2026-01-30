return {
  "folke/sidekick.nvim",
  lazy = false,
  opts = {
    -- add any options here
    cli = {
      mux = {
        enabled = true,
        backend = "tmux",
        create = "split",
        split = {
          size = 0.25,
        },
      },
    },
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
    { "<leader>am", "<cmd>Sidekick nes update<cr>", mode = { "n" }, desc = "Update NES Suggestions" },
    { "<leader>ax", "<cmd>Sidekick nes clear<cr>", mode = { "n", "i", "x", "t" }, desc = "Clear NES Suggestions" },
    { "<c-g>", function() require("sidekick.cli").toggle({ filter = { installed = true } }) end, desc = "Sidekick Toggle", mode = { "n", "t", "i", "x" } },
    { "<leader>aa", function() require("sidekick.cli").toggle({ filter = { installed = true } }) end, desc = "Sidekick Toggle CLI" },
    { "<leader>as", function() require("sidekick.cli").select({ filter = { installed = true } }) end, desc = "Select CLI" },
    { "<leader>ad", function() require("sidekick.cli").close() end, desc = "Detach a CLI Session" },
    { "<leader>af", function() require("sidekick.cli").send({ msg = "{file}", filter = { installed = true } }) end, desc = "Send File" },
    {
      "<leader>at",
      function() require("sidekick.cli").send({ msg = "{this}", filter = { installed = true } }) end,
      mode = { "x", "n" },
      desc = "Send This",
    },
    {
      "<leader>av",
      function() require("sidekick.cli").send({ msg = "{selection}", filter = { installed = true } }) end,
      mode = { "x" },
      desc = "Send Visual Selection",
    },
    {
      "<leader>ap",
      function() require("sidekick.cli").prompt({ filter = { installed = true } }) end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
    {
      "<leader>ac",
      function() require("sidekick.cli").toggle({ name = "copilot", focus = true }) end,
      desc = "Sidekick Toggle Copilot",
    },
    {
      "<leader>ao",
      function() require("sidekick.cli").toggle({ name = "opencode", focus = true }) end,
      desc = "Sidekick Toggle OpenCode",
    },
  },
}
