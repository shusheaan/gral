#!/usr/bin/env zsh
set -euo pipefail

# NVIDIA + CUDA + system Python GPU development baseline for Arch Linux.
#
# Target machine: modern NVIDIA desktop GPU, e.g. RTX 5060 Ti.
# Run after ./arch/install.sh:
#   ./arch/python-gpu-dev.sh
#
# This intentionally stays out of arch/packages.txt because CUDA/PyTorch packages
# are large, GPU-specific, and not needed on every Arch install.
#
# Policy: no shared Python venv. PyTorch/Whisper are installed as Arch system
# packages through pacman.

PYTHON_BIN="${GRAL_SYSTEM_PYTHON:-/usr/bin/python}"
WHISPER_MODEL_TO_PREFETCH="${GRAL_WHISPER_MODEL:-${WHISPER_MODEL:-large-v3}}"
OLD_ENV_FILE="$HOME/.config/environment.d/92-gral-python-gpu.conf"

say() {
    print -P "%F{green}==>%f $*"
}

warn() {
    print -P "%F{yellow}warning:%f $*" >&2
}

die() {
    print -P "%F{red}error:%f $*" >&2
    exit 1
}

need_cmd() {
    local cmd="$1"
    command -v "$cmd" >/dev/null 2>&1 || die "missing command: $cmd"
}

pacman_has() {
    local package="$1"
    pacman -Qq "$package" >/dev/null 2>&1
}

