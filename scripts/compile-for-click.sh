#!/bin/bash
# Compile inside Clickable SDK only — maintainers should not run this locally.
set -euo pipefail

ROOT="${ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
OUT_DIR="$ROOT/build/bin"
OUT_BIN="$OUT_DIR/xonotic"

if [ ! -f "$ROOT/engine/darkplaces/makefile.inc" ]; then
    bash "$ROOT/scripts/fetch-sources.sh" code
fi

mkdir -p "$OUT_DIR"

if [ -f "$ROOT/engine/data/xonotic-data.pk3dir/qcsrc/Makefile" ]; then
    echo "Compiling QuakeC + engine (integrated engine/ tree, Clickable SDK)..."
    cd "$ROOT/engine"
    export MAKEFLAGS="${MAKEFLAGS:--j$(nproc)}"
    # Build deps + QC + SDL client; skip map autobuild download at end of ./all compile.
    cd d0_blind_id
    if [ ! -f Makefile ]; then
        sh autogen.sh
        ./configure
    fi
    make $MAKEFLAGS
    cd "$ROOT/engine/gmqcc"
    make $MAKEFLAGS gmqcc
    cd "$ROOT/engine/data/xonotic-data.pk3dir"
    make QCC="../../gmqcc/gmqcc" $MAKEFLAGS
    cd "$ROOT/engine/darkplaces"
    make clean >/dev/null 2>&1 || true
    make sdl-release DP_SSE=0 $MAKEFLAGS STRIP=:
    install -m 755 darkplaces-sdl "$OUT_BIN"
else
    echo "Compiling DarkPlaces only..."
    bash "$ROOT/scripts/build-engine.sh"
    exit 0
fi

echo "Built $OUT_BIN ($(file -b "$OUT_BIN"))"
