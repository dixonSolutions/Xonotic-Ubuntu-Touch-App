#!/bin/sh
# Launch wrapper for the confined click package (binary produced at build time).
set -e

APP_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DATA_DIR="${APP_ROOT}/data"
BIN="${APP_ROOT}/bin/xonotic"
SCREEN_CALC="${APP_ROOT}/share/xonotic/screen-calc.sh"
LAYOUT_CFG="${DATA_DIR}/screen.layout.cfg"

if [ ! -x "$BIN" ]; then
    echo "xonotic: engine binary not found at $BIN" >&2
    exit 1
fi

cd "$DATA_DIR"

if [ -f "$SCREEN_CALC" ]; then
    # shellcheck source=/dev/null
    . "$SCREEN_CALC"
    xonotic_screen_calc "$LAYOUT_CFG"
else
    echo "xonotic: screen-calc missing at $SCREEN_CALC" >&2
    XONOTIC_VID_WIDTH="${XONOTIC_DEFAULT_WIDTH:-1920}"
    XONOTIC_VID_HEIGHT="${XONOTIC_DEFAULT_HEIGHT:-1080}"
    XONOTIC_TOUCH_XDPI="${XONOTIC_TOUCH_XDPI:-320}"
    XONOTIC_TOUCH_YDPI="${XONOTIC_TOUCH_YDPI:-320}"
    XONOTIC_TOUCH_DENSITY="${XONOTIC_TOUCH_DENSITY:-2.0}"
    cat > "$LAYOUT_CFG" <<EOF
// Fallback layout (screen-calc.sh not installed)
vid_width ${XONOTIC_VID_WIDTH}
vid_height ${XONOTIC_VID_HEIGHT}
vid_touchscreen_xdpi ${XONOTIC_TOUCH_XDPI}
vid_touchscreen_ydpi ${XONOTIC_TOUCH_YDPI}
vid_touchscreen_density ${XONOTIC_TOUCH_DENSITY}
EOF
fi

if [ -n "${LD_LIBRARY_PATH:-}" ]; then
    export LD_LIBRARY_PATH="${APP_ROOT}/lib:${LD_LIBRARY_PATH}"
else
    export LD_LIBRARY_PATH="${APP_ROOT}/lib"
fi

exec "$BIN" -xonotic \
    +exec xonotic.cfg \
    +exec screen.layout.cfg \
    +vid_fullscreen 1 \
    +vid_touchscreen 1 \
    +vid_width "$XONOTIC_VID_WIDTH" \
    +vid_height "$XONOTIC_VID_HEIGHT" \
    +vid_touchscreen_xdpi "$XONOTIC_TOUCH_XDPI" \
    +vid_touchscreen_ydpi "$XONOTIC_TOUCH_YDPI" \
    +vid_touchscreen_density "$XONOTIC_TOUCH_DENSITY" \
    +cl_movement 1 \
    +con_closeontoggle 1 \
    +scr_screenshot_jpeg 0
