#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
source scripts/linux/collect_evidence.sh

test_root="$(mktemp -d)"
trap 'find "$test_root" -type f -delete; find "$test_root" -depth -type d -empty -delete' EXIT
OUTPUT_DIR="$test_root/evidence"

prepare_output
printf 'forensic evidence\n' > "$OUTPUT_DIR/system/sample.txt"
hash_artifacts >/dev/null
first_manifest="$(<"$OUTPUT_DIR/hashes.txt")"
hash_artifacts >/dev/null
second_manifest="$(<"$OUTPUT_DIR/hashes.txt")"

[[ "$first_manifest" == "$second_manifest" ]]
[[ "$first_manifest" != *"hashes.txt"* ]]
[[ "$(stat -c '%a' "$OUTPUT_DIR")" == "700" ]]

create_archive >/dev/null
[[ "$(stat -c '%a' "${OUTPUT_DIR}.tar.gz")" == "600" ]]
if create_archive >/dev/null 2>&1; then
    echo "collector overwrote an existing archive" >&2
    exit 1
fi
