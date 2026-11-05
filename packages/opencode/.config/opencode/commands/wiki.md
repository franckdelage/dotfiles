---
description: Load bw-wiki context — index + recent log — for bw-blueweb session orientation
---
Read the following files and print a brief orientation summary:

1. Read `~/Work/bw-wiki/wiki/index.md` — full file
2. Run: `grep "^## \[" ~/Work/bw-wiki/wiki/log.md | tail -15` to get last 15 log entries

Then print:
- How many pages exist per category (architecture, patterns, decisions, mistakes, domains)
- Last 5 log entries (type + title only, one line each)
- Any pages with `status: stale` worth revisiting
- One-line reminder of what we last worked on (from log)

Keep summary under 20 lines. This is orientation, not a full report.
