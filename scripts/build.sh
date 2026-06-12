#!/bin/bash
# Clickable build step — compile in SDK, not on maintainer machines.
set -euo pipefail

ROOT="${ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
cd "$ROOT"

bash "$ROOT/scripts/compile-for-click.sh"

test -x "$ROOT/build/bin/xonotic" || {
    echo "Build failed: build/bin/xonotic missing" >&2
    exit 1
}
test -f "$ROOT/packaging/start.sh" || {
    echo "Missing packaging/start.sh" >&2
    exit 1
}
test -f "$ROOT/touch/xonotic.cfg" || {
    echo "Missing touch/xonotic.cfg" >&2
    exit 1
}
test -f "$ROOT/touch/screen-calc.sh" || {
    echo "Missing touch/screen-calc.sh" >&2
    exit 1
}
test -f "$ROOT/touch/profiles/standard.cfg" || {
    echo "Missing touch/profiles/standard.cfg" >&2
    exit 1
}

mkdir -p "$ROOT/data"
cp -f "$ROOT/touch/xonotic.cfg" "$ROOT/data/xonotic.cfg"

echo "Click package build ready for ${ARCH:-unknown}"
