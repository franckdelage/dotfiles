local M = {}

M.config = function ()
  require("snacks").setup({
    animate = { enabled = true },
    bigfile = { enabled = true },
    dim = { enabled = true },
    input = { enabled = true },
    lazygit = { enabled = true },
    notifier = { enabled = true },
    scratch = { enabled = true },
    scroll = { enabled = true },
    toggle = { enabled = true },
    words = { enabled = true },
    zen = { enabled = true },
  })
end

return M
