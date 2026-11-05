return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  init = function() vim.treesitter.language.register("markdown", "octo") end,
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    file_types = { "markdown", "octo" },
    completions = {
      blink = {
        enabled = true,
      },
    },
    overrides = {
      buftype = {
        nofile = { enabled = false },
      },
    },
  },
}
