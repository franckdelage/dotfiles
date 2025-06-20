return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>lf',
        function()
          if vim.bo.filetype == 'typescript' then
            -- vim.cmd("LspEslintFixAll")
            vim.lsp.buf.format()
          elseif vim.bo.filetype == "htmlangular" then
            -- vim.lsp.buf.format()
            require('conform').format { async = true, lsp_format = 'fallback' }
            -- elseif vim.bo.filetype == "scss" then
            --   vim.lsp.buf.format()
          else
            require('conform').format { async = true, lsp_format = 'fallback' }
          end
        end,
        mode = '',
        desc = 'Format buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = false,
      -- format_on_save = function(bufnr)
      --   -- Disable "format_on_save lsp_fallback" for languages that don't
      --   -- have a well standardized coding style. You can add additional
      --   -- languages here or re-enable it for the disabled ones.
      --   local disable_filetypes = { c = true, cpp = true }
      --   if disable_filetypes[vim.bo[bufnr].filetype] then
      --     return nil
      --   else
      --     return {
      --       timeout_ms = 500,
      --       lsp_format = 'fallback',
      --     }
      --   end
      -- end,
      formatters_by_ft = {
        -- javascript = { "eslint" },
        -- typescript = { "eslint" },
        html = { "eslint", "prettierd" },
        htmlangular = { "eslint", "prettierd" },
        css = { "prettierd" },
        scss = { "prettierd" },
        graphql = { "prettierd" },
        json = { "jq" },
        jsonc = { "jq" },
        lua = { "stylua" }
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
