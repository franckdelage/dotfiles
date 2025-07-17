-- LSP Plugins - Version corrigée pour projets Nx Angular
return {
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',

    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>ln', vim.lsp.buf.rename, 'Rename')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>la', vim.lsp.buf.code_action, 'Goto Code Action', { 'n', 'x' })

          -- Find references for the word under your cursor.
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

          -- 🔧 KEYMAPS SPÉCIFIQUES TYPESCRIPT IMPORTS
          -- Keymaps pour la gestion des imports TypeScript avec ts_ls
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.name == 'ts_ls' then
            -- Ajouter import manquant (code action spécifique)
            map('<leader>li', function()
              vim.lsp.buf.code_action({
                filter = function(action)
                  return action.title and (
                    action.title:match("Add import") or
                    action.title:match("Import") or
                    action.title:match("Update import")
                  )
                end,
                apply = true,
              })
            end, 'Add missing Import')

            -- Organiser les imports
            map('<leader>lo', function()
              vim.lsp.buf.code_action({
                filter = function(action)
                  return action.title and (
                    action.title:match("Organize imports") or
                    action.title:match("Sort imports")
                  )
                end,
                apply = true,
              })
            end, 'Organize imports')

            -- Supprimer les imports inutilisés
            map('<leader>lu', function()
              vim.lsp.buf.code_action({
                filter = function(action)
                  return action.title and (
                    action.title:match("Remove unused") or
                    action.title:match("Remove all unused")
                  )
                end,
                apply = true,
              })
            end, 'Remove Unused imports')

            -- Corriger tous les imports automatiquement
            map('<leader>lI', function()
              vim.lsp.buf.code_action({
                filter = function(action)
                  return action.title and (
                    action.title:match("Fix all") or
                    action.title:match("Add all missing imports")
                  )
                end,
                apply = true,
              })
            end, 'Fix all Imports')

            -- Menu interactif pour toutes les actions d'imports
            map('<leader>lm', function()
              vim.lsp.buf.code_action({
                filter = function(action)
                  return action.title and (
                    action.title:match("[Ii]mport") or
                    action.title:match("Organize") or
                    action.title:match("Remove unused")
                  )
                end,
              })
            end, 'Import Menu (interactive)')
          end

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>kh', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        float = {
          border = 'rounded',
          source = true,
        },
        underline = { severity = vim.diagnostic.severity.WARN },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = true,
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      local util = require 'lspconfig.util'
      local lspconfig = require 'lspconfig'

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        -- clangd = {},
        -- gopls = {},
        -- pyright = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`ts_ls`) will work just fine
        -- ts_ls = {},
        --
      }

      -- 🔧 CONFIGURATION CORRIGÉE POUR NX + ANGULAR

      -- 1. TypeScript Language Server - PRIORITAIRE pour les projets Nx
      lspconfig.ts_ls.setup {
        -- 🔧 CORRECTION : Utiliser nx.json et tsconfig.base.json pour les projets Nx
        root_dir = util.root_pattern('nx.json', 'angular.json', 'tsconfig.base.json', 'package.json'),
        filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
        capabilities = capabilities,
        init_options = {
          preferences = {
            -- Améliore les performances pour les gros projets Nx
            disableSuggestions = false,
            includeCompletionsForModuleExports = true,
            includeCompletionsForImportStatements = true,
            includeInlayParameterNameHints = 'all',
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = false,
          },
        },
        settings = {
          typescript = {
            preferences = {
              noSemicolons = false,
            },
            suggest = {
              includeCompletionsForModuleExports = true,
            },
            -- 🔧 AJOUT : Support des path mappings Nx
            workspaceSymbols = {
              scope = 'allOpenProjects',
            },
          },
        },
        -- 🔧 CORRECTION : Configuration spécifique pour Nx
        on_new_config = function(new_config, new_root_dir)
          -- Vérifier si c'est un projet Nx
          local nx_json = util.path.join(new_root_dir, 'nx.json')
          if util.path.exists(nx_json) then
            -- Configuration spécifique pour Nx
            new_config.settings = new_config.settings or {}
            new_config.settings.typescript = new_config.settings.typescript or {}
            new_config.settings.typescript.preferences = new_config.settings.typescript.preferences or {}
            new_config.settings.typescript.preferences.includePackageJsonAutoImports = 'on'
          end
        end,
      }

      -- 2. Angular Language Server - CORRIGÉ pour Nx
      lspconfig.angularls.setup {
        -- 🔧 CORRECTION : Détecter les projets Nx Angular
        root_dir = function(fname)
          -- Chercher nx.json avec Angular dans les dépendances
          local root = util.root_pattern 'nx.json'(fname)
          if root then
            local package_json = util.path.join(root, 'package.json')
            if util.path.exists(package_json) then
              local f = io.open(package_json, 'r')
              if f then
                local content = f:read '*all'
                f:close()
                -- Vérifier si Angular est présent dans les dépendances
                if content:match '"@angular/' then
                  return root
                end
              end
            end
          end
          -- Fallback vers angular.json
          return util.root_pattern 'angular.json'(fname)
        end,
        filetypes = { 'typescript', 'html', 'htmlangular', 'typescriptreact' },
        capabilities = capabilities,
        -- 🔧 CORRECTION : Configuration spécifique pour les projets Nx
        cmd = { 'ngserver', '--stdio', '--tsProbeLocations', '.', '--ngProbeLocations', '.' },
        on_new_config = function(new_config, new_root_dir)
          new_config.cmd = {
            'ngserver',
            '--stdio',
            '--tsProbeLocations',
            new_root_dir,
            '--ngProbeLocations',
            new_root_dir,
          }
        end,
        settings = {
          angular = {
            -- 🔧 AJOUT : Configuration pour les projets Nx
            forceStrictTemplates = false,
            includeCompletions = true,
          },
        },
      }

      -- 3. HTML Language Server - CORRIGÉ pour Nx
      lspconfig.html.setup {
        root_dir = util.root_pattern('nx.json', 'angular.json', 'package.json', '.git'),
        filetypes = { 'html', 'htmlangular' },
        capabilities = capabilities,
        settings = {
          html = {
            format = {
              enable = true,
            },
            hover = {
              documentation = true,
              references = true,
            },
            -- 🔧 AJOUT : Support des templates Angular
            customData = {
              useDefaultDataProvider = true,
            },
          },
        },
      }

      -- 4. ESLint Language Server - AMÉLIORÉ pour Nx
      lspconfig.eslint.setup {
        root_dir = util.root_pattern('nx.json', 'angular.json', '.eslintrc.js', '.eslintrc.json', 'eslint.config.js', 'package.json'),
        filetypes = { 'typescript', 'javascript', 'html', 'htmlangular', 'typescriptreact', 'javascriptreact' },
        capabilities = capabilities,
        settings = {
          probe = { 'typescript', 'javascript', 'html', 'htmlangular', 'typescriptreact', 'javascriptreact' },
          format = {
            enable = true,
          },
          experimental = {
            useFlatConfig = true,
          },
          problems = {
            shortenToSingleLine = false,
          },
          useESLintClass = true,
          -- 🔧 CORRECTION : Support des workspaces Nx
          validate = { 'typescript', 'javascript', 'html', 'htmlangular' },
          packageManager = 'yarn',
          workingDirectories = { { mode = 'auto' } },
        },
        on_attach = function(client, bufnr)
          -- Désactive le formatage ESLint pour éviter les conflits avec d'autres formatters
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
      }

      -- 5. Emmet Language Server - AMÉLIORÉ
      lspconfig.emmet_language_server.setup {
        root_dir = util.root_pattern('nx.json', 'angular.json', 'package.json', '.git'),
        filetypes = { 'html', 'htmlangular', 'css', 'scss', 'sass', 'typescript', 'typescriptreact' },
        capabilities = capabilities,
        settings = {
          emmet = {
            includeLanguages = {
              htmlangular = 'html',
              typescriptreact = 'html',
            },
          },
        },
      }

      -- 6. CSS/SCSS Language Servers
      lspconfig.cssls.setup {
        root_dir = util.root_pattern('nx.json', 'angular.json', 'package.json', '.git'),
        filetypes = { 'css', 'scss', 'sass' },
        capabilities = capabilities,
      }

      lspconfig.stylelint_lsp.setup {
        root_dir = util.root_pattern('nx.json', 'angular.json', 'package.json', '.git'),
        settings = {
          stylelintplus = {
            autoFixOnFormat = true,
          },
        },
        filetypes = { 'scss', 'sass', 'css' },
        capabilities = capabilities,
      }

      -- 7. GraphQL Language Server
      lspconfig.graphql.setup {
        cmd = { 'graphql-lsp', 'server', '-m', 'stream' },
        filetypes = { 'graphql', 'typescript' },
        root_dir = util.root_pattern('.git', '.graphqlconfig', 'nx.json', 'angular.json'),
        capabilities = capabilities,
      }

      -- 8. Lua Language Server
      lspconfig.lua_ls.setup {
        capabilities = capabilities,
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
      }

      -- Ensure the servers and tools above are installed
      --
      -- To check the current status of installed tools and/or manually install
      -- other tools, you can run
      --    :Mason
      --
      -- You can press `g?` for help in this menu.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        'typescript-language-server',
        'angular-language-server',
        'html-lsp',
        'eslint-lsp',
        'emmet-language-server',
        'css-lsp',
        'stylelint-lsp',
        'graphql-language-service-cli',
      })

      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = {
          'ts_ls',
          'angularls',
          'html',
          'eslint',
          'emmet_language_server',
          'cssls',
          'stylelint_lsp',
          'graphql',
          'lua_ls',
        },
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
