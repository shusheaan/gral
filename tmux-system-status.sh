#!/bin/sh

first_load_average() {
    if [ -r /proc/loadavg ]; then
        awk '{ print $1 }' /proc/loadavg
        return 0
    fi

    uptime | sed -nE 's/.*load averages?: ([0-9.]+).*/\1/p'
}

temperature_from_osx_cpu_temp() {
    command -v osx-cpu-temp >/dev/null 2>&1 || return 1
    osx-cpu-temp 2>/dev/null \
        | sed -nE 's/^[^0-9]*([0-9]+([.][0-9]+)?)[[:space:]]*°?[Cc].*$/\1/p' \
        | head -n 1
}

temperature_from_istats() {
    command -v istats >/dev/null 2>&1 || return 1
    istats cpu temp --value-only 2>/dev/null \
        | sed -nE 's/^([0-9]+([.][0-9]+)?).*$/\1/p' \
        | head -n 1
}

temperature_from_smc() {
    command -v smc >/dev/null 2>&1 || return 1

    for key in TC0P TC0E TC0F; do
        smc -k "$key" -r 2>/dev/null \
            | awk 'NF > 0 && $NF ~ /^[0-9]+([.][0-9]+)?$/ { print $NF; exit }'
    done | head -n 1
}

temperature_from_sensors() {
    command -v sensors >/dev/null 2>&1 || return 1
    sensors 2>/dev/null \
        | sed -nE '/(Package id 0|Tctl|CPU|Core 0)/s/.*\+([0-9]+([.][0-9]+)?)°C.*/\1/p' \
        | head -n 1
}

is_valid_temperature() {
    [ -n "$1" ] || return 1
    awk -v temp="$1" 'BEGIN { exit !(temp > 0 && temp < 130) }'
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

    return 1
}

formatted_temperature() {
    temp="$(temperature_celsius | sed -nE '/^[0-9]+([.][0-9]+)?$/p' | head -n 1)"

    if [ -z "$temp" ]; then
        printf -- '--°'
        return 0
    fi

    awk -v temp="$temp" 'BEGIN { printf "%.0f°", temp }'
}

load_average="$(first_load_average)"
if [ -z "$load_average" ]; then
    load_average="--"
fi

printf ' %s  %s ' "$load_average" "$(formatted_temperature)"
