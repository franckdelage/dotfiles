-- Native LSP Configuration (Neovim 0.11+)
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
    -- Mason for tool installation (keeping this for convenience)
    'williamboman/mason.nvim',
    opts = {},
  },
  {
    -- Tool installer for LSP servers and formatters
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    opts = {
      ensure_installed = {
        'typescript-language-server',
        'lua-language-server',
        'eslint-lsp',
        'angular-language-server',
        'html-lsp',
        'emmet-language-server',
        'stylelint-lsp',
        'graphql-language-service-cli',
        'stylua', -- Used to format Lua code
      },
    },
  },
  {
    -- Useful status updates for LSP.
    'j-hui/fidget.nvim',
    opts = {},
  },
  {
    -- Completion plugin providing capabilities
    'saghen/blink.cmp',
  },
  {
    -- Native LSP setup plugin
    name = 'native-lsp-config',
    dir = vim.fn.stdpath('config'),
    config = function()
      -- Helper function to find root directory
      local function find_root(patterns, start_path)
        local path = start_path or vim.fn.getcwd()
        for _, pattern in ipairs(patterns) do
          local found = vim.fs.find(pattern, { path = path, upward = true })
          if #found > 0 then
            return vim.fs.dirname(found[1])
          end
        end
        return vim.fn.getcwd()
      end

      -- Get capabilities from blink.cmp
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- LSP Attach autocmd for keymaps and functionality
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Rename the variable under your cursor.
          map('<leader>ln', vim.lsp.buf.rename, 'Rename')

          -- Execute a code action
          map('<leader>la', vim.lsp.buf.code_action, 'Goto Code Action', { 'n', 'x' })

          -- Find references for the word under your cursor.
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the definition of the word under your cursor.
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- Goto Declaration
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Fuzzy find all the symbols in your current document.
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

          -- Fuzzy find all the symbols in your current workspace.
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

          -- Jump to the type of the word under your cursor.
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

          -- Show signature help
          -- map('<C-k>', vim.lsp.buf.signature_help, 'Signature Help', { 'n', 'i' })

          -- Format document or selection
          -- map('<leader>lf', function()
          --   vim.lsp.buf.format({ async = true })
          -- end, 'Format Document')
          -- map('<leader>lf', function()
          --   vim.lsp.buf.format({ async = true })
          -- end, 'Format Selection', 'v')

          -- Diagnostic navigation
          map('[d', function() vim.diagnostic.jump({ count = -1, float = true }) end, 'Go to Previous Diagnostic')
          map(']d', function() vim.diagnostic.jump({ count = 1, float = true }) end, 'Go to Next Diagnostic')

          -- Show line diagnostics in floating window
          map('<leader>le', vim.diagnostic.open_float, 'Show Line Diagnostics')

          -- Add diagnostics to location list
          map('<leader>lq', vim.diagnostic.setloclist, 'Add Diagnostics to Location List')

          -- ESLint autofix
          map('<leader>lc', function()
            local clients = vim.lsp.get_clients({ bufnr = event.buf, name = 'eslint' })
            if #clients > 0 then
              local client = clients[1]
              -- Use ESLint's executeAutofix command with the new API
              local success, result = pcall(function()
                return client:exec_cmd({
                  command = 'eslint.executeAutofix',
                  arguments = { { uri = vim.uri_from_bufnr(event.buf) } },
                }, { bufnr = event.buf })
              end)

              if success and result then
                vim.notify('ESLint autofix applied', vim.log.levels.INFO)
              else
                -- Fallback to code action approach
                vim.lsp.buf.code_action({
                  context = {
                    only = { 'source.fixAll' },
                    diagnostics = vim.diagnostic.get(event.buf),
                  },
                  apply = true,
                })
                vim.notify('ESLint fixes applied via code action', vim.log.levels.INFO)
              end
            else
              vim.notify('ESLint LSP not attached to this buffer', vim.log.levels.WARN)
            end
          end, 'ESLint Autofix')

          -- Workspace folders
          map('<leader>lwa', vim.lsp.buf.add_workspace_folder, 'Add Workspace Folder')
          map('<leader>lwr', vim.lsp.buf.remove_workspace_folder, 'Remove Workspace Folder')
          map('<leader>lwl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, 'List Workspace Folders')

          -- Helper function for checking LSP method support (0.11+ compatibility)
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- Document highlight setup
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

          -- Inlay hints toggle
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>lh', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Diagnostic Configuration
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
        virtual_text = false,
        virtual_lines = false,
      }

      -- Custom diagnostic display on cursor line
      local ns = vim.api.nvim_create_namespace("cursor_line_diagnostics")

      local function format_diagnostic(diagnostic)
        local diagnostic_message = {
          [vim.diagnostic.severity.ERROR] = diagnostic.message,
          [vim.diagnostic.severity.WARN]  = diagnostic.message,
          [vim.diagnostic.severity.INFO]  = diagnostic.message,
          [vim.diagnostic.severity.HINT]  = diagnostic.message,
        }
        return diagnostic_message[diagnostic.severity] or diagnostic.message
      end

      local function show_line_diagnostics()
        local bufnr = vim.api.nvim_get_current_buf()

        if not vim.api.nvim_buf_is_valid(bufnr)
          or not vim.api.nvim_buf_is_loaded(bufnr)
          or vim.bo[bufnr].buftype ~= "" then
          return
        end

        local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1

        vim.diagnostic.reset(ns, bufnr)

        local diags = vim.diagnostic.get(bufnr, { lnum = cursor_line })

        if #diags > 0 then
         local formatted_diags = {}
          for _, d in ipairs(diags) do
            local copy = vim.deepcopy(d)
            copy.message = format_diagnostic(copy)
            table.insert(formatted_diags, copy)
          end

          vim.diagnostic.show(ns, bufnr, formatted_diags, { virtual_lines = true })
        end
      end

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        callback = show_line_diagnostics,
      })

      -- LSP Server configurations
      local servers = {
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
        },
        html = {
          cmd = { 'vscode-html-language-server', '--stdio' },
          filetypes = { 'html', 'htmlangular' },
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
        graphql = {
          cmd = { 'graphql-lsp', 'server', '-m', 'stream' },
          filetypes = { 'graphql', 'typescript' },
          root_patterns = { '.git', '.graphqlconfig' },
          name = 'graphql',
        },
      }

      -- Function to start LSP server
      local function start_lsp_server(server_config, bufnr)
        local root_dir = find_root(server_config.root_patterns)

        -- Special handling for ESLint - only start if config files exist
        if server_config.name == 'eslint' then
          local eslint_configs = { '.eslintrc.js', '.eslintrc.json', '.eslintrc.cjs', 'eslint.config.js', 'eslint.config.mjs', '.eslintrc.yml', '.eslintrc.yaml' }
          local has_eslint_config = false
          for _, config_file in ipairs(eslint_configs) do
            local found = vim.fs.find(config_file, { path = root_dir, upward = true })
            if #found > 0 then
              has_eslint_config = true
              break
            end
          end

          -- Also check for eslint in package.json
          if not has_eslint_config then
            local package_json_path = vim.fs.find('package.json', { path = root_dir, upward = true })[1]
            if package_json_path then
              local package_json = vim.fn.readfile(package_json_path)
              local package_content = table.concat(package_json, '\n')
              if package_content:match('"eslint"') or package_content:match('"eslintConfig"') then
                has_eslint_config = true
              end
            end
          end

          if not has_eslint_config then
            return -- Don't start ESLint if no config found
          end
        end

        local cmd = server_config.cmd
        if type(cmd) == 'function' then
          cmd = cmd()
        end

        local config = {
          name = server_config.name,
          cmd = cmd,
          root_dir = root_dir,
          capabilities = capabilities,
          settings = server_config.settings,
          init_options = server_config.init_options,
        }

        vim.lsp.start(config, { bufnr = bufnr })
      end

      -- Create autocmds for each server based on filetype
      for _, server_config in pairs(servers) do
        vim.api.nvim_create_autocmd('FileType', {
          pattern = server_config.filetypes,
          callback = function(event)
            -- Check if this server is already running for this buffer
            local clients = vim.lsp.get_clients({ bufnr = event.buf, name = server_config.name })
            if #clients == 0 then
              start_lsp_server(server_config, event.buf)
            end
          end,
        })
      end

      -- Special handling for eslint - enable it explicitly
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
        pattern = { '*.ts', '*.js', '*.tsx', '*.jsx', '*.html' },
        callback = function(event)
          local clients = vim.lsp.get_clients({ bufnr = event.buf, name = 'eslint' })
          if #clients == 0 then
            start_lsp_server(servers.eslint, event.buf)
          end
        end,
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et

