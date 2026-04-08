#!/usr/bin/env bash
# nx-vitest-wrapper.sh
#
# Translates neotest-vitest's flags into `yarn nx run <project>:test` flags.
#
# neotest-vitest invokes us as:
#   <this-script> <nx-project> [--watch=false] [--reporter=verbose]
#       [--reporter=json] [--outputFile=<path>]
#       [--testNamePattern=<pattern>] <abs-path-to-spec-file>
#
# We translate to:
#   yarn nx run <project>:test --watch=false --reporters=json
#       --outputFile=<path> --filter=<pattern> --include=<abs-path>

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <nx-project> [neotest-vitest flags...]" >&2
  exit 1
fi

NX_PROJECT="$1"
shift

OUTPUT_FILE=""
TEST_NAME_PATTERN=""
SPEC_FILE=""

for arg in "$@"; do
  case "$arg" in
    --watch=*)
      # handled explicitly below
      ;;
    --reporter=verbose)
      # drop: we only need json output
      ;;
    --reporter=json)
      # handled explicitly below
      ;;
    --outputFile=*)
      OUTPUT_FILE="${arg#--outputFile=}"
      ;;
    --testNamePattern=*)
      TEST_NAME_PATTERN="${arg#--testNamePattern=}"
      ;;
    --config=*)
      # drop: nx executor manages its own config
      ;;
    -*)
      # pass through any other flags (e.g. extra_args from neotest)
      ;;
    *)
      # positional arg = spec file path
      SPEC_FILE="$arg"
      ;;
  esac
done

CMD=(yarn nx run "${NX_PROJECT}:test" --watch=false --reporters=json)

if [[ -n "$OUTPUT_FILE" ]]; then
  CMD+=(--outputFile="$OUTPUT_FILE")
fi

if [[ -n "$TEST_NAME_PATTERN" ]]; then
  CMD+=(--filter="$TEST_NAME_PATTERN")
fi

if [[ -n "$SPEC_FILE" ]]; then
  CMD+=(--include="$SPEC_FILE")
fi

exec "${CMD[@]}"
