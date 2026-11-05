#!/usr/bin/env python3
"""
Patch vtsls after Mason install to prevent TypeScriptServerError from killing
the process on tsserver debug assertion failures (e.g. TS 5.8+/5.9 bug with
"position cannot precede the beginning of the file" on large monorepo tsconfigs).

VSCode handles this gracefully by logging and continuing; vtsls re-throws,
causing an unhandledRejection that exits Node.js with code 1.

Neovim invokes this after Mason updates and passes the exact installed target path.
The patch can be removed once upstream vtsls handles TypeScriptServerError without
terminating the language server.
"""

import os
import shutil
import sys

OLD = """.catch((err) => {
            if (err instanceof TypeScriptServerError) {
              if (!executeInfo.token?.isCancellationRequested) {
                this._telemetryReporter.logTelemetry("languageServiceErrorResponse", err.telemetry);
              }
            }
            throw err;
          });"""

NEW = """.catch((err) => {
            if (err instanceof TypeScriptServerError) {
              if (!executeInfo.token?.isCancellationRequested) {
                this._telemetryReporter.logTelemetry("languageServiceErrorResponse", err.telemetry);
              }
              // Do not re-throw TypeScriptServerError: tsserver debug assertion failures
              // (e.g. "position cannot precede the beginning of the file" in TS 5.8+/5.9
              // on large monorepo tsconfigs) must not kill the vtsls process.
              // VSCode's equivalent code path logs and continues rather than throwing.
              return;
            }
            throw err;
          });"""


def main():
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} /path/to/vtsls/language-service/dist/index.js", file=sys.stderr)
        sys.exit(2)

    index_path = os.path.abspath(sys.argv[1])
    if not os.path.exists(index_path):
        print(f"ERROR: vtsls not found at expected path:\n  {index_path}", file=sys.stderr)
        sys.exit(1)

    with open(index_path, "r") as f:
        content = f.read()

    if NEW in content:
        print("Already patched, nothing to do.")
        return

    count = content.count(OLD)
    if count == 0:
        print(
            "WARNING: patch target not found — vtsls may have been updated and the patch\n"
            "needs to be reviewed. Check the dispatchResponse error handling in:\n"
            f"  {index_path}",
            file=sys.stderr,
        )
        sys.exit(1)
    if count > 1:
        print("ERROR: multiple matches found, cannot patch safely.", file=sys.stderr)
        sys.exit(1)

    # Backup
    backup = index_path + ".bak"
    shutil.copy2(index_path, backup)
    print(f"Backup: {backup}")

    patched = content.replace(OLD, NEW)
    with open(index_path, "w") as f:
        f.write(patched)

    print("vtsls patched successfully.")


if __name__ == "__main__":
    main()
