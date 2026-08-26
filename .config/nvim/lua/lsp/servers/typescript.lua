local M = {}

local ts_inlay_hints = {
  parameterNames = { enabled = "all", suppressWhenArgumentMatchesName = false },
  parameterTypes = { enabled = true },
  variableTypes = { enabled = true, suppressWhenTypeMatchesName = false },
  propertyDeclarationTypes = { enabled = true },
  functionLikeReturnTypes = { enabled = true },
  enumMemberValues = { enabled = true },
}

local js_inlay_hints = {
  parameterNames = { enabled = "all", suppressWhenArgumentMatchesName = false },
  parameterTypes = { enabled = true },
  variableTypes = { enabled = true, suppressWhenTypeMatchesName = false },
  propertyDeclarationTypes = { enabled = true },
  functionLikeReturnTypes = { enabled = true },
}

-- vtsls — VSCode's TypeScript extension exposed as an LSP server.
-- Angular-aware features are owned by angularls; keeping vtsls plugin-free
-- preserves native TypeScript rename behavior for Angular-decorated classes.
M.servers = {
  typescript = {
    cmd = { "vtsls", "--stdio" },
    filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
    root_patterns = { "nx.json", "angular.json", "package.json", "tsconfig.json" },
    workspace_required = true,
    name = "vtsls",
    condition = function(path)
      local start_path = vim.fn.isdirectory(path) == 1 and path or vim.fs.dirname(path)
      local deno_config = vim.fs.find({ "deno.json", "deno.jsonc" }, {
        path = start_path,
        upward = true,
      })
      return #deno_config == 0
    end,
    init_options = {
      hostInfo = "neovim",
    },
    settings = {
      vtsls = {
        autoUseWorkspaceTsdk = true,
        tsserver = {
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
          importModuleSpecifierPreference = "project-relative",
          includePackageJsonAutoImports = "auto",
          quoteStyle = "single",
          preferTypeOnlyAutoImports = true,
        },
        preferGoToSourceDefinition = true,
      },
      javascript = {
        inlayHints = js_inlay_hints,
        suggest = {
          completeFunctionCalls = true,
        },
        preferences = {
          importModuleSpecifierPreference = "non-relative",
          includePackageJsonAutoImports = "auto",
        },
      },
    },
  },
}

return M
