#!/usr/bin/env bash

set -euo pipefail

file_path="${1:-}"
preview_width="${2:-80}"
preview_height="${3:-40}"

if [ -z "$file_path" ]; then
  exit 1
fi

if [ ! -e "$file_path" ]; then
  echo "File does not exist."
  exit 1
fi

mime_type="$(file --dereference --brief --mime-type -- "$file_path" 2>/dev/null || echo application/octet-stream)"

preview_directory() {
  if command -v eza >/dev/null 2>&1; then
    eza --all --long --group-directories-first --color=always -- "$file_path"
  else
    ls -la -- "$file_path"
  fi
}

preview_text() {
  if command -v bat >/dev/null 2>&1; then
    bat \
      --color=always \
      --style=plain \
      --paging=never \
      --terminal-width="$preview_width" \
      --line-range="1:${preview_height}" \
      -- "$file_path"
  else
    sed -n "1,${preview_height}p" -- "$file_path"
  fi
}

preview_pdf() {
  if command -v pdftotext >/dev/null 2>&1; then
    pdftotext -l 10 -nopgbrk -q -- "$file_path" - | sed -n "1,${preview_height}p"
  else
    echo "PDF preview is unavailable."
    echo
    file --brief -- "$file_path"
  fi
}

preview_archive() {
  case "$file_path" in
    *.zip)
      if command -v unzip >/dev/null 2>&1; then
        unzip -l -- "$file_path"
      else
        echo "unzip is not installed."
      fi
      ;;
    *.tar|*.tar.gz|*.tgz|*.tar.bz2|*.tbz2|*.tar.xz|*.txz)
      if command -v tar >/dev/null 2>&1; then
        tar -tf -- "$file_path"
      else
        echo "tar is not available."
      fi
      ;;
    *.7z)
      if command -v 7z >/dev/null 2>&1; then
        7z l -- "$file_path"
      else
        echo "7z is not installed."
      fi
      ;;
    *)
      echo "Archive preview is unavailable."
      ;;
  esac
}

preview_json() {
  if command -v jq >/dev/null 2>&1; then
    jq -C . -- "$file_path" | sed -n "1,${preview_height}p"
  else
    preview_text
  fi
}

if [ -d "$file_path" ]; then
  preview_directory
  exit 0
fi

case "$mime_type" in
  text/*)
    preview_text
    ;;
  application/json)
    preview_json
    ;;
  application/pdf)
    preview_pdf
    ;;
  application/zip|application/x-tar|application/gzip|application/x-7z-compressed|application/x-bzip2|application/x-xz)
    preview_archive
    ;;
  image/*)
    echo "Image preview is not configured in this script."
    echo
    file --brief -- "$file_path"
    ;;
  *)
    case "$file_path" in
      *.md|*.txt|*.py|*.rs|*.lua|*.sh|*.zsh|*.bash|*.c|*.cpp|*.h|*.hpp|*.js|*.ts|*.tsx|*.jsx|*.json|*.toml|*.yaml|*.yml|*.ini|*.conf|*.csv)
        preview_text
        ;;
      *.pdf)
        preview_pdf
        ;;
      *.zip|*.tar|*.tar.gz|*.tgz|*.tar.bz2|*.tbz2|*.tar.xz|*.txz|*.7z)
        preview_archive
        ;;
      *)
        file --brief -- "$file_path"
        ;;
    esac
    ;;
esac
