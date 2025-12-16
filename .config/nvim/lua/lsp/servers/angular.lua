local M = {}

-- Angular language server
M.servers = {
  angular = {
    cmd = function()
      local root_dir = vim.fn.getcwd()
      local local_ngserver = root_dir .. '/node_modules/@angular/language-service/bin/ngserver'
      local ngserver = vim.loop.fs_stat(local_ngserver) and local_ngserver or 'ngserver'

      return {
        ngserver,
        '--stdio',
        '--tsProbeLocations',
        root_dir .. '/node_modules/typescript/lib',
        '--ngProbeLocations',
        root_dir .. '/node_modules/@angular/language-service',
        '--includeCompletionsWithSnippetText',
        '--includeAutomaticOptionalChainCompletions',
        '--experimental-ivy',
        '--acceptNewSyntax',
      }
    end,
    filetypes = { 'html', 'htmlangular' },
    root_patterns = { 'nx.json', 'angular.json', 'project.json' },
    name = 'angularls',
    settings = {
      angular = {
        log = 'verbose',
        forceStrictTemplates = false,  -- Match project setting to avoid conflicts
        enableBlockSyntax = true,
        experimental = {
          enableTemplateDiagnosticsInControlFlow = true,
        },
      },
    },
    init_options = {
      legacyNgLanguageService = false,
      typescript = {
        tsdk = vim.fn.getcwd() .. '/node_modules/typescript/lib',
        preferences = {
          includePackageJsonAutoImports = 'on',
          importModuleSpecifierPreference = 'non-relative',
          includeCompletionsForModuleExports = true,
          includeCompletionsWithInsertText = true,
        },
      },
    },
    on_new_config = function(config, root_dir)
      -- Update tsdk to use project-local TypeScript
      config.init_options.typescript.tsdk = root_dir .. '/node_modules/typescript/lib'

      local local_ngserver = root_dir .. '/node_modules/@angular/language-service/bin/ngserver'
      local ngserver = vim.loop.fs_stat(local_ngserver) and local_ngserver or 'ngserver'

      -- Update cmd to use project-local Angular language server
      config.cmd = {
        ngserver,
        '--stdio',
        '--tsProbeLocations',
        root_dir .. '/node_modules/typescript/lib',
        '--ngProbeLocations',
        root_dir .. '/node_modules/@angular/language-service',
        '--includeCompletionsWithSnippetText',
        '--includeAutomaticOptionalChainCompletions',
        '--experimental-ivy',
        '--acceptNewSyntax',
      }
    end,

  },
}

return M
