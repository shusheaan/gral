#!/bin/sh

file_path=${1:-}
preview_width=${2:-80}
preview_height=${3:-40}
outline_max_bytes=${LF_OUTLINE_PREVIEW_MAX_BYTES:-${LF_FOLD_PREVIEW_MAX_BYTES:-262144}}

case "$preview_width" in
    ''|*[!0-9]*) preview_width=80;;
esac

case "$preview_height" in
    ''|*[!0-9]*) preview_height=40;;
esac

case "$outline_max_bytes" in
    ''|*[!0-9]*) outline_max_bytes=262144;;
esac

bat_width=$preview_width
if [ "$bat_width" -gt 5 ]; then
    bat_width=$((bat_width - 5))
fi

script_path=$0
if command -v readlink >/dev/null 2>&1; then
    link_target=$(readlink "$script_path" 2>/dev/null || true)
    if [ -n "$link_target" ]; then
        case "$link_target" in
            /*) script_path=$link_target;;
            *) script_path=$(dirname -- "$script_path")/$link_target;;
        esac
    fi
fi
script_dir=$(CDPATH= cd -- "$(dirname -- "$script_path")" 2>/dev/null && pwd)
outline_script=$script_dir/lf-code-outline.py

preview_with_bat() {
    if command -v bat >/dev/null 2>&1; then
        bat \
            --color=always \
            --paging=never \
            --style=numbers \
            --terminal-width "$bat_width" \
            --line-range "1:$preview_height" \
            -- "$file_path" || true
    else
        sed -n "1,${preview_height}p" "$file_path"
    fi
}

preview_archive() {
    case "$file_path" in
        *.tar*) tar tf "$file_path";;
        *.zip) unzip -l "$file_path";;
        *.rar) unrar l "$file_path";;
        *.7z) 7z l "$file_path";;
    esac
}

file_size_bytes() {
    wc -c < "$file_path" | tr -d '[:space:]'
}

can_outline_preview() {
    command -v python3 >/dev/null 2>&1 || return 1
    [ -r "$outline_script" ] || return 1
    [ "$(file_size_bytes)" -le "$outline_max_bytes" ] || return 1

    case "$file_path" in
        *.py|*.lua|*.rs|*.go|*.js|*.jsx|*.ts|*.tsx|*.c|*.h|*.cpp|*.hpp|*.cc|*.cxx|*.java|*.kt|*.swift|*.sh|*.bash|*.zsh|*.fish|*.vim)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

print_highlighted_outline_preview() {
    outline_file=$1
    awk '
        BEGIN {
            number_color = "\033[38;5;246m"
            keyword_color = "\033[38;5;203m"
            type_color = "\033[38;5;81m"
            name_color = "\033[38;5;149m"
            reset = "\033[0m"
        }

        FNR == NR {
            tab_index = index($0, "\t")
            if (tab_index == 0) {
                line_number = ""
                code = $0
            } else {
                line_number = substr($0, 1, tab_index - 1)
                code = substr($0, tab_index + 1)
            }

            match(code, /^ */)
            indent = substr(code, 1, RLENGTH)
            rest = substr(code, RLENGTH + 1)
            space_index = index(rest, " ")

            if (space_index == 0) {
                keyword = rest
                name = ""
            } else {
                keyword = substr(rest, 1, space_index - 1)
                name = substr(rest, space_index + 1)
            }

            if (keyword ~ /^(class|struct|enum|trait|interface|type|impl)$/) {
                first_color = type_color
            } else {
                first_color = keyword_color
            }

            printf "%s%4s%s %s%s%s%s", number_color, line_number, reset, indent, first_color, keyword, reset
            if (name != "") {
                printf " %s%s%s", name_color, name, reset
            }
            printf "\n"
        }
    ' "$outline_file"

    printf '\n'
}

preview_with_code_outline() {
    output_file=$(mktemp "${TMPDIR:-/tmp}/lf-outline-preview.XXXXXX") || return 1
    trap 'rm -f "$output_file"' EXIT HUP INT TERM

    if python3 -S "$outline_script" "$file_path" "$preview_height" > "$output_file" 2>/dev/null &&
        [ -s "$output_file" ]; then
        print_highlighted_outline_preview "$output_file"
        return 0
    fi

    return 1
}

if [ -z "$file_path" ] || [ ! -e "$file_path" ]; then
    exit 1
fi

if [ -d "$file_path" ]; then
    if command -v eza >/dev/null 2>&1; then
        eza -la --group-directories-first --icons=auto --color=always -- "$file_path"
    else
        ls -la "$file_path"
    fi
    exit 0
fi

case "$file_path" in
    *.tar*|*.zip|*.rar|*.7z)
        preview_archive
        ;;
    *.pdf)
        pdftotext "$file_path" - | sed -n "1,${preview_height}p"
        ;;
    *)
        if can_outline_preview && preview_with_code_outline; then
            exit 0
        fi
        preview_with_bat
        ;;
esac
