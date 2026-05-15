#!/usr/bin/env bash
set -u
IFS=$'\n\t'

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
TOOL_FILE="$SCRIPT_DIR/check-tools.txt"
REPORT_ROOT="${GRAL_CHECK_REPORT_ROOT:-$HOME/hardware-checks}"
STAMP="$(date +%Y%m%d-%H%M%S)"
HOST="$(hostname 2>/dev/null || printf 'unknown')"
REPORT_DIR="$REPORT_ROOT/${STAMP}-${HOST}"
SUMMARY="$REPORT_DIR/summary.md"
FAILURES="$REPORT_DIR/failures.txt"
SENSOR_PID=""

MODE="full"
INSTALL_TOOLS=0
INSTALL_TOOLS_ONLY=0
RUN_SMART_SHORT=0
CPU_MINUTES="${GRAL_CHECK_CPU_MINUTES:-20}"
GPU_MINUTES="${GRAL_CHECK_GPU_MINUTES:-10}"
FIO_MINUTES="${GRAL_CHECK_FIO_MINUTES:-5}"
FIO_SIZE="${GRAL_CHECK_FIO_SIZE:-4G}"
MEMTESTER_MB="${GRAL_CHECK_MEMTESTER_MB:-auto}"
SMART_WAIT_SECONDS="${GRAL_CHECK_SMART_WAIT_SECONDS:-180}"

usage() {
    cat <<USAGE
Usage: $0 [--install-tools|--install-tools-only] [--full|--quick|--collect-only] [--smart-short] [--memtester-mb MB]

Post-install Arch hardware validation helper for gral.

Options:
  --install-tools     Install temporary packages from arch/check-tools.txt with pacman.
  --install-tools-only
                      Install temporary packages, then exit without collecting/running tests.
  --full              Full local test: inventory + SMART + CPU/RAM + fio + GPU. Default.
  --quick             Short smoke test: 5m CPU/RAM, 2m fio, 3m GPU, skip memtester.
  --collect-only      Only collect inventory/logs; do not stress hardware.
  --smart-short       Start SMART short self-tests, wait, then collect self-test logs.
  --memtester-mb MB   Run memtester with explicit MB. Use 0 to skip.
  -h, --help          Show this help.

Environment overrides:
  GRAL_CHECK_CPU_MINUTES=20
  GRAL_CHECK_GPU_MINUTES=10
  GRAL_CHECK_FIO_MINUTES=5
  GRAL_CHECK_FIO_SIZE=4G
  GRAL_CHECK_MEMTESTER_MB=auto|0|8192
  GRAL_CHECK_SMART_WAIT_SECONDS=180
  GRAL_CHECK_REPORT_ROOT=~/hardware-checks
USAGE
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        --install-tools)
            INSTALL_TOOLS=1
            ;;
        --install-tools-only)
            INSTALL_TOOLS=1
            INSTALL_TOOLS_ONLY=1
            ;;
        --full)
            MODE="full"
            ;;
        --quick)
            MODE="quick"
            CPU_MINUTES="5"
            GPU_MINUTES="3"
            FIO_MINUTES="2"
            MEMTESTER_MB="0"
            ;;
        --collect-only)
            MODE="collect-only"
            ;;
        --smart-short)
            RUN_SMART_SHORT=1
            ;;
        --memtester-mb)
            if [ "$#" -lt 2 ]; then
                echo "--memtester-mb requires a number" >&2
                exit 2
            fi
            MEMTESTER_MB="$2"
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            usage >&2
            exit 2
            ;;
    esac
    shift
done

mkdir -p "$REPORT_DIR"
: > "$SUMMARY"
: > "$FAILURES"

log() {
    printf '%s\n' "$*" | tee -a "$SUMMARY"
}

has_command() {
    command -v "$1" >/dev/null 2>&1
}

shell_quote() {
    printf '%q ' "$@"
}

record_failure() {
    printf '%s\n' "$*" >> "$FAILURES"
}

