local M = {}

-- Styling LSP servers: CSS, SCSS, Sass, Stylelint, Emmet
M.servers = {
  emmet = {
    cmd = { 'emmet-language-server', '--stdio' },
    filetypes = { 'html', 'htmlangular', 'css', 'scss', 'sass' },
    root_patterns = { '.git' },
    name = 'emmet_language_server',
  },
  stylelint = {
    cmd = { 'stylelint-lsp', '--stdio' },
    filetypes = { 'scss', 'sass', 'css' },
    root_patterns = { '.stylelintrc', '.stylelintrc.json', '.stylelintrc.js', 'stylelint.config.js', 'package.json', '.git' },
    name = 'stylelint_lsp',
    settings = {
      stylelintplus = {
        autoFixOnFormat = true,
        autoFixOnSave = true,
      },
    },
  },
  css = {
    cmd = { 'vscode-css-language-server', '--stdio' },
    filetypes = { 'css', 'scss', 'sass', 'less' },
    root_patterns = { 'package.json', '.git' },
    name = 'cssls',
    settings = {
      css = {
        validate = true,
        lint = {
          unknownAtRules = 'ignore', -- For Angular/SCSS specific at-rules
        },
      },
      scss = {
        validate = true,
        lint = {
          unknownAtRules = 'ignore',
        },
      },
      less = {
        validate = true,
      },
    },
  },
  sass = {
    cmd = { 'some-sass-language-server', '--stdio' },
    filetypes = { 'scss', 'sass' },
    root_patterns = { 'package.json', '.git' },
    name = 'somesass_ls',
    settings = {
      somesass = {
        suggestAllFromOpenDocument = true,
        suggestFromUseOnly = false,
        suggestFunctionsInStringContextAfterSymbols = ' (+-*%',
      },
    },
  },
}

return M
