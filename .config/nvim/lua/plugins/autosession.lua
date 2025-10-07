return {
  'rmagatti/auto-session',
  lazy = false,
  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    suppressed_dirs = { '~/', '~/Developer', '~/Downloads', '/' },
    bypass_save_filetypes = { 'alpha', 'dashboard' },
    auto_create = false,
  },
  keys = {
    -- Will use Telescope if installed or a vim.ui.select picker otherwise
    { '<leader>ss', '<cmd>AutoSession search<CR>', desc = 'Session search' },
  },
}
