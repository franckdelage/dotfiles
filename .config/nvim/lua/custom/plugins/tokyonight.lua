return {
  'folke/tokyonight.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('tokyonight').setup {
      style = 'moon',
      dim_inactive = true,
      lualine_bold = true,
    }

   vim.cmd.colorscheme('tokyonight')
    -- vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
    -- vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
  end,
}
