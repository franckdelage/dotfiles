local M = {}

-- Angular language server
M.servers = {
  angular = {
    cmd = function()
      local root_dir = vim.fn.getcwd()
      local local_ngserver = root_dir .. '/node_modules/@angular/language-service/bin/ngserver'
      local ngserver = vim.uv.fs_stat(local_ngserver) and local_ngserver or 'ngserver'

      return {
        ngserver,
        '--stdio',
        '--tsProbeLocations',
        root_dir .. '/node_modules/typescript/lib',
        '--ngProbeLocations',
        root_dir .. '/node_modules/@angular/language-service',
        '--includeCompletionsWithSnippetText',
        '--includeAutomaticOptionalChainCompletions',
      }
    end,
    filetypes = { 'html', 'htmlangular', 'typescript' },
    root_patterns = { 'nx.json', 'angular.json', 'project.json' },
    name = 'angularls',
    -- angularls only recognizes languageId "html" for template files;
    -- map the custom "htmlangular" filetype so the server builds proper
    -- TypeScript project context and symbol resolution works correctly.
    get_language_id = function(bufnr, filetype)
      if filetype == 'htmlangular' then return 'html' end
      return filetype
    end,
  },
}

return M
