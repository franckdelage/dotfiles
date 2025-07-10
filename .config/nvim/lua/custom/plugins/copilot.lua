return {
  "github/copilot.vim",
  lazy = true,
  version = "latest",
  event = "InsertEnter",
  config = function()
    vim.g.copilot_filetypes = {
      ["markdown"] = false,
      ["text"] = false,
      ["gitcommit"] = false,
      ["help"] = false,
      ["TelescopePrompt"] = false,
      ["dashboard"] = false,
      ["alpha"] = false,
    }
  end,
  keys = {
    { "<C-H>", mode = "i", 'copilot#Accept("\\<CR>")', expr = true, replace_keycodes = false, silent = true, noremap = true },
    { "<C-E>", mode = "i", 'copilot#Dismiss()', expr = true, replace_keycodes = false, silent = true, noremap = true },
    { "<C-J>", mode = "i", 'copilot#Next()', expr = true, replace_keycodes = false, silent = true, noremap = true },
    { "<C-K>", mode = "i", 'copilot#Previous()', expr = true, replace_keycodes = false, silent = true, noremap = true },
    { "<leader>cc", "<cmd>Copilot status<cr>", desc = "Copilot Status" },
    { "<leader>ce", "<cmd>Copilot enable<cr>", desc = "Enable Copilot" },
    { "<leader>cd", "<cmd>Copilot disable<cr>", desc = "Disable Copilot" },
    { "<leader>cp", "<cmd>Copilot panel<cr>", desc = "Copilot Panel" },
  },

}
