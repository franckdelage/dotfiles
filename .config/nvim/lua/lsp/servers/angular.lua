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
    filetypes = { 'typescript', 'html', 'htmlangular' },
    root_patterns = { 'angular.json', 'nx.json' },
    name = 'angularls',
    settings = {
      angular = {
        log = 'verbose',
        forceStrictTemplates = true,
      }
    },
    init_options = {
      legacyNgLanguageService = false,
      typescript = {
        tsdk = vim.fn.getcwd() .. '/node_modules/typescript/lib',
      },
    },
    on_new_config = function(config, root_dir)
      config.init_options.typescript.tsdk = root_dir .. '/node_modules/typescript/lib'
    end,
  },
}

return M
