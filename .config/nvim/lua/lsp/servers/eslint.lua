local M = {}

-- ESLint language server
M.servers = {
  eslint = {
    validate = 'on',
    packageManager = 'yarn',
    cmd = function()
      local mason_path = vim.fn.stdpath 'data' .. '/mason'
      return {
        'node',
        mason_path .. '/packages/eslint-lsp/node_modules/vscode-langservers-extracted/bin/vscode-eslint-language-server',
        '--stdio',
      }
    end,
    filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'html', 'htmlangular' },
    root_patterns = {
      'nx.json',
      '.eslintrc.js',
      '.eslintrc.json',
      '.eslintrc.cjs',
      'eslint.config.js',
      'package.json',
    },
    name = 'eslint',
    condition = function(path)
      local start_path = vim.fn.isdirectory(path) == 1 and path or vim.fs.dirname(path)
      local deno_config = vim.fs.find({ 'deno.json', 'deno.jsonc' }, {
        path = start_path,
        upward = true,
      })
      return #deno_config == 0
    end,
    settings = {
      validate = 'on',
      packageManager = 'yarn',
      useESLintClass = false,
      experimental = {
        useFlatConfig = true,
      },
      codeActionOnSave = {
        enable = false,
        mode = 'all',
      },
      format = false,
      quiet = false,
      onIgnoredFiles = 'off',
      rulesCustomizations = {},
      run = 'onType',
      problems = {
        shortenToSingleLine = false,
      },
      nodePath = '',
      workingDirectory = {
        mode = 'auto',
      },
    },
    -- on_new_config = function(config, new_root_dir)
    --   config.settings.workingDirectory = {
    --     mode = 'location',
    --     location = new_root_dir
    --   }
    -- end,
  },
}

return M
