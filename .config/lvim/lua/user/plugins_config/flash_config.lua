local M = {}

M.config = function ()
  require('flash').setup({
    label = {
      rainbow = {
        enabled = true,
        shade = 5
      },
    },
    modes = {
      search = {
        enabled = false,
      },
    },
  })

  vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash" })
  vim.keymap.set("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })
  vim.keymap.set({ "n", "o", "x" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
  vim.keymap.set({ "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })
  vim.keymap.set({ "c" }, "<c-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })
end

return M
