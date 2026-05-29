# Personal Neovim Config

Modular Neovim setup focused on Angular/Nx, TypeScript, Git workflows, tests, and AI-assisted editing.

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

- `git`, `make`, `unzip`
- `rg`, `fd`
- `node`, `yarn`
- `prettierd` or `prettier`

Feature-specific tools:

- Format/lint: `jq`, `stylua`, `luacheck`, `markdownlint`, `stylelint`
- Git UI and GitHub: `lazygit`, `gh`
- AI/session/debug helpers: `tmux`, `python3`

Run `:checkhealth personal` to verify the local environment.

## Main Workflows

- Files/search: Snacks picker and explorer, Oil for filesystem edits.
- Completion: blink.cmp with LSP, snippets, path, buffer, and ripgrep sources.
- LSP: native Neovim LSP with vtsls, Angular LS, ESLint, Lua, HTML, CSS/SCSS, GraphQL, JSON, Markdown, and Cucumber.
- Formatting: `<leader>lf` runs ESLint fix, TypeScript import cleanup, Stylelint formatting, then Conform formatting. It does not save.
- Diagnostics/navigation: Snacks LSP pickers, Trouble, and Lspsaga.
- Git: Gitsigns, Snacks git pickers, LazyGit, Neogit, Fugitive, and CodeDiff.
- Tests: neotest with Jest/Vitest adapters tuned for Nx projects.
- Debugging: nvim-dap with JavaScript/TypeScript launch configurations.
- AI: Copilot and Sidekick integrations.

## Angular/Nx Notes

- `*.component.html` is mapped to `htmlangular`.
- vtsls loads `@angular/language-service` as a TypeScript plugin.
- Angular LS also attaches to HTML/template buffers.
- Trouble filters some generated Angular diagnostics and `.ngtypecheck.ts` noise.
- neotest adapters detect Nx project names from nearby `project.json` files.

## Known Workarounds

- vtsls is patched after Mason updates by `scripts/patch-vtsls.py` to avoid tsserver assertion crashes killing the LSP process.
- `:checkhealth personal` checks whether that patch is present when Mason vtsls is installed.
- `autocmds.lua` contains a which-key trigger cache workaround plus `:WKReset` as a manual escape hatch.

## Useful Commands

- `:Lazy`: plugin manager UI.
- `:Mason`: external LSP/tool installer UI.
- `:checkhealth personal`: config-specific health checks.
- `:WKReset`: reset which-key trigger cache.
- `<leader>lf`: fix and format current buffer without saving.