run_capture() {
    local name="$1"
    shift
    local path="$REPORT_DIR/${name//\//_}.log"

    log "- $name"
    {
        printf '$ '
        shell_quote "$@"
        printf '\n\n'
    } > "$path"

    "$@" >> "$path" 2>&1
    local status=$?
    printf '\n[exit=%s]\n' "$status" >> "$path"
    if [ "$status" -ne 0 ]; then
        record_failure "$name exit=$status command=$(shell_quote "$@")"
    fi
}

run_shell() {
    local name="$1"
    local command="$2"
    local path="$REPORT_DIR/${name//\//_}.log"

    log "- $name"
    {
        printf '$ %s\n\n' "$command"
    } > "$path"

    bash -lc "$command" >> "$path" 2>&1
    local status=$?
    printf '\n[exit=%s]\n' "$status" >> "$path"
    if [ "$status" -ne 0 ]; then
        record_failure "$name exit=$status command=$command"
    fi
}

install_tools() {
    if [ ! -r "$TOOL_FILE" ]; then
        log "ERROR: tool list not found: $TOOL_FILE"
        exit 1
    fi
    if ! has_command pacman; then
        log "ERROR: pacman not found; this helper is for Arch Linux."
        exit 1
    fi

    local -a packages
    mapfile -t packages < <(awk 'NF && $1 !~ /^#/ { print $1 }' "$TOOL_FILE")
    if [ "${#packages[@]}" -eq 0 ]; then
        log "ERROR: no packages found in $TOOL_FILE"
        exit 1
    fi

    log "Installing temporary hardware-check tools from arch/check-tools.txt"
    sudo pacman -Syu --needed "${packages[@]}"
}

available_memtester_mb() {
    awk '
        /^MemAvailable:/ {
            mb = int(($2 / 1024) * 0.50)
            if (mb < 512) { mb = 512 }
            print mb
            found = 1
        }
        END {
            if (!found) { print 1024 }
        }
    ' /proc/meminfo
}

block_devices() {
    local dev
    for dev in /dev/nvme[0-9]n[0-9] /dev/sd? /dev/vd?; do
        if [ -b "$dev" ]; then
            printf '%s\n' "$dev"
        fi
    done
}

nvme_controllers() {
    local dev
    for dev in /dev/nvme[0-9]; do
        if [ -e "$dev" ]; then
            printf '%s\n' "$dev"
        fi
    done
}

start_sensor_monitor() {
    if ! has_command sensors; then
        log "- sensors-monitor skipped: sensors command not found"
        return
    fi

    (
        while true; do
            date --iso-8601=seconds
            sensors
            printf '\n'
            sleep 5
        done
    ) > "$REPORT_DIR/sensors-monitor.log" 2>&1 &
    SENSOR_PID="$!"
    log "- sensors-monitor started: $REPORT_DIR/sensors-monitor.log"
}

stop_sensor_monitor() {
    if [ -n "${SENSOR_PID:-}" ]; then
        kill "$SENSOR_PID" 2>/dev/null || true
        wait "$SENSOR_PID" 2>/dev/null || true
        SENSOR_PID=""
        log "- sensors-monitor stopped"
    fi
}

cleanup() {
    stop_sensor_monitor
}
trap cleanup EXIT INT TERM

collect_inventory() {
    log "## Inventory"
    run_capture "system/uname" uname -a
    run_capture "system/os-release" cat /etc/os-release
    run_capture "system/lscpu" lscpu
    run_capture "system/free" free -h
    run_capture "system/lsblk" lsblk -o NAME,MODEL,SERIAL,SIZE,TYPE,TRAN,ROTA,MOUNTPOINTS
    run_capture "system/lspci" lspci -nnk
    run_capture "system/lsusb" lsusb
    run_capture "system/ip-brief" ip -brief addr

    if has_command dmidecode; then
        run_capture "system/dmidecode-system" sudo dmidecode -t system -t baseboard -t bios -t memory
    else
        log "- system/dmidecode-system skipped: dmidecode not found"
        record_failure "missing command: dmidecode"
    fi

    if has_command sensors; then
        run_capture "system/sensors" sensors
    else
        log "- system/sensors skipped: sensors not found"
        record_failure "missing command: sensors"
    fi

    if has_command wpctl; then
        run_capture "system/wpctl-status" wpctl status
    fi
    if has_command brightnessctl; then
        run_capture "system/brightnessctl" brightnessctl info
    fi
    if has_command swaymsg; then
        run_capture "system/sway-outputs" swaymsg -t get_outputs
    fi
    if has_command wlr-randr; then
        run_capture "system/wlr-randr" wlr-randr
    fi
}

