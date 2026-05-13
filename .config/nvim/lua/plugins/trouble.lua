return {
  "folke/trouble.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
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
                ["<c-g>"] = {
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
    auto_jump = false,
    ---@type trouble.Window.opts
    win = {
      type = "split",
      position = "bottom",
      size = 0.2,
    },
    ---@type trouble.Window.opts
    preview = {
      type = "float",
      relative = "win",
      border = "rounded",
      title = "Trouble Preview",
      title_pos = "center",
      position = { 0, 0 },
      anchor = "SW",
      size = { width = 1, height = 40 },
      zindex = 200,
    },
    ---@type table<string, trouble.Mode>
    modes = {
      lsp_base = {
        filter = function(items)
          local current_ft = vim.bo.filetype
          return vim.tbl_filter(function(item)
            local path = item.file or item.filename
            if not path or type(path) ~= "string" then return true end

            if path:match("%.ngtypecheck%.ts$") then return false end

            if current_ft == "typescript" then
              if item.client == "angularls" then
                local is_html = path:match("%.html$") or path:match("%.htmlangular$")
                if not is_html then
                  return false
                end
              end
            end

            return true
          end, items)
        end,
      },
      cascade = {
        mode = "diagnostics", -- inherit from diagnostics mode
        filter = function(items)
          local severity = vim.diagnostic.severity.HINT
          for _, item in ipairs(items) do
            severity = math.min(severity, item.severity)
          end
          return vim.tbl_filter(function(item) return item.severity == severity end, items)
        end,
      },
      diagnostics_buffer = {
        mode = "diagnostics", -- inherit from diagnostics mode
        filter = { buf = 0 }, -- filter diagnostics to the current buffer
      },
      symbols = {
        desc = "document symbols",
        mode = "lsp_document_symbols",
        win = { position = "right" },
        preview = {
          type = "main",
        },
        focus = true,
        filter = {
          -- remove Package since luals uses it for control flow structures
          ["not"] = { ft = "lua", kind = "Package" },
          any = {
            -- all symbol kinds for help / markdown files
            ft = { "help", "markdown" },
            -- default set of symbol kinds
            kind = {
              "Class",
              "Constructor",
              "Interface",
              "Method",
              "Property",
            },
          },
        },
      },
    },
  },
  keys = {
    ---@diagnostic disable-next-line: missing-parameter
    { "grf", function() require("trouble").focus() end, desc = "Focus Trouble" },
    { "gra", "<cmd>Trouble lsp toggle<cr>", desc = "LSP all - Trouble" },
    { "grr", "<cmd>Trouble lsp_references toggle<cr>", desc = "LSP references - Trouble" },
    { "gri", "<cmd>Trouble lsp_implementations toggle<cr>", desc = "LSP implementations - Trouble" },
    { "grd", "<cmd>Trouble lsp_definitions toggle<cr>", desc = "LSP definitions - Trouble" },
    { "gre", "<cmd>Trouble lsp_declarations toggle<cr>", desc = "LSP declarations - Trouble" },
    { "gro", "<cmd>Trouble lsp_document_symbols toggle<cr>", desc = "LSP document symbols - Trouble" },
    { "grt", "<cmd>Trouble lsp_type_definitions toggle<cr>", desc = "LSP type definitions - Trouble" },
    { "grc", "<cmd>Trouble cascade toggle<cr>", desc = "Cascade" },
    { "gry", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols" },
    { "grx", "<cmd>Trouble diagnostics_buffer toggle<cr>", desc = "Diagnostics Buffer" },
    { "grss", "<cmd>Trouble snacks toggle<cr>", desc = "Snacks" },
    { "grsf", "<cmd>Trouble snacks_files toggle<cr>", desc = "Snacks Files" },
    { "grq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List" },
  },
}
