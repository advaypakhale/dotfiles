#!/usr/bin/env bash
# Install neovim + tooling from the latest released binaries.
# Supports Linux (x86_64 / arm64) and macOS Apple Silicon.
set -eo pipefail

# ---- platform / arch detection ----
OS="$(uname -s)"
ARCH="$(uname -m)"

case "$OS" in
Linux) PLATFORM=linux ;;
Darwin) PLATFORM=macos ;;
*)
	echo "Unsupported OS: $OS" >&2
	exit 1
	;;
esac

case "$ARCH" in
x86_64 | amd64) CPU=x86_64 ;;
aarch64 | arm64) CPU=arm64 ;;
*)
	echo "Unsupported architecture: $ARCH" >&2
	exit 1
	;;
esac

case "${PLATFORM}-${CPU}" in
linux-x86_64 | linux-arm64 | macos-arm64) ;;
*)
	echo "Unsupported platform/arch: ${PLATFORM}/${CPU}" >&2
	exit 1
	;;
esac

echo "Detected platform: ${PLATFORM} / ${CPU}"

# ---- helpers ----
BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"

# Append a line to ~/.bashrc only if it isn't already present.
add_path() {
	grep -qsF "$1" "$HOME/.bashrc" || echo "$1" >>"$HOME/.bashrc"
}

# Resolve the latest release tag of a GitHub repo by following the
# /releases/latest redirect (no API token / jq needed).
latest_tag() {
	curl -fsSLI -o /dev/null -w '%{url_effective}' \
		"https://github.com/$1/releases/latest" | sed 's#.*/tag/##'
}

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
cd "$TMP"

add_path 'export PATH="$PATH:$HOME/.local/bin"'

# ---- Install neovim ----
# Asset names: nvim-{linux,macos}-{x86_64,arm64}.tar.gz
NVIM_DIR="nvim-${PLATFORM}-${CPU}"
curl -fLO "https://github.com/neovim/neovim/releases/latest/download/${NVIM_DIR}.tar.gz"
# macOS: clear quarantine attrs to avoid an "unknown developer" warning (per nvim release notes).
[ "$PLATFORM" = macos ] && xattr -c "${NVIM_DIR}.tar.gz"
sudo rm -rf "/opt/${NVIM_DIR}"
sudo tar -C /opt -xzf "${NVIM_DIR}.tar.gz"
add_path "export PATH=\"\$PATH:/opt/${NVIM_DIR}/bin\""

# ---- Install ripgrep ----
# Picks the rust target triple ripgrep actually publishes per platform.
case "${PLATFORM}-${CPU}" in
linux-x86_64) RG_TRIPLE=x86_64-unknown-linux-musl ;;
linux-arm64) RG_TRIPLE=aarch64-unknown-linux-gnu ;;
macos-arm64) RG_TRIPLE=aarch64-apple-darwin ;;
esac
RG_TAG="$(latest_tag BurntSushi/ripgrep)" # e.g. 14.1.1
curl -fLO "https://github.com/BurntSushi/ripgrep/releases/download/${RG_TAG}/ripgrep-${RG_TAG}-${RG_TRIPLE}.tar.gz"
tar -xzf "ripgrep-${RG_TAG}-${RG_TRIPLE}.tar.gz"
install -m 0755 "ripgrep-${RG_TAG}-${RG_TRIPLE}/rg" "$BIN_DIR/rg"

# ---- Install fd ----
case "${PLATFORM}-${CPU}" in
linux-x86_64) FD_TRIPLE=x86_64-unknown-linux-musl ;;
linux-arm64) FD_TRIPLE=aarch64-unknown-linux-musl ;;
macos-arm64) FD_TRIPLE=aarch64-apple-darwin ;;
esac
FD_TAG="$(latest_tag sharkdp/fd)" # e.g. v10.4.2
curl -fLO "https://github.com/sharkdp/fd/releases/download/${FD_TAG}/fd-${FD_TAG}-${FD_TRIPLE}.tar.gz"
tar -xzf "fd-${FD_TAG}-${FD_TRIPLE}.tar.gz"
install -m 0755 "fd-${FD_TAG}-${FD_TRIPLE}/fd" "$BIN_DIR/fd"

# ---- Install tree-sitter CLI ----
# nvim-treesitter's `main` branch compiles parsers with it. Built from source:
# prebuilt binaries (>=0.26.1) need glibc 2.39, too new for e.g. Ubuntu 22.04.
command -v cargo >/dev/null 2>&1 ||
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
# Point bindgen at the C compiler's builtin headers; rquickjs-sys needs stdbool.h
# and fails when libclang's own resource headers aren't installed.
BINDGEN_EXTRA_CLANG_ARGS="-I$(cc -print-file-name=include)" \
	"$HOME/.cargo/bin/cargo" install tree-sitter-cli

# ---- Install nvm and node ----
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
# Match nvm's own XDG-aware NVM_DIR resolution, then source it for this shell.
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "$HOME/.nvm" || printf %s "$XDG_CONFIG_HOME/nvm")"
# shellcheck disable=SC1091
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm install node

# ---- Install go ----
# go.dev assets: go{ver}.{linux,darwin}-{amd64,arm64}.tar.gz
case "$PLATFORM" in
linux) GOOS=linux ;;
macos) GOOS=darwin ;;
esac
case "$CPU" in
x86_64) GOARCH=amd64 ;;
arm64) GOARCH=arm64 ;;
esac
GO_VER="$(curl -fsSL 'https://go.dev/VERSION?m=text' | head -n1)" # e.g. go1.25.3
curl -fLO "https://go.dev/dl/${GO_VER}.${GOOS}-${GOARCH}.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "${GO_VER}.${GOOS}-${GOARCH}.tar.gz"
add_path 'export PATH="$PATH:/usr/local/go/bin"'

echo "Done. Restart your shell or 'source ~/.bashrc' to pick up PATH changes."
