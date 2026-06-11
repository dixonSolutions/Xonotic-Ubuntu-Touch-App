#!/bin/bash
# Clickable + Podman leaves buildah "working containers" and dangling image
# layers (~4.5 GB per desktop run). Run this after clickable desktop/build.
set -euo pipefail

buildah rm -a 2>/dev/null || true
podman container prune -f 2>/dev/null || true
podman image prune -f 2>/dev/null || true

if [ -d "${HOME}/.local/share/containers/storage" ]; then
    echo "Podman storage: $(du -sh "${HOME}/.local/share/containers/storage" | cut -f1)"
fi
