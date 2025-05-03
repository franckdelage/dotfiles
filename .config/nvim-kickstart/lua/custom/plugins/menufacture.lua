return {
  'molecule-man/telescope-menufacture',
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    require('telescope').load_extension 'menufacture'
  end,
}
