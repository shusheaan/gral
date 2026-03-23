#!/usr/bin/env bash
set -euo pipefail

echo "==> Installing Rust toolchain and dev stack on macOS"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This script is for macOS only."
  exit 1
fi

if ! xcode-select -p >/dev/null 2>&1; then
  echo "==> Xcode Command Line Tools not found. Installing..."
  xcode-select --install || true
  echo
  echo "Please finish the Apple installer popup if it appears,"
  echo "then re-run this script."
  exit 0
else
  echo "==> Xcode Command Line Tools already installed"
fi

if ! command -v rustup >/dev/null 2>&1; then
  echo "==> Installing rustup + stable Rust"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
else
  echo "==> rustup already installed"
fi

# Load cargo env for current shell
if [[ -f "$HOME/.cargo/env" ]]; then
  # shellcheck disable=SC1090
  source "$HOME/.cargo/env"
fi

add_line_if_missing() {
  local file="$1"
  local line="$2"
  mkdir -p "$(dirname "$file")"
  touch "$file"
  if ! grep -Fqs "$line" "$file"; then
    echo "$line" >> "$file"
  fi
}

add_line_if_missing "$HOME/.zprofile" 'source "$HOME/.cargo/env"'
add_line_if_missing "$HOME/.profile"  'source "$HOME/.cargo/env"'
add_line_if_missing "$HOME/.bash_profile" 'source "$HOME/.cargo/env"'

echo "==> Updating rustup"
rustup self update

echo "==> Installing/updating toolchains"
rustup toolchain install stable
rustup toolchain install nightly
rustup toolchain install beta

echo "==> Setting default toolchain to stable"
rustup default stable

echo "==> Installing Rust components"
rustup component add rustfmt clippy rust-src rust-analyzer --toolchain stable
rustup component add rustfmt clippy rust-src --toolchain nightly
rustup component add rustfmt clippy rust-src --toolchain beta

echo "==> Installing common targets"
ARCH="$(uname -m)"
if [[ "$ARCH" == "arm64" ]]; then
  rustup target add aarch64-apple-darwin --toolchain stable
  rustup target add x86_64-apple-darwin --toolchain stable
else
  rustup target add x86_64-apple-darwin --toolchain stable
  rustup target add aarch64-apple-darwin --toolchain stable
fi

rustup target add wasm32-unknown-unknown --toolchain stable

echo "==> Installing common cargo tools"
cargo install cargo-edit        || true
cargo install cargo-watch       || true
cargo install cargo-nextest     || true
cargo install cargo-audit       || true
cargo install cargo-deny        || true
cargo install cargo-outdated    || true
cargo install cargo-expand      || true
cargo install bacon             || true
cargo install sccache           || true
cargo install just              || true

echo
echo "==> Final check"
rustup show
echo
rustc --version
cargo --version
rustfmt --version
cargo clippy --version || true
rust-analyzer --version || true

echo
echo "==> Creating a test project"
TMP_DIR="$(mktemp -d)"
cd "$TMP_DIR"
cargo new rust_stack_smoke_test
cd rust_stack_smoke_test
cargo check
cargo clippy -- -D warnings || true
cargo fmt --check || true

echo
echo "DONE"
echo "Restart your terminal, or run:"
echo '    source "$HOME/.cargo/env"'