#!/usr/bin/env bash
# Install JetBrains Mono Nerd Font into the user font directory.
#
# This installs the full JetBrainsMono Nerd Font family, which includes the
# "JetBrainsMonoNL Nerd Font Propo" variant referenced in alacritty.toml.
#
# Usage: ./install_jetbrains_mono.sh
set -euo pipefail

NERD_FONTS_VERSION="v3.4.0"
FONT_ZIP="JetBrainsMono.zip"
FONT_DIR="${HOME}/.local/share/fonts/JetBrainsMonoNerdFont"
URL="https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_FONTS_VERSION}/${FONT_ZIP}"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

echo "Downloading JetBrainsMono Nerd Font ${NERD_FONTS_VERSION}..."
curl -fsSL -o "${tmp}/${FONT_ZIP}" "$URL"

echo "Installing to ${FONT_DIR}..."
mkdir -p "$FONT_DIR"
# -o overwrites so re-runs upgrade in place; only ttf files are needed
unzip -oq "${tmp}/${FONT_ZIP}" '*.ttf' -d "$FONT_DIR"

echo "Refreshing font cache..."
fc-cache -f "$FONT_DIR" >/dev/null

echo "Done. Verify with: fc-list | grep -i 'JetBrainsMono'"
