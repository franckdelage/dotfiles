local M = {}

-- Angular language server — runs alongside vtsls.
-- vtsls handles TypeScript files and loads @angular/language-service as a TS plugin
-- for template type-checking and completions. angularls handles HTML-specific
-- language features in templates (highlights, hover, etc.).
M.servers = {
  angular = {
    cmd = function(root_dir)
      local mason_angularls = vim.fn.stdpath "data" .. "/mason/packages/angular-language-server"
      local local_ngserver = mason_angularls
        .. "/node_modules/@angular/language-server/bin/ngserver"
      local ngserver = vim.uv.fs_stat(local_ngserver) and local_ngserver or "ngserver"

      -- tsProbeLocations expects parent dirs that contain a node_modules/typescript folder.
      local ts_probe = mason_angularls

      -- Pass both Mason's bundled node_modules AND the workspace root as probe locations,
      -- mirroring how the VSCode extension passes extensionPath + workspaceFolders.
      -- ngserver searches each location for @angular/language-service.
      local mason_ng_probe = mason_angularls
        .. "/node_modules/@angular/language-server/node_modules"
      local ng_probe = mason_ng_probe .. "," .. root_dir .. "/node_modules"

      return {
        ngserver,
        "--stdio",
        "--tsProbeLocations",
        ts_probe,
        "--ngProbeLocations",
        ng_probe,
        "--includeCompletionsWithSnippetText",
        "--includeAutomaticOptionalChainCompletions",
        "--useClientSideFileWatcher",
        "--forceStrictTemplates",
      }
    end,
    filetypes = { "html", "htmlangular", "typescript" },
    root_patterns = { "angular.json", "nx.json", "project.json" },
    workspace_required = true,
    name = "angularls",
    condition = function(_, root_dir)
      if vim.uv.fs_stat(root_dir .. "/node_modules/@angular/language-service") then return true end

      local package_path = root_dir .. "/package.json"
      local ok, lines = pcall(vim.fn.readfile, package_path)
      if not ok then return false end
      return table.concat(lines, "\n"):match '"@angular/core"' ~= nil
    end,
    -- angularls only recognizes languageId "html" for template files;
    -- map the custom "htmlangular" filetype so the server builds proper
    -- TypeScript project context and symbol resolution works correctly.
    get_language_id = function(bufnr, filetype)
      if filetype == "htmlangular" then return "html" end
      return filetype
    end,
  },
}

return M