install_arch_packages() {
    local -a kernel_headers
    local -a packages

    if [ "${GRAL_SKIP_GPU_PACKAGES:-0}" = "1" ]; then
        say "Skipping pacman packages because GRAL_SKIP_GPU_PACKAGES=1."
        return
    fi

    kernel_headers=()
    if pacman_has linux; then
        kernel_headers+=(linux-headers)
    fi
    if pacman_has linux-lts; then
        kernel_headers+=(linux-lts-headers)
    fi
    if [ ${#kernel_headers[@]} -eq 0 ]; then
        kernel_headers+=(linux-headers)
    fi

    packages=(
        base-devel
        git
        curl
        python
        python-pip
        python-build
        python-installer
        python-wheel
        python-setuptools
        python-numpy
        python-scipy
        python-polars
        python-pytest
        python-hypothesis
        mypy
        ruff
        uv
        nvidia-open-dkms
        nvidia-utils
        opencl-nvidia
        cuda
        cudnn
        nccl
        python-pytorch-cuda
        python-openai-whisper
        "${kernel_headers[@]}"
    )

    say "Installing NVIDIA/CUDA/system Python GPU packages with pacman."
    sudo pacman -Syu --needed "${packages[@]}"
}

refresh_kernel_images() {
    if command -v mkinitcpio >/dev/null 2>&1; then
        say "Refreshing initramfs after NVIDIA DKMS install."
        sudo mkinitcpio -P || warn "mkinitcpio failed; reboot may still work, but inspect the error above."
    fi
}

cleanup_old_user_environment() {
    if [ -f "$OLD_ENV_FILE" ] && grep -q 'Created by gral/arch/python-gpu-dev.sh' "$OLD_ENV_FILE"; then
        say "Removing old shared-venv environment file: $OLD_ENV_FILE"
        rm -f "$OLD_ENV_FILE"
    fi
}

write_user_wrappers() {
    local bin_dir="$HOME/.local/bin"

    say "Writing helper wrappers into $bin_dir."
    install -d -m 755 "$bin_dir"

    cat > "$bin_dir/python-gpu" <<EOF2
#!/bin/sh
exec "$PYTHON_BIN" "\$@"
EOF2
    chmod 755 "$bin_dir/python-gpu"

    rm -f "$bin_dir/pip-gpu"

    cat > "$bin_dir/torch-test-gpu" <<EOF2
#!/bin/sh
exec "$PYTHON_BIN" - <<'PY'
import torch

print("torch_version=", torch.__version__)
print("torch_cuda_build=", torch.version.cuda)
print("torch_cuda_available=", torch.cuda.is_available())
if not torch.cuda.is_available():
    raise SystemExit("PyTorch imported, but CUDA is not available.")
print("torch_cuda_device=", torch.cuda.get_device_name(0))
print("torch_cuda_capability=", torch.cuda.get_device_capability(0))
x = torch.ones((1024, 1024), device="cuda")
print("cuda_tensor_sum=", float(x.sum().item()))
PY
EOF2
    chmod 755 "$bin_dir/torch-test-gpu"
}

nvidia_ready() {
    command -v nvidia-smi >/dev/null 2>&1 && nvidia-smi >/dev/null 2>&1
}

validate_torch() {
    say "Validating system PyTorch CUDA from $PYTHON_BIN."
    "$PYTHON_BIN" - <<'PY'
import sys
import torch

print("python=", sys.executable)
print("torch_version=", torch.__version__)
print("torch_cuda_build=", torch.version.cuda)
print("torch_cuda_available=", torch.cuda.is_available())
if not torch.cuda.is_available():
    raise SystemExit("PyTorch imported, but CUDA is not available.")
print("torch_cuda_device=", torch.cuda.get_device_name(0))
print("torch_cuda_capability=", torch.cuda.get_device_capability(0))
x = torch.ones((1024, 1024), device="cuda")
print("cuda_tensor_sum=", float(x.sum().item()))
PY
}

validate_imports() {
    say "Validating system Python imports."
    "$PYTHON_BIN" - <<'PY'
import polars
import torch
import whisper

print("polars_version=", polars.__version__)
print("torch_import_ok=", torch.__version__)
print("whisper_import_ok=", whisper.__file__)
PY
}

prefetch_whisper_model() {
    if [ "${GRAL_SKIP_WHISPER_PREFETCH:-0}" = "1" ]; then
        say "Skipping Whisper model prefetch because GRAL_SKIP_WHISPER_PREFETCH=1."
        return
    fi

    say "Pre-downloading Whisper model '$WHISPER_MODEL_TO_PREFETCH' with system Python."
    WHISPER_MODEL="$WHISPER_MODEL_TO_PREFETCH" "$PYTHON_BIN" - <<'PY'
import os
import torch
import whisper

model_name = os.environ.get("WHISPER_MODEL", "large-v3")
device = "cuda" if torch.cuda.is_available() else "cpu"
print(f"loading_model={model_name} device={device}")
whisper.load_model(model_name, device=device)
print("ready")
PY
}

main() {
    if [ "$(uname -s)" != "Linux" ]; then
        die "arch/python-gpu-dev.sh is for Arch/Linux only."
    fi
    if [ ! -r /etc/arch-release ]; then
        die "this script expects Arch Linux."
    fi
    if [ "$(id -u)" -eq 0 ]; then
        die "run as your normal user, not root; the script uses sudo for pacman/system paths."
    fi

    need_cmd pacman
    need_cmd sudo

    install_arch_packages
    refresh_kernel_images
    cleanup_old_user_environment

    if [ ! -x "$PYTHON_BIN" ]; then
        die "system Python not found or not executable: $PYTHON_BIN"
    fi

    write_user_wrappers
    validate_imports

    if nvidia_ready; then
        nvidia-smi
        validate_torch
        prefetch_whisper_model
    else
        warn "nvidia-smi is not ready yet. If the driver was just installed, reboot, log in, then rerun ./arch/python-gpu-dev.sh."
        warn "After reboot, run: torch-test-gpu"
    fi

    cat <<MSG

System GPU Python baseline is configured.

Useful commands after a fresh login:
  python-gpu -c 'import torch; print(torch.cuda.is_available())'
  torch-test-gpu
  whisper-dictation-toggle

No shared Python venv is created.
If NVIDIA packages were installed in this run, reboot once before judging CUDA.
MSG
}

main "$@"
