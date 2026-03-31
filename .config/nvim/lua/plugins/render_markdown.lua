return {
  'MeanderingProgrammer/render-markdown.nvim',
  opts = {
    overrides = {
      buftype = {
        nofile = { enabled = false },
      },
    },
  },
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
}
