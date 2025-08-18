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
            vim.lsp.buf.format()
          elseif vim.bo.filetype == "htmlangular" then
            require('conform').format { async = true, lsp_format = 'fallback' }
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
      formatters_by_ft = {
        javascript = { "eslint" },
        typescript = { "eslint" },
        html = { "eslint", "prettierd" },
        htmlangular = { "eslint", "prettierd" },
        css = { "prettierd" },
        scss = { "prettierd" },
        graphql = { "prettierd" },
        json = { "jq" },
        jsonc = { "jq" },
        lua = { "stylua" }
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
