return {
  -- Import Mason DAP setup
  require("debug.mason")[1],

  -- Main DAP plugin
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "igorlfs/nvim-dap-view",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",
    },
    keys = require "debug.keymaps",
    config = function() require("debug.init").setup() end,
  },
}
