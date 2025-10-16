local M = {}

-- Angular language server
M.servers = {
  angular = {
    cmd = {
      'ngserver',
      '--stdio',
      '--tsProbeLocations',
      '/Users/franckdelage/.nvm/current/lib/node_modules/typescript/lib',
      '--ngProbeLocations',
      '/Users/franckdelage/.nvm/current/lib/node_modules/@angular/language-server/bin',
    },
    filetypes = { 'html', 'htmlangular' },
    root_patterns = { 'angular.json', 'nx.json' },
    name = 'angularls',
    settings = {
      angular = {
        log = 'verbose',
        forceStrictTemplates = true,
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
        },
      },
    },
    on_new_config = function(config, root_dir)
      config.init_options.typescript.tsdk = root_dir .. '/node_modules/typescript/lib'
    end,
  },
}

return M
