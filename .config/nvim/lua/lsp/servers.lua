local M = {}

-- LSP Server configurations
M.servers = {
  typescript = {
    cmd = { 'typescript-language-server', '--stdio' },
    filetypes = { 'typescript', 'javascript' },
    root_patterns = { 'angular.json', 'nx.json', 'package.json', 'tsconfig.json' },
    name = 'ts_ls',
  },
  lua = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_patterns = { '.git', 'lua/' },
    name = 'lua_ls',
    settings = {
      Lua = {
        completion = {
          callSnippet = 'Replace',
        },
        diagnostics = {
          disable = {
            'missing-fields',
          },
        },
      },
    },
  },
  eslint = {
    validate = 'on',
    packageManager = 'yarn',
    cmd = function()
      local mason_path = vim.fn.stdpath('data') .. '/mason'
      return {
        'node',
        mason_path .. '/packages/eslint-lsp/node_modules/vscode-langservers-extracted/bin/vscode-eslint-language-server',
        '--stdio'
      }
    end,
    filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'html', 'htmlangular' },
    root_patterns = { '.eslintrc.js', '.eslintrc.json', '.eslintrc.cjs', 'eslint.config.js', 'package.json' },
    name = 'eslint',
    settings = {
      validate = 'on',
      packageManager = 'npm',
      useESLintClass = false,
      experimental = {
        useFlatConfig = true,
      },
      codeActionOnSave = {
        enable = false,
        mode = 'all'
      },
      format = false,
      quiet = false,
      onIgnoredFiles = 'off',
      rulesCustomizations = {},
      run = 'onType',
      problems = {
        shortenToSingleLine = false
      },
      nodePath = '',
      workingDirectory = {
        mode = 'auto'
      }
    },
    on_new_config = function(config, new_root_dir)
      config.settings.workingDirectory = {
        mode = 'location',
        location = new_root_dir
      }
    end,
  },
  angular = {
    cmd = { 'ngserver', '--stdio', '--tsProbeLocations', 'node_modules', '--ngProbeLocations', 'node_modules' },
    filetypes = { 'typescript', 'html', 'htmlangular' },
    root_patterns = { 'angular.json', 'nx.json' },
    name = 'angularls',
    settings = {
      angular = {
        log = 'verbose'
      }
    },
    init_options = {
      legacyNgLanguageService = false
    }
  },
  html = {
    cmd = { 'vscode-html-language-server', '--stdio' },
    filetypes = { 'html' },
    root_patterns = { 'nx.json', '.git' },
    name = 'html',
    settings = {
      html = {
        format = {
          enable = true,
        },
        hover = {
          documentation = true,
          references = true,
        },
      },
    },
  },
  emmet = {
    cmd = { 'emmet-language-server', '--stdio' },
    filetypes = { 'html', 'htmlangular', 'css', 'scss', 'sass' },
    root_patterns = { '.git' },
    name = 'emmet_language_server',
  },
  stylelint = {
    cmd = { 'stylelint-lsp', '--stdio' },
    filetypes = { 'scss', 'sass', 'css' },
    root_patterns = { '.stylelintrc', 'package.json', '.git' },
    name = 'stylelint_lsp',
    settings = {
      stylelintplus = {
        autoFixOnFormat = true,
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
          unknownAtRules = 'ignore' -- For Angular/SCSS specific at-rules
        }
      },
      scss = {
        validate = true,
        lint = {
          unknownAtRules = 'ignore'
        }
      },
      less = {
        validate = true
      }
    }
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
        suggestFunctionsInStringContextAfterSymbols = ' (+-*%'
      }
    }
  },
  graphql = {
    cmd = { 'graphql-lsp', 'server', '-m', 'stream' },
    filetypes = { 'graphql', 'typescript' },
    root_patterns = { '.git', '.graphqlconfig' },
    name = 'graphql',
  },
  marksman = {
    cmd = { 'marksman', 'server' },
    filetypes = { 'markdown' },
    root_patterns = { '.git', '.marksman.toml' },
    name = 'marksman',
    settings = {
      marksman = {
        -- Enable completion for wiki-style links
        completion = {
          wiki = {
            enabled = true
          }
        }
      }
    }
  },
  cucumber = {
    cmd = { 'cucumber-language-server', '--stdio' },
    filetypes = { 'cucumber' },
    root_patterns = { '.git', 'nx.json', 'cucumber.yml', 'cucumber.json', 'package.json' },
    name = 'cucumber_language_server',
    settings = {
      cucumber = {
        features = { '**/*.feature' },
        glue = { 'src/**/*.js', 'src/**/*.ts', 'features/**/*.js', 'features/**/*.ts' }
      }
    }
  },
}

return M