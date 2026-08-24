# Personal Neovim Config

Modular Neovim setup focused on Angular/Nx, TypeScript, Flutter/Dart, Supabase, Git workflows, tests, and AI-assisted editing.

## Structure

- `init.lua`: entry point and core bootstrap order.
- `lua/options.lua`: editor defaults and filetype detection.
- `lua/keymaps.lua`: global keymaps.
- `lua/autocmds.lua`: personal autocmds and local workarounds.
- `lua/plugins/`: lazy.nvim plugin specs.
- `lua/lsp/`: native LSP setup and per-server configs.
- `lua/debug/`: DAP adapters, UI, and JS/TS launch configs.
- `scripts/`: helper scripts for tool patches and wrappers.

## Core Tools

Required for the normal editing path:

- Neovim 0.12+
- `git`, `make`, `unzip`, `curl`, `tar`, `tree-sitter`
- `rg`, `fd`
- `node`, `yarn`
- `prettierd` or `prettier`

Feature-specific tools:

- Format/lint: `jq`, `stylua`, `luacheck`, `markdownlint`, `stylelint`
- Git UI and GitHub: `gh`
- AI/session/debug helpers: `tmux`, `python3`
- Flutter/Dart: `flutter`, `dart`
- Supabase: `supabase`, `deno`, and a Docker-compatible runtime

Run `:checkhealth personal` to verify the local environment.

## Main Workflows

- Files/search: Snacks picker and explorer, Oil for filesystem edits.
- Completion: blink.cmp with LSP, snippets, path, buffer, and ripgrep sources.
- LSP: native Neovim LSP with vtsls, Angular LS, ESLint, Lua, HTML, CSS/SCSS, GraphQL, JSON, Markdown, Cucumber, Deno, and PostgreSQL; flutter-tools manages Dart LS.
- Formatting: `<leader>lf` runs ESLint fix, vtsls import additions/removals, Stylelint formatting, then Conform exactly once. It does not save.
- Diagnostics/navigation: Snacks LSP pickers, Trouble lists, Aerial outline, and Lspsaga definition peek on `gd`.
- Git: Gitsigns for hunks/blame, Neogit (`<leader>gg`) as the primary UI, CodeDiff, and Snacks Git/GitHub pickers.
- Tests: neotest with Jest/Vitest adapters tuned for Nx projects plus Dart/Flutter tests.
- Debugging: nvim-dap with JavaScript/TypeScript and Flutter/Dart launch configurations.
- AI: Copilot and Sidekick integrations.

## Flutter/Supabase Notes

- flutter-tools provides Dart LS, device/emulator selection, app launch, hot reload/restart, widget outline, and DevTools integration.
- `<leader>Fr` runs Flutter; `<leader>Fl` reloads; `<leader>FR` restarts; `<leader>Fq` quits.
- `<leader>Fd` selects a device; `<leader>Fe` selects an emulator; `<leader>Fo` toggles widget outline; `<leader>Ft` starts DevTools; `<leader>FO` opens it.
- Existing neotest mappings run Dart and Flutter tests through `neotest-dart`.
- TypeScript under `deno.json` or `deno.jsonc` uses Deno LS instead of vtsls/ESLint.
- vtsls requires a TypeScript project marker. Angular LS additionally requires an Angular/Nx marker and Angular dependency context; generic single-file servers retain cwd fallback.
- SQL buffers use postgres-language-server; Treesitter covers Dart, SQL, and Supabase TOML files.
- `supabase start` requires Rancher Desktop or another running Docker-compatible runtime.

## Angular/Nx Notes

- `*.component.html` is mapped to `htmlangular`.
- vtsls loads `@angular/language-service` as a TypeScript plugin.
- Angular LS also attaches to HTML/template buffers.
- Trouble filters some generated Angular diagnostics and `.ngtypecheck.ts` noise.
- neotest adapters detect Nx project names from nearby `project.json` files.

## Known Workarounds

- vtsls is patched after Mason updates by `scripts/patch-vtsls.py` to avoid tsserver assertion crashes killing the LSP process. Remove the patch once upstream handles `TypeScriptServerError` without terminating the server.
- `:checkhealth personal` checks whether that patch is present when Mason vtsls is installed.
- neotest-dart streaming output is normalized because the adapter can return failure text where Neotest expects an output file path.

## Useful Commands

- `:Lazy`: plugin manager UI.
- `:Mason`: external LSP/tool installer UI.
- `:checkhealth personal`: config-specific health checks.
- `<leader>lf`: run the ordered fix/format pipeline without saving.
- `<leader>Nn`: save the active AutoSession when one exists, then restart; restart directly when none exists.
