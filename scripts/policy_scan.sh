#!/usr/bin/env bash
set -euo pipefail

expected='leanprover/lean4:v4.32.1'
actual="$(tr -d '\r\n' < lean-toolchain)"
if [[ "$actual" != "$expected" ]]; then
  echo "wrong Lean toolchain: $actual" >&2
  exit 1
fi

if [[ -e lake-manifest.json ]]; then
  echo 'unexpected dependency manifest' >&2
  exit 1
fi

if grep -En '^[[:space:]]*require\b' lakefile.lean; then
  echo 'third-party Lake dependencies are prohibited' >&2
  exit 1
fi

mapfile -t sources < <(git ls-files -- '*.lean')
if ((${#sources[@]} == 0)); then
  echo 'no tracked Lean sources' >&2
  exit 1
fi

if grep -En '\b(sorry|admit|axiom|opaque|unsafe|native_decide|run_tac)\b' "${sources[@]}"; then
  echo 'prohibited declaration or proof escape in Lean source' >&2
  exit 1
fi

while IFS= read -r line; do
  if [[ ! "$line" =~ ^import\ (Lake|Std|APCILeanAudit)(\.[[:alnum:]_]+)*$ ]]; then
    echo "non-core/non-local import: $line" >&2
    exit 1
  fi
done < <(grep -hE '^import ' "${sources[@]}")

expected_source='4c889bb710defdde74c340a47182be31b59fe4c86fabaace403c9c3445420ff8  Abstract_Physical_Certification_Impossibility_Run_0001.zip'
actual_source="$(tr -d '\r\n' < source/SOURCE_ARCHIVE.sha256)"
if [[ "$actual_source" != "$expected_source" ]]; then
  echo 'source archive lock drifted' >&2
  exit 1
fi
./scripts/check_inventory.py

echo "policy pass: ${#sources[@]} Lean sources; pinned core+Std boundary"
