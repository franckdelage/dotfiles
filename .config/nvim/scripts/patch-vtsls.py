#!/usr/bin/env python3
"""
Patch vtsls after Mason install to prevent TypeScriptServerError from killing
the process on tsserver debug assertion failures (e.g. TS 5.8+/5.9 bug with
"position cannot precede the beginning of the file" on large monorepo tsconfigs).

VSCode handles this gracefully by logging and continuing; vtsls re-throws,
causing an unhandledRejection that exits Node.js with code 1.

Run this after:  :MasonInstall vtsls  or  :MasonUpdate vtsls
"""

import os
import sys
import shutil

MASON_DATA = os.path.expanduser("~/.local/share/nvim/mason")
INDEX_PATH = os.path.join(
    MASON_DATA,
    "packages/vtsls/node_modules/@vtsls/language-server"
    "/node_modules/@vtsls/language-service/dist/index.js",
)

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
    if not os.path.exists(INDEX_PATH):
        print(f"ERROR: vtsls not found at expected path:\n  {INDEX_PATH}", file=sys.stderr)
        sys.exit(1)

    with open(INDEX_PATH, "r") as f:
        content = f.read()

    if NEW in content:
        print("Already patched, nothing to do.")
        return

    count = content.count(OLD)
    if count == 0:
        print(
            "WARNING: patch target not found — vtsls may have been updated and the patch\n"
            "needs to be reviewed. Check the dispatchResponse error handling in:\n"
            f"  {INDEX_PATH}",
            file=sys.stderr,
        )
        sys.exit(1)
    if count > 1:
        print("ERROR: multiple matches found, cannot patch safely.", file=sys.stderr)
        sys.exit(1)

    # Backup
    backup = INDEX_PATH + ".bak"
    shutil.copy2(INDEX_PATH, backup)
    print(f"Backup: {backup}")

    patched = content.replace(OLD, NEW)
    with open(INDEX_PATH, "w") as f:
        f.write(patched)

    print("vtsls patched successfully.")


if __name__ == "__main__":
    main()
