#!/bin/bash
# DarkPlaces-only compile — used by compile-for-click.sh (Clickable SDK).
# Maintainers: do not run locally; use Clickable community for builds.
set -euo pipefail

ROOT="${ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
cd "$ROOT"

DARKPLACES="$ROOT/engine/darkplaces"
OUT_DIR="$ROOT/build/bin"
OUT_BIN="$OUT_DIR/xonotic"

if [ ! -f "$DARKPLACES/makefile.inc" ]; then
    echo "Missing engine/darkplaces — run: scripts/fetch-sources.sh" >&2
    exit 1
fi

mkdir -p "$OUT_DIR"

if command -v apt-get >/dev/null 2>&1; then
    DEBIAN_FRONTEND=noninteractive apt-get update -qq 2>/dev/null || true
    DEBIAN_FRONTEND=noninteractive apt-get install -y -qq \
        make gcc libsdl2-dev libjpeg-dev zlib1g-dev libxmp-dev \
        2>/dev/null || true
fi

echo "Building DarkPlaces for ${ARCH:-host}..."
cd "$DARKPLACES"
make clean >/dev/null 2>&1 || true
make sdl-release DP_SSE=0 -j"$(nproc)"
install -m 755 darkplaces-sdl "$OUT_BIN"

echo "Built $OUT_BIN ($(file -b "$OUT_BIN"))"
