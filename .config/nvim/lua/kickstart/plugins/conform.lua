-- Configuration de formatage corrigée pour Angular/HTML
return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>lf',
        function()
          -- 🔧 LOGIQUE DE FORMATAGE CORRIGÉE
          local filetype = vim.bo.filetype
          
          if filetype == 'typescript' or filetype == 'typescriptreact' then
            -- Pour TypeScript, utiliser le LSP en premier puis Conform en fallback
            vim.lsp.buf.format({ 
              async = true,
              timeout_ms = 2000,
              filter = function(client)
                -- Éviter ESLint pour le formatage, utiliser ts_ls
                return client.name ~= 'eslint'
              end
            })
          elseif filetype == 'htmlangular' or filetype == 'html' then
            -- Pour HTML Angular, utiliser Conform avec les bons formatters
            require('conform').format { 
              async = true, 
              timeout_ms = 2000,
              lsp_format = 'never' -- Éviter les conflits LSP
            }
          elseif filetype == 'scss' or filetype == 'css' then
            -- Pour SCSS/CSS, utiliser le LSP en premier
            vim.lsp.buf.format({ async = true, timeout_ms = 2000 })
          else
            -- Pour les autres types, utiliser Conform avec fallback LSP
            require('conform').format { async = true, lsp_format = 'fallback' }
          end
        end,
        mode = '',
        desc = 'Format buffer',
      },
    },
    opts = {
      notify_on_error = true,
      format_on_save = false, -- Désactivé pour éviter les conflits
      -- 🔧 CONFIGURATION DE FORMATAGE CORRIGÉE
      formatters_by_ft = {
        -- JavaScript/TypeScript - Utiliser Prettier uniquement
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        
        -- HTML/Angular - Prettier en premier, puis fallback
        html = { "prettierd", "prettier", stop_after_first = true },
        htmlangular = { "prettierd", "prettier", stop_after_first = true },
        
        -- CSS/SCSS - Prettier
        css = { "prettierd", "prettier", stop_after_first = true },
        scss = { "prettierd", "prettier", stop_after_first = true },
        sass = { "prettierd", "prettier", stop_after_first = true },
        
        -- Autres formats
        graphql = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        jsonc = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        
        -- Lua
        lua = { "stylua" },
      },
      
      -- 🔧 CONFIGURATION DES FORMATTERS
      formatters = {
        prettierd = {
          condition = function(self, ctx)
            -- Vérifier si un fichier de config Prettier existe
            return vim.fs.find({
              '.prettierrc',
              '.prettierrc.json',
              '.prettierrc.js',
              '.prettierrc.cjs',
              'prettier.config.js',
              'prettier.config.cjs',
            }, { path = ctx.filename, upward = true })[1]
          end,
        },
        prettier = {
          condition = function(self, ctx)
            -- Fallback si prettierd n'est pas disponible
            return vim.fs.find({
              '.prettierrc',
              '.prettierrc.json',
              '.prettierrc.js',
              '.prettierrc.cjs',
              'prettier.config.js',
              'prettier.config.cjs',
            }, { path = ctx.filename, upward = true })[1]
          end,
        },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et

