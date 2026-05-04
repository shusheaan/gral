#!/bin/sh

command_path() {
    if command -v "$1" >/dev/null 2>&1; then
        command -v "$1"
        return 0
    fi

    for dir in /opt/homebrew/bin /usr/local/bin; do
        if [ -x "$dir/$1" ]; then
            printf '%s\n' "$dir/$1"
            return 0
        fi
    done

    return 1
}

temperature_from_osx_cpu_temp() {
    cmd="$(command_path osx-cpu-temp)" || return 1
    "$cmd" 2>/dev/null \
        | sed -nE 's/^[^0-9]*([0-9]+([.][0-9]+)?)[[:space:]]*°?[Cc].*$/\1/p' \
        | head -n 1
}

temperature_from_istats() {
    cmd="$(command_path istats)" || return 1
    "$cmd" cpu temp --value-only 2>/dev/null \
        | sed -nE 's/^([0-9]+([.][0-9]+)?).*$/\1/p' \
        | head -n 1
}

temperature_from_smc() {
    cmd="$(command_path smc)" || return 1

    for key in TC0P TC0E TC0F; do
        "$cmd" -k "$key" -r 2>/dev/null \
            | awk 'NF > 0 && $NF ~ /^[0-9]+([.][0-9]+)?$/ { print $NF; exit }'
    done | head -n 1
}

temperature_from_sensors() {
    cmd="$(command_path sensors)" || return 1
    "$cmd" 2>/dev/null \
        | sed -nE '/(Package id 0|Tctl|CPU|Core 0)/s/.*\+([0-9]+([.][0-9]+)?)°C.*/\1/p' \
        | head -n 1
}

temperature_from_macmon() {
    cmd="$(command_path macmon)" || return 1
    "$cmd" pipe --samples 1 -i 100 2>/dev/null \
        | sed -nE 's/.*"cpu_temp_avg":([0-9]+([.][0-9]+)?).*/\1/p' \
        | head -n 1
}

is_valid_temperature() {
    [ -n "$1" ] || return 1
    awk -v temp="$1" 'BEGIN { exit !(temp > 0 && temp < 130) }'
}

status_tmp_dir() {
    if [ -n "$TMPDIR" ]; then
        printf '%s\n' "${TMPDIR%/}"
        return 0
    fi

    printf '/tmp\n'
}

user_id() {
    id -u 2>/dev/null || printf 'unknown\n'
}

temperature_cache_path() {
    printf '%s/gral-tmux-cpu-temp-%s\n' "$(status_tmp_dir)" "$(user_id)"
}

temperature_lock_path() {
    printf '%s.lock\n' "$(temperature_cache_path)"
}

file_mtime_seconds() {
    stat -f %m "$1" 2>/dev/null || stat -c %Y "$1" 2>/dev/null
}

is_fresh_file() {
    file="$1"
    max_age="$2"

    [ -e "$file" ] || return 1

    now="$(date +%s 2>/dev/null)"
    mtime="$(file_mtime_seconds "$file")"
    [ -n "$now" ] && [ -n "$mtime" ] || return 1

    age=$((now - mtime))
    [ "$age" -ge 0 ] && [ "$age" -le "$max_age" ]
}

temperature_from_cache() {
    max_age="$1"
    cache_file="$(temperature_cache_path)"

    is_fresh_file "$cache_file" "$max_age" || return 1

    temp="$(sed -nE '/^[0-9]+([.][0-9]+)?$/p' "$cache_file" 2>/dev/null | head -n 1)"
    if is_valid_temperature "$temp"; then
        printf '%s\n' "$temp"
        return 0
    fi

    return 1
}

start_macmon_temperature_refresh() {
    command_path macmon >/dev/null 2>&1 || return 0

    cache_file="$(temperature_cache_path)"
    lock_dir="$(temperature_lock_path)"

    if [ -d "$lock_dir" ]; then
        if is_fresh_file "$lock_dir" 10; then
            return 0
        fi

        rmdir "$lock_dir" 2>/dev/null || return 0
    fi

    mkdir "$lock_dir" 2>/dev/null || return 0

    (
        temp="$(temperature_from_macmon)"
        if is_valid_temperature "$temp"; then
            umask 077
            printf '%s\n' "$temp" > "$cache_file"
        fi

        rmdir "$lock_dir" 2>/dev/null
    ) >/dev/null 2>&1 &
}

temperature_from_macmon_cache() {
    temp="$(temperature_from_cache 30)"
    if is_valid_temperature "$temp"; then
        printf '%s\n' "$temp"
        return 0
    fi

    start_macmon_temperature_refresh

    temp="$(temperature_from_cache 300)"
    if is_valid_temperature "$temp"; then
        printf '%s\n' "$temp"
        return 0
    fi

    return 1
}

