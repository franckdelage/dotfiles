return {
  {
    name = 'native-lsp',
    dir = vim.fn.stdpath('config') .. '/lua/lsp',
    config = function()
      require('lsp').setup()
    end,
  },
  {
    'folke/lazydev.nvim',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'williamboman/mason.nvim',
    opts = {},
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    config = function(_, opts)
      require('mason-tool-installer').setup(opts)
      -- Re-apply the vtsls patch after every install/update.
      -- vtsls re-throws TypeScriptServerError on failed tsserver responses,
      -- killing the process. VSCode's equivalent code path logs and continues.
      -- See: scripts/patch-vtsls.py for details.
      vim.api.nvim_create_autocmd('User', {
        pattern = 'MasonToolsUpdateCompleted',
        callback = function()
          local script = vim.fn.stdpath('config') .. '/scripts/patch-vtsls.py'
          vim.system({ 'python3', script }, { text = true }, function(result)
            if result.code ~= 0 then
              vim.schedule(function()
                vim.notify('vtsls patch failed:\n' .. (result.stderr or ''), vim.log.levels.WARN)
              end)
            end
          end)
        end,
      })
    end,
    opts = {
      ensure_installed = {
        'vtsls',
        'angular-language-server',
        'lua-language-server',
        'eslint-lsp',
        'html-lsp',
        'emmet-language-server',
        'stylelint-language-server',
        'css-lsp',
        'some-sass-language-server',
        'graphql-language-service-cli',
        'stylua',
        'marksman',
        'cucumber-language-server',
      },
    },
  },
}
