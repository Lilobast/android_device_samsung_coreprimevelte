#!/bin/bash
# Apply the coreprimevelte commits to the upstream LineageOS 16.0 projects.
# Run from anywhere: device/samsung/coreprimevelte/coreprimevelte_patchs/apply.sh
# <project>/*.patch are git format-patch files, applied with git am (one commit each).
# upstream-bases.txt: the upstream commit each set was made on; release-trees.txt: the tree the
# project has after the patches in the 2026-11-17 release. Re-running is safe.
set -e
P=$(cd "$(dirname "$0")" && pwd)
T=$(cd "$P/../../../.." && pwd)
while read proj base; do
  [ -d "$T/$proj/.git" ] || [ -f "$T/$proj/.git" ] || { echo "missing project $proj (repo sync first)"; exit 1; }
  cd "$T/$proj"
  want=$(awk -v p="$proj" '$1==p {print $2}' "$P/release-trees.txt")
  if [ "$(git rev-parse HEAD^{tree})" = "$want" ]; then echo "already applied: $proj"; continue; fi
  [ "$(git rev-parse HEAD)" = "$base" ] || echo "note: $proj is not at the release base ${base:0:12}, applying 3-way"
  git am -q --3way "$P/$proj"/*.patch || { echo "FAILED: $proj (git am --continue / --abort there)"; exit 1; }
  if [ "$(git rev-parse HEAD^{tree})" = "$want" ]; then echo "applied: $proj (identical to the release)"
  else echo "applied: $proj (different base, not byte-identical to the release)"; fi
done < "$P/upstream-bases.txt"
echo DONE
