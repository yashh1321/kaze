#!/usr/bin/env bash
# ==============================================================================
# KAZE - Universal Installer for Linux & macOS
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/yashh1323/kaze/main/install.sh | bash
# ==============================================================================

set -euo pipefail

REPO="yashh1323/kaze"
BIN_NAME="kaze"

# 1. Detect OS
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
case "$OS" in
    linux*)  OS="linux" ;;
    darwin*) OS="darwin" ;;
    *) echo "Error: Unsupported operating system: $OS" >&2; exit 1 ;;
esac

# 2. Detect CPU Architecture
ARCH="$(uname -m)"
case "$ARCH" in
    x86_64|amd64) ARCH="amd64" ;;
    aarch64|arm64) ARCH="arm64" ;;
    *) echo "Error: Unsupported CPU architecture: $ARCH" >&2; exit 1 ;;
esac

echo ""
echo "========================================="
echo "       KAZE (Kaze) Installer"
echo "========================================="
echo ""

# 3. Resolve Download URLs (with optional env overrides for testing)
ASSET_NAME="kaze-$OS-$ARCH.tar.gz"
RELEASE_TAG="${KAZE_VERSION:-latest}"

if [ -n "${KAZE_DOWNLOAD_URL:-}" ]; then
    DOWNLOAD_URL="$KAZE_DOWNLOAD_URL"
    CHECKSUM_URL="${KAZE_CHECKSUM_URL:-$(dirname "$KAZE_DOWNLOAD_URL")/SHA256SUMS}"
elif [ "$RELEASE_TAG" = "latest" ]; then
    DOWNLOAD_URL="https://github.com/$REPO/releases/latest/download/$ASSET_NAME"
    CHECKSUM_URL="https://github.com/$REPO/releases/latest/download/SHA256SUMS"
else
    DOWNLOAD_URL="https://github.com/$REPO/releases/download/$RELEASE_TAG/$ASSET_NAME"
    CHECKSUM_URL="https://github.com/$REPO/releases/download/$RELEASE_TAG/SHA256SUMS"
fi

INSTALL_DIR="/usr/local/bin"
if [ ! -w "$INSTALL_DIR" ]; then
    INSTALL_DIR="$HOME/.local/bin"
    mkdir -p "$INSTALL_DIR"
fi

# 4. Download, Verify Checksum, and Install
echo "[1/4] Preparing download for $OS-$ARCH..."
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

echo "[2/4] Downloading Kaze ($OS-$ARCH)..."
if ! curl -sSL --fail "$DOWNLOAD_URL" -o "$TMP_DIR/$ASSET_NAME"; then
    echo "Error: Failed to download release binary from $DOWNLOAD_URL" >&2
    echo "Please visit https://github.com/$REPO/releases to verify release availability." >&2
    exit 1
fi

# Verify SHA256 Checksum (Fail-Closed)
echo "[*] Verifying cryptographic checksum (SHA256)..."
if ! curl -sSL --fail "$CHECKSUM_URL" -o "$TMP_DIR/SHA256SUMS"; then
    echo "Error: Failed to download checksum manifest from $CHECKSUM_URL. Aborting." >&2
    exit 1
fi

# Normalize CRLF line endings to LF
tr -d '\r' < "$TMP_DIR/SHA256SUMS" > "$TMP_DIR/SHA256SUMS.unix"

if ! grep "[[:space:]]${ASSET_NAME}\$" "$TMP_DIR/SHA256SUMS.unix" > "$TMP_DIR/CHECKSUM_CHECK"; then
    echo "Error: Asset '$ASSET_NAME' not found in SHA256SUMS manifest. Aborting." >&2
    exit 1
fi

if command -v sha256sum >/dev/null 2>&1; then
    (cd "$TMP_DIR" && sha256sum -c "CHECKSUM_CHECK")
elif command -v shasum >/dev/null 2>&1; then
    (cd "$TMP_DIR" && shasum -a 256 -c "CHECKSUM_CHECK")
else
    echo "Error: Neither sha256sum nor shasum is available to verify checksum. Aborting." >&2
    exit 1
fi
echo "  -> Checksum verified successfully."

# Extract and install binary
tar -xzf "$TMP_DIR/$ASSET_NAME" -C "$TMP_DIR"

if [ -f "$TMP_DIR/$BIN_NAME" ]; then
    TARGET_BIN="$TMP_DIR/$BIN_NAME"
else
    # Fallback search if binary was packed under target name
    TARGET_BIN="$(find "$TMP_DIR" -maxdepth 2 -type f \( -name "kaze" -o -name "kaze-*" \) ! -name "*.tar.gz" ! -name "*.md" ! -name "LICENSE*" | head -n 1)"
fi

if [ -z "$TARGET_BIN" ] || [ ! -f "$TARGET_BIN" ]; then
    echo "Error: Executable binary not found in downloaded archive." >&2
    exit 1
fi

cp "$TARGET_BIN" "$INSTALL_DIR/$BIN_NAME"
chmod +x "$INSTALL_DIR/$BIN_NAME"

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
    echo "[NOTE] MPV video player was not found in your PATH."
    if [ "$OS" = "darwin" ]; then
        echo "To install on macOS run: brew install mpv"
    else
        echo "To install on Linux run: sudo apt install mpv (or pacman -S mpv / dnf install mpv)"
    fi
else
    echo "  -> mpv player detected: $(command -v mpv)"
fi

echo ""
echo "KAZE installed successfully! Run 'kaze' in your terminal."
echo ""
