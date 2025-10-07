local M = {}

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
        inlayHints = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayVariableTypeHintsWhenTypeMatchesName = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
        suggest = {
          completeFunctionCalls = true,
        },
        preferences = {
          importModuleSpecifierPreference = 'non-relative',
          includePackageJsonAutoImports = 'auto',
        },
      },
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayVariableTypeHintsWhenTypeMatchesName = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
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
