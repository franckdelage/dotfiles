---
type: source
title: "Observation: Local Angular Tree-sitter nested-call patch installed"
tags:
  - neovim
  - treesitter
  - angular
  - local-patch
  - macos
status: observation
created: 2026-09-16
updated: 2026-09-16
slug: obs-2026-09-16-local-angular-tree-sitter-nested-call-patch-installed
relevance: high
observed_at: 2026-09-16T09:21:04.708Z
source_context: Implementing reversible local Tree-sitter parser patch. Imported from project /Users/franckdelage/Developer/bw-blueweb; originally observed at 2026-09-16T09:05:44.509Z.
---

# ⭐ Observation: Local Angular Tree-sitter nested-call patch installed

Patched `tree-sitter-angular` call grammar from one argument-list to `repeat1` argument-lists, allowing valid expressions such as `foo()()` and `foo()().errors()`. Upstream 146 parser tests pass; minimal nested-call regression parses without errors. Built directly to `/Users/franckdelage/.local/share/nvim/site/parser/angular.so` using tree-sitter CLI 0.26.5. Direct final-path build is required on macOS because copying a dylib built under `/tmp` retained its `/tmp` LC_ID_DYLIB and Neovim was killed with signal 9. Original saved at `/Users/franckdelage/.local/share/nvim/site/parser/angular.so.upstream-38a8014.bak`. Invoice line 48 now parses without error.

*Relevance: high*
*Context: Implementing reversible local Tree-sitter parser patch. Imported from project /Users/franckdelage/Developer/bw-blueweb; originally observed at 2026-09-16T09:05:44.509Z.*
*Tags: neovim treesitter angular local-patch macos*

---
*Observed: 2026-09-16T09:21:04.708Z*
