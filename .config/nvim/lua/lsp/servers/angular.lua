local M = {}

-- Angular language server
M.servers = {
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
}

return M