---
type: source
title: "Observation: Angular Tree-sitter nested-call parser defect confirmed"
tags:
  - neovim
  - treesitter
  - angular
  - syntax-highlighting
  - parser
status: observation
created: 2026-09-16
updated: 2026-09-16
slug: obs-2026-09-16-angular-tree-sitter-nested-call-parser-defect-confirmed
relevance: high
observed_at: 2026-09-16T09:18:53.341Z
source_context: Investigating broken syntax colors in invoice-form.component.html line 48. Imported from project /Users/franckdelage/Developer/bw-blueweb; originally observed at 2026-09-16T08:46:24.104Z.
---

# ⭐ Observation: Angular Tree-sitter nested-call parser defect confirmed

`tree-sitter-angular` revision `38a8014ed5452cd6b7cf1399c00177a1f5374256` (upstream HEAD, grammar 0.9.2) cannot parse valid Angular template nested calls such as `asBooleanField(field.code)().errors()`. Minimal reproducer fails; `asBooleanField(field.code).errors()` succeeds. Grammar `call_expression` only permits `identifier(...)`, so call-on-call syntax is unsupported. Error recovery then misclassifies identifier letters as regex flags, related to open upstream issue #89: https://github.com/dlvandenberg/tree-sitter-angular/issues/89. Nvim config is not root cause. `nvim-config/lua/plugins/treesitter.lua` does not list `angular`, so future parser update/install should add it, but current installed parser already matches upstream HEAD.

*Relevance: high*
*Context: Investigating broken syntax colors in invoice-form.component.html line 48. Imported from project /Users/franckdelage/Developer/bw-blueweb; originally observed at 2026-09-16T08:46:24.104Z.*
*Tags: neovim treesitter angular syntax-highlighting parser*

---
*Observed: 2026-09-16T09:18:53.341Z*
