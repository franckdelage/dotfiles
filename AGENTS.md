# Agent Notes: DAP configuration for Angular (Nx) and GraphQL backend

This document summarizes recommended nvim-dap settings and practices tailored for:
- Angular frontends within Nx monorepos
- A large TypeScript Node/GraphQL backend (e.g., NestJS/Apollo/Express)

These notes assume you are using:
- nvim-dap + nvim-dap-ui
- mason.nvim + mason-nvim-dap
- js-debug (vscode-js-debug) for Node/Chrome debugging


## 1) Choose a single source for js-debug
Pick one source of truth for the adapter to avoid drift.

Recommended: Mason-managed js-debug
- Ensure it’s installed via mason-nvim-dap:
  ```lua
  require('mason-nvim-dap').setup({
    automatic_installation = true,
    ensure_installed = { 'js-debug-adapter' },
  })
  ```
- Point the adapter to Mason’s path, typically:
  ```lua
  vim.fn.expand('$MASON/packages/js-debug-adapter/js-debug/src/dapDebugServer.js')
  ```

Alternative: Use the microsoft/vscode-js-debug plugin build and point the adapter to the plugin’s output. If you do this, remove Mason’s js-debug-adapter to keep things consistent.


## 2) Load workspace .vscode/launch.json
Nx monorepos often carry working VS Code launch configs. Load them so you don’t duplicate per-app logic in Lua.

```lua
require('dap.ext.vscode').load_launchjs(nil, {
  ['pwa-node'] = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
  ['pwa-chrome'] = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
})
```

This enables existing Nx/Angular/Node launch entries to “just work” in Neovim.


## 3) Angular app debugging (Chrome)
Use Chrome (pwa-chrome) to debug Angular in the browser.

Baseline launcher (default Angular dev server):
```lua
{
  type = 'pwa-chrome',
  request = 'launch',
  name = 'Angular: Launch Chrome',
  url = 'http://localhost:4200',
  webRoot = '${workspaceFolder}',
  protocol = 'inspector',
  sourceMaps = true,
  userDataDir = false,
  sourceMapPathOverrides = {
    ['webpack:///./*'] = '${webRoot}/*',
    ['webpack:///*'] = '${webRoot}/*',
    ['webpack:///src/*'] = '${webRoot}/src/*',
    ['file:///*'] = '*',
  },
}
```

Per-app launchers in Nx: create one for each app/port (e.g., localhost:4300, 4400, …). If helpful, set webRoot to the app root (e.g., `${workspaceFolder}/apps/<app>`), though `${workspaceFolder}` typically works fine with proper sourceMapPathOverrides.


## 4) Node/GraphQL backend debugging (TypeScript)
Two reliable flows:

a) Attach to a running backend (recommended for Nx):
```lua
{
  type = 'pwa-node',
  request = 'attach',
  name = 'API: Attach (9229)',
  address = 'localhost',
  port = 9229,
  cwd = '${workspaceFolder}',
  sourceMaps = true,
  resolveSourceMapLocations = {
    '${workspaceFolder}/**',
    '!**/node_modules/**',
  },
  skipFiles = { '<node_internals>/**', '${workspaceFolder}/node_modules/**' },
  autoAttachChildProcesses = true,
}
```
Start your server with an inspector: `nx serve api --inspect=9229` (or the equivalent for your backend).

b) Launch via Nx from DAP:
```lua
{
  type = 'pwa-node',
  request = 'launch',
  name = 'API: Launch via Nx',
  program = '${workspaceFolder}/node_modules/nx/bin/nx.js',
  args = { 'serve', 'api', '--inspect-brk' },
  cwd = '${workspaceFolder}',
  console = 'integratedTerminal',
  sourceMaps = true,
  skipFiles = { '<node_internals>/**', '${workspaceFolder}/node_modules/**' },
  autoAttachChildProcesses = true,
}
```

If you use ts-node and path aliases:
```lua
runtimeArgs = { '-r', 'ts-node/register', '-r', 'tsconfig-paths/register' },
-- optional env override if needed
env = { TS_NODE_PROJECT = 'apps/api/tsconfig.app.json' },
```

If you debug the built app:
```lua
{
  type = 'pwa-node',
  request = 'launch',
  name = 'API: Launch built dist',
  program = '${workspaceFolder}/dist/apps/api/main.js',
  cwd = '${workspaceFolder}',
  outFiles = { '${workspaceFolder}/dist/apps/api/**/*.js' },
  sourceMaps = true,
  skipFiles = { '<node_internals>/**', '${workspaceFolder}/node_modules/**' },
}
```


## 5) Tests in Nx (Jest/Vitest)
Jest (common in Nx Angular):
- Attach style: run `nx test <project> --runInBand --inspect-brk` and use the attach config above (port 9229).
- Launch via Nx:
  ```lua
  {
    type = 'pwa-node',
    request = 'launch',
    name = 'Jest: Current File via Nx',
    program = '${workspaceFolder}/node_modules/nx/bin/nx.js',
    args = { 'test', '<project>', '--runTestsByPath', '${file}' },
    cwd = '${workspaceFolder}',
    console = 'integratedTerminal',
    sourceMaps = true,
  }
  ```

Vitest (in newer Nx setups):
```lua
{
  type = 'pwa-node',
  request = 'launch',
  name = 'Vitest: Current File',
  runtimeExecutable = 'node',
  runtimeArgs = { '${workspaceFolder}/node_modules/vitest/vitest.mjs', 'run', '${file}' },
  cwd = '${workspaceFolder}',
  console = 'integratedTerminal',
  sourceMaps = true,
}
```


