#!/usr/bin/env bash
# setup-clickable.sh
# Run this once from any terminal where you can type your sudo password.
# After it completes, close and reopen your terminal (or run: newgrp docker)
# then run: clickable desktop  — to preview the app in the UT Qt environment.
set -euo pipefail

RESET='\033[0m'; BOLD='\033[1m'; GREEN='\033[32m'; YELLOW='\033[33m'
step() { echo -e "\n${BOLD}${GREEN}▶ $*${RESET}"; }
info() { echo -e "${YELLOW}  $*${RESET}"; }

# ── 1. Docker Engine ─────────────────────────────────────────────────────────
step "Installing Docker Engine"
if command -v docker &>/dev/null && docker info &>/dev/null; then
    info "Docker already running — skipping install"
else
    sudo apt-get update -qq
    sudo apt-get install -y docker.io
    sudo systemctl enable --now docker
    info "Docker installed and started"
fi

# ── 2. Add current user to docker group ──────────────────────────────────────
step "Adding $USER to docker group"
if id -nG "$USER" | grep -qw docker; then
    info "Already in docker group"
else
    sudo usermod -aG docker "$USER"
    info "Added — you must run  newgrp docker  or re-login before Docker works without sudo"
fi

# ── 3. Clickable snap ─────────────────────────────────────────────────────────
step "Installing / refreshing Clickable"
if snap list clickable &>/dev/null; then
    info "Clickable already installed ($(clickable --version 2>/dev/null | grep -oP '\d+\.\d+\.\d+' | head -1))"
else
    sudo snap install clickable
fi

# ── 4. Snap interface connections ─────────────────────────────────────────────
step "Wiring snap connections"
sudo snap connect clickable:docker         docker:docker-daemon   2>/dev/null || true
sudo snap connect clickable:docker         docker:docker-executables 2>/dev/null || true
sudo snap connect clickable:ssh-keys       || true
sudo snap connect clickable:etc-gitconfig  || true
info "Connections done"

# ── 5. Pull the UT desktop-mode Docker image (arm64 SDK) ─────────────────────
step "Pulling Ubuntu Touch SDK Docker image for arm64 (this downloads ~1.5 GB once)"
# newgrp is not available here; run docker via sudo for the pull
sudo docker pull clickable/ubuntu-sdk:20.04-arm64 || \
    info "Pull failed — it will retry automatically on first clickable run"

# ── 6. Verify ─────────────────────────────────────────────────────────────────
step "Verification"
clickable --version 2>&1 | head -2
echo ""
echo -e "${BOLD}Setup complete.${RESET}"
echo ""
echo "  Next steps:"
echo "  1.  newgrp docker          # activate group in this shell (or re-login)"
echo "  2.  cd $(pwd)"
echo "  3.  clickable desktop      # run the overlay UI in a native Qt window"
echo "  4.  clickable build --arch arm64   # cross-compile the full click package"
echo ""
echo "  If 'clickable desktop' fails with an Ubuntu.Components import error,"
echo "  the UT SDK image pull in step 5 may need to finish first — run:"
echo "    sudo docker pull clickable/ubuntu-sdk:20.04-arm64"
