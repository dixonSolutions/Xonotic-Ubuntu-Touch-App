#!/bin/bash
# Stage click package from build outputs (binary built during build step).
set -euo pipefail

ROOT="${ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
DEST="${CLICKABLE_DEST:?CLICKABLE_DEST not set}"

ARCH="${ARCH:-arm64}"
CLICK_FRAMEWORK="${CLICK_FRAMEWORK:-ubuntu-sdk-20.04}"
APPARMOR_POLICY="${APPARMOR_POLICY:-16.04}"

BIN="$ROOT/build/bin/xonotic"
test -x "$BIN" || {
    echo "Missing build/bin/xonotic — run build first" >&2
    exit 1
}

mkdir -p "$DEST/bin" "$DEST/data" "$DEST/share/xonotic"

install -m 755 "$BIN" "$DEST/bin/xonotic"
install -m 755 "$ROOT/packaging/start.sh" "$DEST/bin/start.sh"
install -m 755 "$ROOT/touch/screen-calc.sh" "$DEST/share/xonotic/screen-calc.sh"

if [ -d "$ROOT/engine/data" ]; then
    cp -a "$ROOT/engine/data/." "$DEST/data/"
fi
if [ -f "$ROOT/data/xonotic.cfg" ]; then
    install -m 644 "$ROOT/data/xonotic.cfg" "$DEST/data/xonotic.cfg"
fi
if [ -d "$ROOT/touch/profiles" ]; then
    mkdir -p "$DEST/data/touch/profiles"
    cp -a "$ROOT/touch/profiles/." "$DEST/data/touch/profiles/"
fi

install -m 644 "$ROOT/xonotic.apparmor" "$DEST/share/xonotic/xonotic.apparmor"

sed -e "s/\$ENV{ARCH}/${ARCH}/g" \
    -e "s/\$ENV{CLICK_FRAMEWORK}/${CLICK_FRAMEWORK}/g" \
    -e "s/\$ENV{APPARMOR_POLICY}/${APPARMOR_POLICY}/g" \
    "$ROOT/manifest.json.in" > "$DEST/manifest.json"

sed "s/@ARCH_TRIPLET@/${ARCH_TRIPLET:-aarch64-linux-gnu}/g" \
    "$ROOT/xonotic.desktop.in" > "$DEST/xonotic.desktop"

echo "Installed click package to $DEST"
