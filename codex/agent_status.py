#!/usr/bin/env python3
from __future__ import annotations

import json
import os
import shutil
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Sequence, TypeAlias

JsonValue: TypeAlias = (
    None | bool | int | float | str | list["JsonValue"] | dict[str, "JsonValue"]
)
JsonObject: TypeAlias = dict[str, JsonValue]

MAX_TRANSCRIPT_TAIL_BYTES = 262_144
STATUS_COMMANDS = frozenset(("working", "waiting", "done", "clear"))


@dataclass(frozen=True)
class ContextUsage:
    used_percentage: int | None
    used_tokens: int | None
    context_window_tokens: int | None

    @classmethod
    def unknown(cls) -> ContextUsage:
        return cls(
            used_percentage=None,
            used_tokens=None,
            context_window_tokens=None,
        )


def as_json_value(value: object) -> JsonValue:
    if value is None or isinstance(value, bool | int | float | str):
        return value
    if isinstance(value, list):
        return [as_json_value(item) for item in value]
    if isinstance(value, dict):
        output: JsonObject = {}
        for key, item in value.items():
            if isinstance(key, str):
                output[key] = as_json_value(item)
        return output
    return str(value)


def read_hook_input() -> JsonObject:
    raw = sys.stdin.read()
    if not raw.strip():
        return {}
    value = as_json_value(json.loads(raw))
    if not isinstance(value, dict):
        msg = "Codex hook input must be a JSON object"
        raise ValueError(msg)
    return value


def object_at(data: JsonObject, key: str) -> JsonObject:
    value = data.get(key)
    if isinstance(value, dict):
        return value
    return {}


def string_at(data: JsonObject, key: str) -> str | None:
    value = data.get(key)
    if isinstance(value, str):
        return value
    return None


def number_at(data: JsonObject, key: str) -> float | None:
    value = data.get(key)
    if isinstance(value, bool):
        return None
    if isinstance(value, int | float):
        return float(value)
    return None


def int_at(data: JsonObject, key: str) -> int | None:
    value = number_at(data, key)
    if value is None:
        return None
    return max(0, round(value))


def clamp_percentage(value: float | None) -> int | None:
    if value is None:
        return None
    return max(0, min(100, round(value)))


def read_tail_text(path: Path, max_bytes: int) -> str:
    size = path.stat().st_size
    offset = max(0, size - max_bytes)
    with path.open("rb") as handle:
        handle.seek(offset)
        text = handle.read().decode("utf-8", errors="replace")
    if offset == 0:
        return text
    _partial, _newline, tail = text.partition("\n")
    return tail


def complete_lines(text: str) -> list[str]:
    lines = text.splitlines()
    if text and not text.endswith("\n"):
        return lines[:-1]
    return lines


def context_usage_from_token_count(payload: JsonObject) -> ContextUsage:
    info = object_at(payload, "info")
    window_tokens = int_at(info, "model_context_window")
    last_usage = object_at(info, "last_token_usage")
    total_usage = object_at(info, "total_token_usage")
    used_tokens = int_at(last_usage, "input_tokens")
    if used_tokens is None:
        used_tokens = int_at(total_usage, "input_tokens")
    if used_tokens is None or window_tokens is None or window_tokens <= 0:
        return ContextUsage(
            used_percentage=None,
            used_tokens=used_tokens,
            context_window_tokens=window_tokens,
        )
    return ContextUsage(
        used_percentage=clamp_percentage(used_tokens * 100 / window_tokens),
        used_tokens=used_tokens,
        context_window_tokens=window_tokens,
    )


def latest_context_usage(transcript_path: Path | None) -> ContextUsage:
    if transcript_path is None or not transcript_path.is_file():
        return ContextUsage.unknown()

    text = read_tail_text(transcript_path, MAX_TRANSCRIPT_TAIL_BYTES)
    for line in reversed(complete_lines(text)):
        if not line:
            continue
        event = as_json_value(json.loads(line))
        if not isinstance(event, dict):
            continue
        payload = object_at(event, "payload")
        if string_at(payload, "type") == "token_count":
            return context_usage_from_token_count(payload)
    return ContextUsage.unknown()


def transcript_path_from_input(data: JsonObject) -> Path | None:
    value = string_at(data, "transcript_path")
    if value is None:
        return None
    return Path(value).expanduser()


def format_percentage(value: int | None) -> str:
    if value is None:
        return ""
    return f"{value}%"


def run_command(command: Sequence[str]) -> int:
    completed = subprocess.run(
        list(command),
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        check=False,
    )
    return completed.returncode


def tmux_target_args() -> list[str]:
    pane_id = os.environ.get("TMUX_PANE")
    if pane_id is None or pane_id == "":
        return []
    return ["-t", pane_id]


def set_tmux_context_percentage(usage: ContextUsage) -> None:
    if usage.used_percentage is None:
        return

    if "TMUX" not in os.environ:
        return

    tmux = shutil.which("tmux")
    if tmux is None:
        return

    target_args = tmux_target_args()
    run_command(
        [
            tmux,
            "set-window-option",
            "-q",
            *target_args,
            "@agent_context_pct",
            format_percentage(usage.used_percentage),
        ],
    )


def set_workmux_status(status: str) -> None:
    workmux = shutil.which("workmux")
    if workmux is None:
        return
    run_command([workmux, "set-window-status", status])


def status_from_args(args: Sequence[str]) -> str:
    if len(args) != 2 or args[1] not in STATUS_COMMANDS:
        msg = "Usage: agent_status.py working|waiting|done|clear"
        raise ValueError(msg)
    return args[1]


def main(args: Sequence[str]) -> int:
    status = status_from_args(args)
    hook_input = read_hook_input()
    usage = latest_context_usage(transcript_path_from_input(hook_input))
    set_tmux_context_percentage(usage)
    set_workmux_status(status)
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