## 6) Quality-of-life settings
- Always set `skipFiles = { '<node_internals>/**', '${workspaceFolder}/node_modules/**' }` to reduce noise.
- `autoAttachChildProcesses = true` helps when the backend spawns workers.
- Add a keymap for last run to iterate quickly: `vim.keymap.set('n', '<leader>dl', function() require('dap').run_last() end)`.
- In Nx monorepos, keeping `cwd = '${workspaceFolder}'` often works best.


## 7) DAP UI
Your layout and open/close listeners are good defaults. For very short-lived processes (e.g., single-file tests), consider toggling UI manually or only opening on first breakpoint to prevent flicker.


## 8) Nx monorepo reliability notes
- With extensive tsconfig base paths and libs, `tsconfig-paths/register` greatly improves source resolution when using ts-node.
- When Angular breakpoints don’t bind in Chrome, correct `webRoot` and `sourceMapPathOverrides` usually resolve it.
- If using pnpm, favor Mason’s js-debug-adapter to avoid installing dependencies in the plugin tree; Mason keeps isolation cleaner.


## Summary
- Keep your current structure, but:
  1) Standardize on Mason or plugin for js-debug and stick with it.
  2) Load VS Code `launch.json`.
  3) Add focused Angular Chrome configs and Nx-friendly backend/test configs.
  4) Set `skipFiles`, `autoAttachChildProcesses`, and source map overrides for smoother stepping.

With these adjustments, debugging Angular apps in Nx and a large TypeScript GraphQL backend in Neovim becomes reliable and ergonomic.


## Native LSP Configuration (Neovim 0.11+)

In addition to DAP configuration, this setup now uses native Neovim 0.11+ LSP functionality instead of the nvim-lspconfig plugin.

### Migration Benefits
- Direct use of `vim.lsp.start()` for better control over server lifecycle
- Reduced plugin dependencies while maintaining full functionality
- Custom root directory detection using `vim.fs.find()`
- FileType autocmds to automatically start appropriate LSP servers
- Preserved all existing capabilities: completion, diagnostics, keymaps, etc.

### Key Implementation Details

**Root Directory Detection:**
```lua
local function find_root(patterns, start_path)
  local path = start_path or vim.fn.getcwd()
  for _, pattern in ipairs(patterns) do
    local found = vim.fs.find(pattern, { path = path, upward = true })
    if #found > 0 then
      return vim.fs.dirname(found[1])
    end
  end
  return vim.fn.getcwd()
end
```

**Server Configuration:**
Each LSP server is defined with:
- `cmd`: Command array to start the server
- `filetypes`: File types that trigger the server
- `root_patterns`: Files/directories used for root detection
- `name`: Unique server identifier
- `settings`: Server-specific configuration

**Automatic Server Startup:**
FileType autocmds detect when to start each server:
```lua
vim.api.nvim_create_autocmd('FileType', {
  pattern = server_config.filetypes,
  callback = function(event)
    local clients = vim.lsp.get_clients({ bufnr = event.buf, name = server_config.name })
    if #clients == 0 then
      start_lsp_server(server_config, event.buf)
    end
  end,
})
```

**Maintained Functionality:**
- All LSP keymaps preserved (grr, gri, grd, etc.)
- Document highlighting and inlay hints
- Custom diagnostic display on cursor line
- Integration with blink.cmp for completion
- Mason integration for tool installation

### Configured Servers
- **TypeScript/JavaScript**: typescript-language-server with Nx/Angular root detection
- **Lua**: lua-language-server with Neovim config optimization
- **ESLint**: vscode-eslint-language-server for linting
- **Angular**: @angular/language-service for Angular templates
- **HTML**: vscode-html-language-server with Angular template support
- **CSS/SCSS**: stylelint-lsp and emmet-language-server
- **GraphQL**: graphql-lsp for schema and query support

## Update log

- 2025-08-13
  - Standardized on Mason-managed js-debug-adapter and ensured installation via mason-nvim-dap (ensure_installed includes 'js-debug-adapter').
  - Loaded workspace .vscode/launch.json so Nx/Angular/Node configs are automatically available in Neovim.
  - Updated Angular Chrome launcher to default to http://localhost:4200 with sourceMapPathOverrides for reliable breakpoint binding.
  - Added skipFiles and autoAttachChildProcesses to Node configurations for cleaner stepping and child process handling.
  - Verified adapters point to Mason path: $MASON/packages/js-debug-adapter/js-debug/src/dapDebugServer.js.

- 2025-08-14
  - Neotest Jest configuration updated: removed use of --testPathPattern and per-file path injection that caused intermittent "No tests found" in Nx monorepo when absolute paths failed Jest's pattern resolution.
  - New strategy: For Nx projects run full `yarn nx test <project>` letting neotest filter positions internally; for non-Nx fallback, invoke `yarn jest --runTestsByPath <file>` to ensure Jest directly loads the target file without relying on pattern matching.
  - Added notification via noice to surface which Nx project is targeted during test runs.
  - Rationale documented: mismatched path normalization between neotest supplied absolute paths and Jest's pattern engine in Nx root led to empty matches.

- 2025-08-18
  - **Native LSP Migration**: Completely migrated from nvim-lspconfig plugin to native Neovim 0.11+ LSP functionality.
  - Implemented custom root directory detection using `vim.fs.find()` with patterns for Nx/Angular projects.
  - Created FileType autocmds for automatic server startup with duplicate prevention logic.
  - Maintained all existing LSP functionality: keymaps, diagnostics, completion integration, document highlighting.
  - Preserved Mason integration for tool installation while removing lspconfig dependency.
  - Configured 8 LSP servers: TypeScript, Lua, ESLint, Angular, HTML, Emmet, Stylelint, and GraphQL.
  

