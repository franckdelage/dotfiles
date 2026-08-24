# Neovim Config Reliability + Cleanup Plan

## Summary

Config is feature-rich and well modularized, but several custom paths create correctness risk. Highest-value fixes:

1. Fix restart hook bypass and sessionless restart failure.
2. Make LSP startup workspace-aware; prevent Angular LS from starting in every TypeScript project.
3. Rewrite unified fix/format pipeline to target one client per action and run each stage exactly once.
4. Fix duplicated/brittle LSP autocmd lifecycle.
5. Reduce startup work and moderate plugin overlap while preserving chosen workflows.
6. Remove dead settings and stale docs.

No external public API. User-visible changes: narrower plugin/keymap set, more predictable LSP attachment, reliable `<leader>lf`, reliable restart.

## 1. Correctness fixes

### Restart/session flow

- Change `<leader>Nn` to call custom `:Restart`, not built-in `:restart`, so `BeforeRestart` hooks execute.
- Before saving, check whether AutoSession has a current session. Skip save cleanly when none exists; notify only on real failure.
- Keep current explicit session model (`auto_create = false`, `auto_restore = false`).

### LSP startup and lifecycle

- Change root discovery to distinguish “marker found” from fallback cwd.
- Add workspace-required behavior per project-specific server:
  - Angular LS starts only under Angular/Nx markers and when Angular language-service context exists.
  - vtsls/ESLint remain excluded under Deno roots.
  - Deno LS starts only under Deno markers.
  - Generic HTML/CSS/Lua/etc. may retain single-file fallback where useful.
- Remove duplicate ESLint `BufEnter`/`BufWinEnter` startup path; use one FileType-driven path.
- Check server executable before start and emit one actionable warning instead of repeated failed starts.
- Guard Oil rename event data and process every move action, not only `actions[1]`.
- Create document-highlight autocmds once per buffer, not once per attached client. Use buffer-scoped cleanup after final supporting client detaches.
- Replace custom cursor-move diagnostic namespace/autocmd with Neovim 0.12 native current-line diagnostic display where behavior matches; retain rounded float, severity sorting, and Angular diagnostic filtering.
- Put all remaining diagnostic autocmds in named, clearable augroups.

### Unified fix/format command

Refactor `<leader>lf` into deterministic stages:

1. ESLint fix through ESLint client only.
2. vtsls add-missing-imports then remove-unused-imports through vtsls only.
3. Stylelint formatting through Stylelint client only for CSS/SCSS/Sass.
4. Conform formatting once.

Implementation rules:

- Use client-specific requests instead of `vim.lsp.buf_request`, whose callback runs once per attached client.
- Use each client’s negotiated `offset_encoding`, not hardcoded `utf-8`.
- Ensure every async stage invokes continuation exactly once on success, no action, timeout, or error.
- Match code-action kinds exactly or by valid hierarchical prefix; avoid Lua pattern matching.
- Report stage failures with concise context while allowing safe later stages to continue.
- Preserve current behavior: manual invocation, no implicit save, no format-on-save.

### vtsls patch consistency

- Pass Mason’s exact vtsls file path from Lua into `scripts/patch-vtsls.py`; remove hardcoded `~/.local/share/nvim` dependency.
- Keep exact-match and multiple-match safety checks.
- Make health check and patch callback use same path builder.
- Keep patch until installed vtsls version proves upstream issue fixed; document removal criterion.

## 2. Moderate plugin consolidation

### Git stack

Keep:

- Gitsigns for hunks/blame.
- Neogit as primary full Git frontend.
- CodeDiff for diff/history UI.
- Snacks Git/GitHub pickers and browser links.

Remove:

- Fugitive spec and commands.
- Snacks LazyGit integration and LazyGit-only mappings (`<leader>glo`, `<leader>glO`, `<leader>gn`).
- LazyGit health requirement.

Preserve remaining Git keymaps and update which-key/docs accordingly.

### LSP/navigation stack

- Keep Lspsaga only for definition peek (`gd`).
- Remove duplicated Lspsaga goto/diagnostic mappings already covered by Snacks, Trouble, or native diagnostics.
- Keep Snacks for search/navigation pickers.
- Keep Trouble for persistent diagnostics/reference lists.
- Keep Aerial for persistent outline/navigation.

### Dead config

- Remove `vim-test`/Floaterm globals from `options.lua`; neither plugin exists.
- Remove empty `nvim-tree.lua` tombstone after confirming no imports reference it.
- Remove stale comments and generated-template boilerplate that no longer explains current behavior.

