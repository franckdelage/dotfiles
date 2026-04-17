local M = {}

local ts_inlay_hints = {
  includeInlayParameterNameHints = 'all',
  includeInlayParameterNameHintsWhenArgumentMatchesName = true,
  includeInlayFunctionParameterTypeHints = true,
  includeInlayVariableTypeHints = true,
  includeInlayVariableTypeHintsWhenTypeMatchesName = true,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayEnumMemberValueHints = true,
}

-- TypeScript language server
M.servers = {
  typescript = {
    cmd = { 'typescript-language-server', '--stdio' },
    filetypes = { 'typescript', 'javascript' },
    root_patterns = { 'nx.json', 'angular.json', 'package.json', 'tsconfig.json' },
    name = 'ts_ls',
    init_options = {
      preferences = {
        importModuleSpecifierPreference = 'non-relative',
        includePackageJsonAutoImports = 'auto',
      },
    },
    settings = {
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
        inlayHints = ts_inlay_hints,
        suggest = {
          completeFunctionCalls = true,
        },
        preferences = {
          importModuleSpecifierPreference = 'non-relative',
          includePackageJsonAutoImports = 'auto',
        },
      },
    },
  },
}

return M
