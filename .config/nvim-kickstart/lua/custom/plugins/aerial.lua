return {
  'stevearc/aerial.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    filter_kind = false,
    layout = {
      default_direction = "prefer_left",
      min_width = 12,
    },
  }
}
