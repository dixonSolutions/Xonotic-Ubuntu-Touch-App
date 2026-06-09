#!/usr/bin/env bash
# setup-clickable.sh
#
# Docker was already installed by the previous run.
# This script installs clickable-ut into a local Python venv — NO sudo needed.
# Run it from any terminal, including Cursor's terminal.
#
# If Docker/group setup is still needed, paste the three lines under
# "ONE-TIME SUDO BLOCK" into a proper terminal (file manager → Open Terminal,
# or Ctrl+Alt+T) where you can type your password.
#
# ── ONE-TIME SUDO BLOCK (paste in a real terminal if not done yet) ────────────
#   sudo systemctl enable --now docker
#   sudo usermod -aG docker "$USER"
#   newgrp docker      # or log out and back in
# ─────────────────────────────────────────────────────────────────────────────

set -euo pipefail
RESET='\033[0m'; BOLD='\033[1m'; GREEN='\033[32m'; YELLOW='\033[33m'
step() { echo -e "\n${BOLD}${GREEN}▶ $*${RESET}"; }
info() { echo -e "${YELLOW}  $*${RESET}"; }

VENV_DIR="$HOME/.clickable-venv"

step "Creating Python venv at $VENV_DIR"
python3 -m venv "$VENV_DIR"
info "venv ready"

step "Installing clickable-ut into venv (no sudo required)"
"$VENV_DIR/bin/pip" install --quiet --upgrade pip
"$VENV_DIR/bin/pip" install --quiet clickable-ut
info "clickable-ut installed: $("$VENV_DIR/bin/clickable" --version 2>&1 | head -1)"

step "Writing wrapper to ~/.local/bin/clickable"
mkdir -p "$HOME/.local/bin"
cat > "$HOME/.local/bin/clickable" <<EOF
#!/usr/bin/env bash
exec "$VENV_DIR/bin/clickable" "\$@"
EOF
chmod +x "$HOME/.local/bin/clickable"
info "wrapper written — make sure ~/.local/bin is on your PATH"
info "(add to ~/.bashrc:  export PATH=\"\$HOME/.local/bin:\$PATH\")"

step "Verifying Docker is reachable"
if docker info &>/dev/null; then
    info "Docker OK — $(docker info --format '{{.ServerVersion}}' 2>/dev/null)"
else
    echo ""
    echo "  Docker not reachable yet. Run these in a real terminal (Ctrl+Alt+T):"
    echo "    sudo systemctl enable --now docker"
    echo "    sudo usermod -aG docker \$USER"
    echo "  Then log out and back in (or run: newgrp docker)."
fi

step "Done"
echo ""
echo "  To preview the UI:"
echo "    export PATH=\"\$HOME/.local/bin:\$PATH\"   # if not already in .bashrc"
echo "    newgrp docker                             # activate docker group"
echo "    cd $(pwd)"
echo "    clickable desktop                         # runs QML in UT Qt window"
echo ""
echo "  To build the arm64 click package:"
echo "    clickable build --arch arm64"
