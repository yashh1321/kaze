#!/usr/bin/env bash
# ==============================================================================
# KAZE (風) - Universal 1-Line Installer for Linux & macOS
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/yashh1321/kaze/main/install.sh | bash
# ==============================================================================

set -e

REPO="yashh1321/kaze"
BIN_NAME="kaze"

# 1. Detect OS
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
case "$OS" in
    linux*)  OS="linux" ;;
    darwin*) OS="darwin" ;;
    *) echo "Unsupported operating system: $OS"; exit 1 ;;
esac

# 2. Detect CPU Architecture
ARCH="$(uname -m)"
case "$ARCH" in
    x86_64|amd64) ARCH="amd64" ;;
    aarch64|arm64) ARCH="arm64" ;;
    *) echo "Unsupported CPU architecture: $ARCH"; exit 1 ;;
esac

echo ""
echo "========================================="
echo "       🍃 KAZE (風) Installer"
echo "========================================="
echo ""

# 3. Download URL from GitHub Releases
echo "[1/4] Preparing download for $OS-$ARCH..."
ASSET_NAME="kaze-$OS-$ARCH.tar.gz"
DOWNLOAD_URL="https://github.com/$REPO/releases/latest/download/$ASSET_NAME"

INSTALL_DIR="/usr/local/bin"
if [ ! -w "$INSTALL_DIR" ]; then
    INSTALL_DIR="$HOME/.local/bin"
    mkdir -p "$INSTALL_DIR"
fi

# 4. Download and Install Binary
echo "[2/4] Downloading Kaze ($OS-$ARCH)..."
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

if curl -sL --fail "$DOWNLOAD_URL" -o "$TMP_DIR/kaze.tar.gz"; then
    tar -xzf "$TMP_DIR/kaze.tar.gz" -C "$TMP_DIR"
    cp "$TMP_DIR/$BIN_NAME" "$INSTALL_DIR/$BIN_NAME"
    chmod +x "$INSTALL_DIR/$BIN_NAME"
else
    echo "Error: Failed to download release binary from $DOWNLOAD_URL."
    echo "Please visit https://github.com/$REPO/releases/latest to verify release availability."
    exit 1
fi

echo "[3/4] Installed binary to $INSTALL_DIR/$BIN_NAME"

# Check PATH
case ":$PATH:" in
    *:"$INSTALL_DIR":*) ;;
    *) echo "Warning: $INSTALL_DIR is not in your PATH. Add it to ~/.bashrc or ~/.zshrc:"
       echo "  export PATH=\"\$PATH:$INSTALL_DIR\"" ;;
esac

# 5. Check MPV dependency
echo "[4/4] Verifying dependencies..."
if ! command -v mpv >/dev/null 2>&1; then
    echo ""
    echo -e "\033[1;33m[NOTE] MPV video player was not found in your PATH.\033[0m"
    if [ "$OS" = "darwin" ]; then
        echo "To install on macOS run: brew install mpv"
    else
        echo "To install on Linux run: sudo apt install mpv (or pacman -S mpv / dnf install mpv)"
    fi
else
    echo "✓ mpv player detected: $(command -v mpv)"
fi

echo ""
echo -e "\033[1;32m🎉 KAZE installed successfully! Run 'kaze' in your terminal.\033[0m"
echo ""
