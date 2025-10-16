return {
  'folke/trouble.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  specs = {
    "folke/snacks.nvim",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts or {}, {
        picker = {
          actions = require("trouble.sources.snacks").actions,
          win = {
            input = {
              keys = {
                ["<c-h>"] = {
                  "trouble_open",
                  mode = { "n", "i" },
                },
              },
            },
          },
        },
      })
    end,
  },
  cmd = "Trouble",
  opts = {
    focus = true,
    ---@type trouble.Window.opts
    win = {
      type = 'split',
      position = 'right',
      size = 0.2,
    },
    modes = {
      cascade = {
        mode = 'diagnostics', -- inherit from diagnostics mode
        filter = function(items)
          local severity = vim.diagnostic.severity.HINT
          for _, item in ipairs(items) do
            severity = math.min(severity, item.severity)
          end
          return vim.tbl_filter(function(item)
            return item.severity == severity
          end, items)
        end,
      },
      diagnostics_buffer = {
        mode = 'diagnostics', -- inherit from diagnostics mode
        filter = { buf = 0 }, -- filter diagnostics to the current buffer
      },
    },
  },
  keys = {
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics_buffer toggle<cr>",
      desc = "Diagnostics Buffer",
    },
    {
      "<leader>xf",
      function()
        ---@diagnostic disable-next-line: missing-parameter
        require("trouble").focus()
      end,
      desc = "Focus Trouble",
    },
    {
      "<leader>xc",
      "<cmd>Trouble cascade toggle<cr>",
      desc = "Cascade",
    },
    {
      "<leader>xs",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "Symbols",
    },
    {
      "<leader>xl",
      "<cmd>Trouble lsp toggle focus=false<cr>",
      desc = "LSP",
    },
    {
      "<leader>xn",
      "<cmd>Trouble snacks toggle<cr>",
      desc = "Snacks",
    },
    {
      "<leader>xN",
      "<cmd>Trouble snacks_files toggle<cr>",
      desc = "Snacks Files",
    },
    {
      "<leader>xq",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List",
    },
  },
}
