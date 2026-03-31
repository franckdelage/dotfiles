return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
  },
  opts = {
    presets = {
      bottom_search = false, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
    },
    views = {
      hover = {
        border = {
          style = 'rounded',
          padding = { 0, 1 },
        },
        position = { row = 2, col = 0 },
      },
    },
  },
}
