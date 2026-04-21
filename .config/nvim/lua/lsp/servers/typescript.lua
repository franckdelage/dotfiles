local M = {}

local ts_inlay_hints = {
  parameterNames = { enabled = 'all', suppressWhenArgumentMatchesName = false },
  parameterTypes = { enabled = true },
  variableTypes = { enabled = true, suppressWhenTypeMatchesName = false },
  propertyDeclarationTypes = { enabled = true },
  functionLikeReturnTypes = { enabled = true },
  enumMemberValues = { enabled = true },
}

local js_inlay_hints = {
  parameterNames = { enabled = 'all', suppressWhenArgumentMatchesName = false },
  parameterTypes = { enabled = true },
  variableTypes = { enabled = true, suppressWhenTypeMatchesName = false },
  propertyDeclarationTypes = { enabled = true },
  functionLikeReturnTypes = { enabled = true },
}

-- vtsls — VSCode's TypeScript extension exposed as an LSP server.
-- Replaces ts_ls. Supports TypeScript plugins, which allows the Angular
-- language service to hook in the same way it does inside VSCode.
M.servers = {
  typescript = {
    cmd = { 'vtsls', '--stdio' },
    filetypes = { 'typescript', 'javascript' },
    root_patterns = { 'nx.json', 'angular.json', 'package.json', 'tsconfig.json' },
    name = 'vtsls',
    init_options = {
      hostInfo = 'neovim',
    },
    -- settings is a function so root_dir is available for the Angular plugin path
    settings = function(root_dir)
      return {
        vtsls = {
          autoUseWorkspaceTsdk = true,
          tsserver = {
            globalPlugins = {
              {
                name = '@angular/language-service',
                location = root_dir .. '/node_modules/@angular/language-service',
                enableForWorkspaceTypeScriptVersions = true,
                -- 'ng' namespace is required: the Angular LS plugin reads its configuration
                -- (includeCompletionsWithSnippetText, etc.) from the 'ng' key, not 'ts'.
                -- Using 'ts' causes template-specific features (especially control flow
                -- blocks like @if/@for) to silently return empty responses.
                configNamespace = 'ng',
              },
            },
            -- Disable experimental settings that can cause issues
            experimental = {
              enableProjectDiagnostics = false,
            },
          },
        },
        typescript = {
          inlayHints = ts_inlay_hints,
          suggest = {
            completeFunctionCalls = true,
          },
          preferences = {
            importModuleSpecifierPreference = 'non-relative',
            includePackageJsonAutoImports = 'auto',
          },
        },
        javascript = {
          inlayHints = js_inlay_hints,
          suggest = {
            completeFunctionCalls = true,
          },
          preferences = {
            importModuleSpecifierPreference = 'non-relative',
            includePackageJsonAutoImports = 'auto',
          },
        },
      }
    end,
  },
}

return M
