#!/usr/bin/env bash
set -euo pipefail

NERD_FONTS_VERSION="v3.4.0"
FONT_ZIP="JetBrainsMono.zip"
FONT_DIR="${HOME}/.local/share/fonts/JetBrainsMonoNerdFont"
URL="https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_FONTS_VERSION}/${FONT_ZIP}"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

curl -fsSL -o "${tmp}/${FONT_ZIP}" "$URL"
mkdir -p "$FONT_DIR"
unzip -oq "${tmp}/${FONT_ZIP}" '*NerdFontMono-*.ttf' -d "$FONT_DIR"
fc-cache -f "$FONT_DIR" >/dev/null
