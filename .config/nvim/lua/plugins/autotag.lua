return {
  {
    'windwp/nvim-ts-autotag',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = 'nvim-treesitter/nvim-treesitter',
    opts = {
      opts = {
        enable_close = true, -- Auto close tags
        enable_rename = true, -- Auto rename pairs of tags
        enable_close_on_slash = true, -- Auto close on trailing </
      },
      per_filetype = {
        ["html"] = {
          enable_close = true
        },
        ["htmlangular"] = {
          enable_close = true
        },
        ["typescript"] = {
          enable_close = true
        },
        ["tsx"] = {
          enable_close = true
        }
      }
    },
  },
}