#!/bin/bash
# Populate engine/ with upstream source (no compile — saves disk and CPU).
set -euo pipefail

ROOT="${ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
cd "$ROOT"

MODE="${1:-code}"
XONOTIC_URL="${XONOTIC_URL:-https://gitlab.com/xonotic/xonotic.git}"
DARKPLACES_URL="${DARKPLACES_URL:-https://gitlab.com/xonotic/darkplaces.git}"
GMQCC_URL="${GMQCC_URL:-https://gitlab.com/xonotic/gmqcc.git}"
DATA_URL="${DATA_URL:-https://gitlab.com/xonotic/xonotic-data.pk3dir.git}"
BLIND_ID_URL="${BLIND_ID_URL:-https://gitlab.com/xonotic/d0_blind_id.git}"

clone_repo() {
    local dest="$1"
    local url="$2"
    if [ -d "$dest/.git" ] || [ -f "$dest/makefile.inc" ] || [ -f "$dest/Makefile" ]; then
        echo "  present: $dest"
        return 0
    fi
    echo "  cloning: $url -> $dest"
    rm -rf "$dest"
    git clone --depth 1 "$url" "$dest"
}

if [ -d "$ROOT/engine/.git" ] && [ -f "$ROOT/engine/all" ]; then
    echo "engine/ superproject already initialized"
else
    echo "Cloning Xonotic superproject into engine/..."
    rm -rf "$ROOT/engine"
    git clone --depth 1 "$XONOTIC_URL" "$ROOT/engine"
fi

cd "$ROOT/engine"

case "$MODE" in
    minimal)
        clone_repo darkplaces "$DARKPLACES_URL"
        echo "Minimal fetch: engine/darkplaces only (engine C work)"
        ;;
    code)
        clone_repo darkplaces "$DARKPLACES_URL"
        clone_repo gmqcc "$GMQCC_URL"
        clone_repo data/xonotic-data.pk3dir "$DATA_URL"
        clone_repo d0_blind_id "$BLIND_ID_URL"
        echo "Code fetch: darkplaces + gmqcc + xonotic-data.pk3dir + d0_blind_id"
        echo "  UI/controls: engine/data/xonotic-data.pk3dir/qcsrc/{menu,client,common}/"
        ;;
    full)
        echo "Full fetch via ./all update (large — maps, music, all assets)..."
        ./all update -l best
        ;;
    *)
        echo "Usage: $0 [minimal|code|full]" >&2
        exit 1
        ;;
esac

if [ -f "$ROOT/touch/xonotic.cfg" ]; then
    mkdir -p "$ROOT/data"
    cp -f "$ROOT/touch/xonotic.cfg" "$ROOT/data/xonotic.cfg"
    mkdir -p "$ROOT/engine/data"
    cp -f "$ROOT/touch/xonotic.cfg" "$ROOT/engine/data/xonotic.cfg"
fi

echo "Source ready under engine/ (no compile was run)."