## 3. Startup and runtime performance

- Capture baseline with Lazy profile/startup timing before changing load behavior.
- Convert safe eager plugins to command/key/filetype loading:
  - Flutter tools → Dart filetype plus Flutter commands/keymaps.
  - Octo → Octo commands/keymaps.
  - Refactoring → refactoring keymaps.
  - Harpoon → Harpoon keymaps; load before session sync only when required.
  - Aerial → Aerial commands/keymaps.
  - Bufferline → UI/startup event after core initialization.
- Keep eager only where startup semantics require it: colorscheme, Snacks core, Treesitter startup integration, Oil as default explorer, AutoSession, and Sidekick if NES initialization requires early load.
- Avoid running external linters on every `InsertLeave`. Lint on `BufWritePost` plus explicit/manual invocation; optionally retain `BufEnter` once for existing files.
- Keep parser installation declarative, but ensure startup does not repeatedly trigger network/update work.
- Compare startup timings after each group; revert lazy-loading that breaks first-use behavior or yields no meaningful gain.

## 4. Maintainability and documentation

- Extract repeated TS/JS filetype checks and LSP request helpers into focused local helpers.
- Standardize augroup names under one personal prefix.
- Add descriptions to user commands/autocmds where missing.
- Align lint/format policy with repository guidance: target ≤100 columns where practical, without mass-formatting untouched files. Lower current 200-column checks for future edits.
- Update README:
  - Remove nonexistent `:WKReset` and which-key cache workaround.
  - Document Neogit as primary Git UI and removed mappings.
  - Document actual restart/session behavior.
  - Document LSP workspace conditions and manual fix pipeline.
  - Keep vtsls and neotest workaround notes, including removal criteria.

## Key behavior and mapping changes

- `<leader>Nn` reliably saves active session via hook, then restarts; no-session restart still works.
- `<leader>lf` remains manual and unsaved, but executes each applicable stage once.
- `gd` remains Lspsaga peek definition.
- Removed Lspsaga duplicates: `gD`, `gy`, `gl`, `gL`, `gb`, `gh`; existing Snacks/Trouble mappings remain canonical.
- `<leader>gg` remains Neogit.
- LazyGit mappings `<leader>glo`, `<leader>glO`, `<leader>gn` removed.
- Fugitive commands no longer supplied by this config.

## Verification

### Static/load checks

- `stylua --check .config/nvim`
- `cd .config/nvim && luacheck .`
- Headless Neovim startup exits without errors.
- `:checkhealth personal` reports correct Neovim/tool/patch state.
- Lazy reports no invalid specs, missing dependencies, or duplicate key definitions.

### LSP scenarios

- Plain TypeScript project: vtsls attaches; Angular LS and Deno LS do not.
- Angular/Nx project: vtsls, Angular LS, and ESLint attach once where applicable.
- Deno project: Deno LS attaches; vtsls and ESLint do not.
- HTML/CSS/single-file buffers retain intended generic language support.
- Opening quickfix/CodeDiff buffers does not attach or crash LSP clients.
- Multiple clients attaching/detaching do not duplicate highlight callbacks or remove highlighting prematurely.

### Fix/format scenarios

- TS buffer with vtsls + ESLint: each requested action runs once, then formatter runs once.
- TS buffer without ESLint: TS actions and formatter still run.
- CSS/SCSS with Stylelint: Stylelint stage runs once, then Conform once.
- Missing action, client error, or timeout cannot hang pipeline or trigger duplicate formatting.
- UTF-16 client edits apply at correct positions, including non-ASCII text.

### Workflow scenarios

- Restart with active session saves then restarts.
- Restart without active session restarts without concatenation/error.
- Oil multi-file rename informs Snacks for every moved file.
- Neogit, CodeDiff, Gitsigns, Snacks Git pickers, Lspsaga peek, Trouble, and Aerial all lazy-load on first use.
- Compare startup profile against baseline; require no regression and record meaningful wins.

## Assumptions

- Target remains Neovim 0.12+.
- Angular/Nx, TypeScript, Flutter/Dart, Supabase, Neotest, Copilot, and Sidekick workflows remain in scope.
- Manual formatting is intentional; format-on-save remains disabled.
- Plugin pruning is moderate: preserve distinct workflows, remove clear overlap.
- Neogit is chosen primary Git frontend; Lspsaga definition peek is retained.
- No new plugin or test framework is introduced.
