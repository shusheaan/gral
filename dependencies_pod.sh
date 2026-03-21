#!/usr/bin/env bash
set -Eeuo pipefail

# pod only home dir override
export HOME=/workspace
export ZDOTDIR=/workspace
export XDG_CONFIG_HOME=/workspace/.config
export XDG_CACHE_HOME=/workspace/.cache
export XDG_DATA_HOME=/workspace/.local/share
export XDG_STATE_HOME=/workspace/.local/state

OMZ_INSTALL_URL="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"


if [ "$(id -u)" -eq 0 ]; then
  SUDO=""
else
  SUDO="sudo"
fi

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m[ok]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[warn]\033[0m %s\n' "$*"; }
err()  { printf '\033[1;31m[err]\033[0m %s\n' "$*" >&2; }

VENV_DIR="/workspace/.venvs/gnn"

log "Updating apt index"
$SUDO apt-get update -y

log "Installing base packages"
$SUDO apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  wget \
  git \
  unzip \
  zip \
  htop \
  tree \
  tmux \
  zsh \
  jq \
  fzf \
  neovim \
  lf \
  bat \
  procps \
  file \
  xz-utils \
  tar \
  build-essential \
  pkg-config \
  cmake \
  python3 \
  python3-pip \
  python3-venv \
  python3-dev \
  nodejs \
  npm

# bat -> batcat fallback on Ubuntu
if ! command -v bat >/dev/null 2>&1 && command -v batcat >/dev/null 2>&1; then
  log "Creating symlink bat -> batcat"
  $SUDO ln -sf "$(command -v batcat)" /usr/local/bin/bat
fi

# watch usually comes from procps
if command -v watch >/dev/null 2>&1; then
  log "watch found: $(command -v watch)"
else
  warn "watch not found"
fi

# install omz
log "Installing Oh My Zsh if needed..."
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
sh -c "$(curl -fsSL "$OMZ_INSTALL_URL")" "" --unattended
ok "Oh My Zsh installed"
else
ok "Oh My Zsh already installed"
fi

local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$zsh_custom/plugins"

clone_or_update_plugin \
"https://github.com/zsh-users/zsh-completions" \
"$zsh_custom/plugins/zsh-completions"

clone_or_update_plugin \
"https://github.com/zsh-users/zsh-syntax-highlighting.git" \
"$zsh_custom/plugins/zsh-syntax-highlighting"

clone_or_update_plugin \
"https://github.com/zsh-users/zsh-autosuggestions.git" \
"$zsh_custom/plugins/zsh-autosuggestions"

if [[ ! -f "$HOME/.zshrc" && -f "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" ]]; then
cp "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$HOME/.zshrc"
ok "Created ~/.zshrc from Oh My Zsh template"
fi

replace_or_append_plugins_line "$HOME/.zshrc"

# rustup
log "Installing rustup"
if ! command -v rustup >/dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

# shellcheck disable=SC1091
source "$HOME/.cargo/env"

log "Installing stable Rust toolchain"
rustup toolchain install stable
rustup default stable
rustup update stable
rustup component add rustfmt clippy rust-src rust-analyzer

# install eza via cargo (most robust cross-Ubuntu fallback)
if ! command -v eza >/dev/null 2>&1; then
  log "Installing eza via cargo"
  cargo install eza || warn "cargo install eza failed"
fi

log "Creating venv with system site-packages at ${VENV_DIR}"
mkdir -p /workspace/.venvs
python3 -m venv --system-site-packages "${VENV_DIR}"

# shellcheck disable=SC1091
source "${VENV_DIR}/bin/activate"

log "Upgrading pip/setuptools/wheel in venv"
python -m pip install --upgrade pip setuptools wheel

log "Checking torch from current venv"
python - <<'PY'
import sys
try:
    import torch
    print("python =", sys.executable)
    print("torch.__version__ =", torch.__version__)
    print("torch.version.cuda =", torch.version.cuda)
    print("torch.cuda.is_available() =", torch.cuda.is_available())
except Exception as e:
    raise SystemExit(f"[ERR] torch is not visible in this venv: {e}")
PY

log "Installing PyG"
python - <<'PY'
import re
import subprocess
import sys
import torch

def run(cmd):
    print("+", " ".join(cmd), flush=True)
    subprocess.check_call(cmd)

torch_ver = torch.__version__.split("+")[0]
cuda_ver = torch.version.cuda

m = re.match(r"^(\d+)\.(\d+)", torch_ver)
if not m:
    raise SystemExit(f"Unsupported torch version format: {torch_ver}")

major, minor = m.groups()
torch_key = f"{major}.{minor}.0"

if cuda_ver is None:
    cuda_key = "cpu"
else:
    parts = cuda_ver.split(".")
    cuda_key = f"cu{parts[0]}{parts[1]}"

wheel_index = f"https://data.pyg.org/whl/torch-{torch_key}+{cuda_key}.html"
print("Using wheel index:", wheel_index)

# Minimal PyG
run([sys.executable, "-m", "pip", "install", "--upgrade", "torch_geometric"])

# Optional performance/ops packages
run([
    sys.executable, "-m", "pip", "install",
    "pyg_lib", "torch_scatter", "torch_sparse", "torch_cluster",
    "-f", wheel_index
])

import torch_geometric
print("torch_geometric.__version__ =", torch_geometric.__version__)
PY

log "Setting zsh as default shell (best effort)"
if command -v chsh >/dev/null 2>&1; then
  chsh -s "$(command -v zsh)" "$(whoami)" || true
fi

grep -Fqs 'export PATH="$HOME/.cargo/bin:$PATH"' "$HOME/.zshrc" || echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> "$HOME/.zshrc"
grep -Fqs 'alias vim="nvim"' "$HOME/.zshrc" || echo 'alias vim="nvim"' >> "$HOME/.zshrc"

log "Summary"
echo "python3: $(command -v python3 || true)"
echo "venv python: ${VENV_DIR}/bin/python"
echo "git: $(command -v git || true)"
echo "htop: $(command -v htop || true)"
echo "fzf: $(command -v fzf || true)"
echo "lf: $(command -v lf || true)"
echo "nvim: $(command -v nvim || true)"
echo "node: $(command -v node || true)"
echo "watch: $(command -v watch || true)"
echo "wget: $(command -v wget || true)"
echo "bat: $(command -v bat || true)"
echo "jq: $(command -v jq || true)"
echo "zsh: $(command -v zsh || true)"
echo "tmux: $(command -v tmux || true)"
echo "rustc: $(command -v rustc || true)"
echo "cargo: $(command -v cargo || true)"
echo "rustup: $(command -v rustup || true)"
echo "rust-analyzer: $(command -v rust-analyzer || true)"
echo "eza: $(command -v eza || true)"

"${VENV_DIR}/bin/python" - <<'PY'
import torch, torch_geometric
print("torch =", torch.__version__)
print("torch CUDA =", torch.version.cuda)
print("torch_geometric =", torch_geometric.__version__)
PY

echo
echo "Activate with:"
echo "source ${VENV_DIR}/bin/activate"