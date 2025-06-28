return {
  "github/copilot.vim",
  lazy = true,
  version = "latest",
  event = "InsertEnter",
  keys = {
    { "<Tab>", mode = "i", function() return vim.fn["copilot#Accept"]("<CR>") end, expr = true, silent = true, noremap = true },
    { "<C-E>", mode = "i", function() return vim.fn["copilot#Dismiss"]() end, expr = true, silent = true, noremap = true },
    { "<leader>ce", "<cmd>Copilot enable<cr>", desc = "Enable Copilot" },
    { "<leader>cd", "<cmd>Copilot disable<cr>", desc = "Disable Copilot" },
    { "<leader>ct", "<cmd>Copilot toggle<cr>", desc = "Toggle Copilot" },
    { "<leader>cr", "<cmd>Copilot reset<cr>", desc = "Reset Copilot" },
  },

}