temperature_celsius() {
    temp="$(temperature_from_osx_cpu_temp)"
    if is_valid_temperature "$temp"; then
        printf '%s\n' "$temp"
        return 0
    fi

    temp="$(temperature_from_istats)"
    if is_valid_temperature "$temp"; then
        printf '%s\n' "$temp"
        return 0
    fi

    temp="$(temperature_from_smc)"
    if is_valid_temperature "$temp"; then
        printf '%s\n' "$temp"
        return 0
    fi

    temp="$(temperature_from_sensors)"
    if is_valid_temperature "$temp"; then
        printf '%s\n' "$temp"
        return 0
    fi

    temp="$(temperature_from_macmon_cache)"
    if is_valid_temperature "$temp"; then
        printf '%s\n' "$temp"
        return 0
    fi

    return 1
}

cpu_usage_from_top() {
    command -v top >/dev/null 2>&1 || return 1

    case "$(uname -s 2>/dev/null)" in
        Darwin)
            top -l 1 -n 0 2>/dev/null
            ;;
        Linux)
            top -bn1 2>/dev/null
            ;;
        *)
            return 1
            ;;
    esac \
        | awk '
            /CPU usage:/ || /^%Cpu\(s\):/ {
                for (i = 1; i <= NF; i++) {
                    label = $i
                    gsub(/,/, "", label)
                    if (label == "idle" || label == "id") {
                        idle = $(i - 1)
                        gsub(/[^0-9.]/, "", idle)
                    }
                }

                if (idle != "") {
                    print 100 - idle
                    exit
                }
            }
        '
}

cpu_count() {
    cores="$(getconf _NPROCESSORS_ONLN 2>/dev/null)"
    if [ -n "$cores" ]; then
        printf '%s\n' "$cores"
        return 0
    fi

    command -v sysctl >/dev/null 2>&1 || return 1
    sysctl -n hw.ncpu 2>/dev/null
}

cpu_usage_from_ps() {
    command -v ps >/dev/null 2>&1 || return 1

    cores="$(cpu_count)"
    [ -n "$cores" ] || return 1

    ps -A -o %cpu= 2>/dev/null \
        | awk -v cores="$cores" '
            $1 ~ /^[0-9]+([.][0-9]+)?$/ {
                sum += $1
                seen = 1
            }

            END {
                if (seen && cores > 0) {
                    print sum / cores
                } else {
                    exit 1
                }
            }
        '
}

is_valid_cpu_usage() {
    [ -n "$1" ] || return 1
    awk -v cpu="$1" 'BEGIN { exit !(cpu >= 0 && cpu <= 1000) }'
}

cpu_usage_percent() {
    cpu="$(cpu_usage_from_top)"
    if is_valid_cpu_usage "$cpu"; then
        printf '%s\n' "$cpu"
        return 0
    fi

    cpu="$(cpu_usage_from_ps)"
    if is_valid_cpu_usage "$cpu"; then
        printf '%s\n' "$cpu"
        return 0
    fi

    return 1
}

formatted_cpu_usage() {
    cpu="$(cpu_usage_percent | sed -nE '/^[0-9]+([.][0-9]+)?$/p' | head -n 1)"

    if [ -z "$cpu" ]; then
        printf -- '--%%'
        return 0
    fi

    awk -v cpu="$cpu" '
        BEGIN {
            if (cpu < 0) {
                cpu = 0
            }
            if (cpu > 100) {
                cpu = 100
            }

            printf "%02.0f%%", cpu
        }
    '
}

formatted_temperature() {
    temp="$(temperature_celsius | sed -nE '/^[0-9]+([.][0-9]+)?$/p' | head -n 1)"

    if [ -z "$temp" ]; then
        printf -- '--°'
        return 0
    fi

    awk -v temp="$temp" 'BEGIN { printf "%.0f°", temp }'
}

battery_from_pmset() {
    command -v pmset >/dev/null 2>&1 || return 1
    pmset -g batt 2>/dev/null | grep -E 'InternalBattery' | head -n 1
}

formatted_battery() {
    line="$(battery_from_pmset)"

    if [ -z "$line" ]; then
        printf -- '--%%'
        return 0
    fi

    pct="$(printf '%s\n' "$line" | sed -nE 's/.*[[:space:]]([0-9]+)%;.*/\1/p')"
    state="$(printf '%s\n' "$line" | sed -nE 's/.*%;[[:space:]]*([^;]+);.*/\1/p')"

    if [ -z "$pct" ]; then
        printf -- '--%%'
        return 0
    fi

    case "$state" in
        *charging*)
            printf '%02d%%+' "$pct"
            ;;
        *)
            printf '%02d%%' "$pct"
            ;;
    esac
}

printf ' %s  %s  %s ' "$(formatted_cpu_usage)" "$(formatted_temperature)" "$(formatted_battery)"