collect_kernel_logs() {
    local phase="$1"
    log "## Kernel logs: $phase"
    run_shell "kernel/dmesg-warn-$phase" "sudo dmesg -T --level=err,warn"
    run_shell "kernel/journal-warn-$phase" "sudo journalctl -b -p warning..alert --no-pager"
    run_shell "kernel/red-flags-$phase" "if sudo journalctl -k -b --no-pager | grep -Ei 'mce|machine check|hardware error|edac|aer|pcie|nvme|i/o error|thermal|thrott|amdgpu|i915|nvrm|xid|gpu hang|reset|timeout'; then :; else echo '[no matching kernel red flags]'; fi"
}

collect_storage_health() {
    log "## Storage health"

    if has_command nvme; then
        local ctrl
        while IFS= read -r ctrl; do
            run_capture "storage/nvme-smart-${ctrl##*/}" sudo nvme smart-log -H "$ctrl"
            run_capture "storage/nvme-error-log-${ctrl##*/}" sudo nvme error-log "$ctrl"
        done < <(nvme_controllers)
    else
        log "- storage/nvme skipped: nvme command not found"
        record_failure "missing command: nvme"
    fi

    if has_command smartctl; then
        local dev
        while IFS= read -r dev; do
            run_capture "storage/smartctl-x-${dev##*/}" sudo smartctl -x "$dev"
        done < <(block_devices)
    else
        log "- storage/smartctl skipped: smartctl command not found"
        record_failure "missing command: smartctl"
    fi
}

run_smart_short_tests() {
    if [ "$RUN_SMART_SHORT" -ne 1 ]; then
        return
    fi
    if ! has_command smartctl; then
        log "- SMART short self-tests skipped: smartctl not found"
        record_failure "missing command: smartctl"
        return
    fi

    log "## SMART short self-tests"
    local dev
    while IFS= read -r dev; do
        run_capture "storage/smart-short-start-${dev##*/}" sudo smartctl -t short "$dev"
    done < <(block_devices)

    log "- waiting ${SMART_WAIT_SECONDS}s for SMART short self-tests"
    sleep "$SMART_WAIT_SECONDS"

    while IFS= read -r dev; do
        run_capture "storage/smart-short-result-${dev##*/}" sudo smartctl -H -l selftest -l error "$dev"
    done < <(block_devices)
}

run_cpu_ram_stress() {
    log "## CPU / RAM stress"

    if has_command stress-ng; then
        start_sensor_monitor
        run_capture "stress/stress-ng-cpu-vm" stress-ng --cpu 0 --vm 1 --vm-bytes 70% --timeout "${CPU_MINUTES}m" --metrics-brief --verify --tz
        stop_sensor_monitor
    else
        log "- stress/stress-ng-cpu-vm skipped: stress-ng not found"
        record_failure "missing command: stress-ng"
    fi

    local mem_mb="$MEMTESTER_MB"
    if [ "$mem_mb" = "auto" ]; then
        mem_mb="$(available_memtester_mb)"
    fi
    if [ "$mem_mb" != "0" ]; then
        if has_command memtester; then
            run_capture "stress/memtester-${mem_mb}M" sudo memtester "${mem_mb}M" 1
        else
            log "- stress/memtester skipped: memtester not found"
            record_failure "missing command: memtester"
        fi
    else
        log "- stress/memtester skipped by configuration"
    fi
}

run_storage_stress() {
    log "## Storage filesystem stress"

    if ! has_command fio; then
        log "- storage/fio skipped: fio not found"
        record_failure "missing command: fio"
        return
    fi

    local fio_dir="$REPORT_DIR/fio-work"
    mkdir -p "$fio_dir"
    run_capture "storage/fio-randrw" fio \
        --name=gral-hardware-check \
        --filename="$fio_dir/fio-test.bin" \
        --size="$FIO_SIZE" \
        --rw=randrw \
        --rwmixread=70 \
        --bs=4k \
        --iodepth=16 \
        --runtime="${FIO_MINUTES}m" \
        --time_based \
        --verify=crc32c \
        --verify_fatal=1 \
        --group_reporting \
        --unlink=1
}

