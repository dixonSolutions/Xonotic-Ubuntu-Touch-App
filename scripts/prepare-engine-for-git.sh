#!/bin/bash
# Strip nested .git under engine/ so this repo tracks the full Xonotic tree as plain files.
# Run after init-xonotic-fork.sh (full clone). Build artifacts stay gitignored.
set -euo pipefail

ROOT="${ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
YES=0

usage() {
    echo "Usage: $0 [--yes]" >&2
    echo "  Removes engine/**/.git so git add engine/ tracks the full fork, not gitlinks." >&2
    exit 1
}

while [ $# -gt 0 ]; do
    case "$1" in
        --yes|-y) YES=1 ;;
        -h|--help) usage ;;
        *) echo "Unknown option: $1" >&2; usage ;;
    esac
    shift
done

if [ ! -f "$ROOT/engine/all" ]; then
    echo "Missing engine/ — run ./scripts/init-xonotic-fork.sh first" >&2
    exit 1
fi

mapfile -t GIT_DIRS < <(find "$ROOT/engine" -name .git -type d | sort)
if [ "${#GIT_DIRS[@]}" -eq 0 ]; then
    echo "No nested .git directories under engine/ (already prepared)."
    exit 0
fi

echo "Nested git directories to remove:"
printf '  %s\n' "${GIT_DIRS[@]}"
echo
echo "After removal, the entire Xonotic project is committed in this repo (~3–5 GB)."
echo "GitHub may warn about repo size; use Git LFS or a fork mirror if needed."
echo

if [ "$YES" -ne 1 ]; then
    read -r -p "Continue? [y/N] " reply
    case "$reply" in
        y|Y|yes|YES) ;;
        *) echo "Aborted."; exit 1 ;;
    esac
fi

for dir in "${GIT_DIRS[@]}"; do
    rm -rf "$dir"
done

# Upstream superproject gitignores sub-repos; we vendor the full tree in this port repo.
cat > "$ROOT/engine/.gitignore" <<'EOF'
# Port repo vendors the full Xonotic tree (upstream superproject ignores sub-repos).
/build/
/daemon-glue
/div0-gittools
/netradiant
/netradiant-xonoticpack
/mediasource
/*.d0si
*.yes
*.no
/data.old/
/xonstat-go/
/xonstatdb/
/xonstat-badges/
/xonotic.org
/xonotic.wiki
/wiki
.idea/
/result*
/.serverbench_temp
_CodeSignature/
EOF

cat > "$ROOT/engine/data/.gitignore" <<'EOF'
# Build outputs only; full pk3dir content is tracked in this port repo.
*.pk3
*.log
EOF

echo "Done. Next:"
echo "  ./scripts/clean-local-artifacts.sh"
echo "  git add engine/"
echo "  git commit -m \"Add full Xonotic fork under engine/\""
