local M = {}

M.config = function ()
  require("snacks").setup({
    animate = { enabled = true },
    bigfile = { enabled = true },
    bufdelete = { enabled = true },
    dim = {
      scope = {
        min_size = 3,
        max_size = 20,
        siblings = true,
      },
    },
    git = { enabled = true },
    gitbrowse = { enabled = true },
    input = { enabled = true },
    lazygit = { enabled = true },
    notifier = { enabled = true },
    picker = { enabled = true },
    scratch = { enabled = true },
    scroll = { enabled = true },
    toggle = { enabled = true },
    words = { enabled = true },
    zen = { enabled = true },
  })
end

return M