run_gpu_checks() {
    log "## GPU / graphics checks"

    if has_command glxinfo; then
        run_capture "gpu/glxinfo-B" glxinfo -B
    else
        log "- gpu/glxinfo-B skipped: glxinfo not found"
        record_failure "missing command: glxinfo"
    fi

    if has_command vulkaninfo; then
        run_capture "gpu/vulkaninfo-summary" vulkaninfo --summary
    else
        log "- gpu/vulkaninfo-summary skipped: vulkaninfo not found"
        record_failure "missing command: vulkaninfo"
    fi

    if [ -n "${WAYLAND_DISPLAY:-}" ] && has_command glmark2-wayland; then
        run_shell "gpu/glmark2-wayland" "timeout ${GPU_MINUTES}m glmark2-wayland --run-forever; status=\$?; if [ \"\$status\" -eq 124 ]; then echo '[expected timeout after ${GPU_MINUTES}m]'; exit 0; fi; exit \"\$status\""
    elif has_command glmark2; then
        run_shell "gpu/glmark2" "timeout ${GPU_MINUTES}m glmark2 --run-forever; status=\$?; if [ \"\$status\" -eq 124 ]; then echo '[expected timeout after ${GPU_MINUTES}m]'; exit 0; fi; exit \"\$status\""
    else
        log "- gpu/glmark2 skipped: glmark2 not found"
        record_failure "missing command: glmark2"
    fi
}

write_red_flag_summary() {
    local output="$REPORT_DIR/red-flags-summary.log"
    {
        echo "# Red-flag grep summary"
        echo
        echo "This is intentionally broad. Confirm every hit manually against the log context."
        echo
        grep -RInE 'MCE|Machine Check|Hardware Error|EDAC|I/O error|critical_warning[[:space:]:]+[1-9]|media_errors[[:space:]:]+[1-9]|num_err_log_entries[[:space:]:]+[1-9]|FAILED|failed|failure|GPU HANG|NVRM|Xid|thermal shutdown|verify.*fail|error count.*[1-9]' "$REPORT_DIR" 2>/dev/null || echo '[no broad red-flag matches]'
    } > "$output"
    log "- red flag summary: $output"
}

write_final_summary() {
    log "## Result files"
    log "- report dir: $REPORT_DIR"
    log "- summary: $SUMMARY"
    log "- failures: $FAILURES"
    log "- red flags: $REPORT_DIR/red-flags-summary.log"

    if [ -s "$FAILURES" ]; then
        log ""
        log "## Commands with non-zero exit status"
        sed 's/^/- /' "$FAILURES" | tee -a "$SUMMARY"
    else
        log ""
        log "## Commands with non-zero exit status"
        log "- none"
    fi
}

if [ "$INSTALL_TOOLS" -eq 1 ]; then
    install_tools
    if [ "$INSTALL_TOOLS_ONLY" -eq 1 ]; then
        log "Temporary hardware-check tools installed."
        exit 0
    fi
fi

log "# gral Arch hardware check"
log "- started: $(date --iso-8601=seconds)"
log "- mode: $MODE"
log "- report: $REPORT_DIR"
log "- CPU stress minutes: $CPU_MINUTES"
log "- GPU stress minutes: $GPU_MINUTES"
log "- fio minutes: $FIO_MINUTES"
log "- fio size: $FIO_SIZE"
log "- memtester MB: $MEMTESTER_MB"
log ""

collect_inventory
collect_kernel_logs "before"
collect_storage_health
run_smart_short_tests

if [ "$MODE" != "collect-only" ]; then
    run_cpu_ram_stress
    run_storage_stress
    run_gpu_checks
else
    log "## Stress tests skipped: collect-only mode"
fi

collect_kernel_logs "after"
collect_storage_health
write_red_flag_summary
write_final_summary

log ""
log "Done. Read arch/check.md for pass/fail rules and manual checks."
