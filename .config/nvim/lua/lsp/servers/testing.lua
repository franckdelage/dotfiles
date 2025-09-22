local M = {}

-- Testing framework language servers
M.servers = {
  cucumber = {
    cmd = { 'cucumber-language-server', '--stdio' },
    filetypes = { 'cucumber' },
    root_patterns = { '.git', 'nx.json', 'cucumber.yml', 'cucumber.json', 'package.json' },
    name = 'cucumber_language_server',
    settings = {
      cucumber = {
        features = { '**/*.feature' },
        glue = { 'src/**/*.js', 'src/**/*.ts', 'features/**/*.js', 'features/**/*.ts' }
      }
    }
  },
}

return M