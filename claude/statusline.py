#!/usr/bin/env python3
from __future__ import annotations

import json
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import TypeAlias

JsonValue: TypeAlias = (
    None | bool | int | float | str | list["JsonValue"] | dict[str, "JsonValue"]
)
JsonObject: TypeAlias = dict[str, JsonValue]


@dataclass(frozen=True)
class ContextStatus:
    model: str
    directory: str
    used_percentage: int | None
    remaining_tokens: int | None
    cost_usd: float | None


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


def read_input() -> JsonObject:
    raw = sys.stdin.read()
    value = as_json_value(json.loads(raw))
    if not isinstance(value, dict):
        msg = "Claude Code status input must be a JSON object"
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


def clamp_percentage(value: float | None) -> int | None:
    if value is None:
        return None
    return max(0, min(100, round(value)))


def current_context_tokens(context_window: JsonObject) -> int | None:
    usage = object_at(context_window, "current_usage")
    if not usage:
        return None
    token_fields = (
        "input_tokens",
        "cache_creation_input_tokens",
        "cache_read_input_tokens",
    )
    return round(sum(number_at(usage, field) or 0 for field in token_fields))


def context_window_size(context_window: JsonObject) -> int | None:
    size = number_at(context_window, "context_window_size")
    if size is None or size <= 0:
        return None
    return round(size)


def remaining_tokens(context_window: JsonObject) -> int | None:
    size = context_window_size(context_window)
    if size is None:
        return None

    used_tokens = current_context_tokens(context_window)
    if used_tokens is not None:
        return max(0, size - used_tokens)

    remaining_pct = number_at(context_window, "remaining_percentage")
    if remaining_pct is None:
        return None
    return max(0, round(size * remaining_pct / 100))


def build_status(data: JsonObject) -> ContextStatus:
    model = string_at(object_at(data, "model"), "display_name") or "Claude"
    current_dir = string_at(object_at(data, "workspace"), "current_dir") or ""
    directory = Path(current_dir).name if current_dir else "-"
    context_window = object_at(data, "context_window")
    used_percentage = clamp_percentage(number_at(context_window, "used_percentage"))
    cost_usd = number_at(object_at(data, "cost"), "total_cost_usd")
    return ContextStatus(
        model=model,
        directory=directory,
        used_percentage=used_percentage,
        remaining_tokens=remaining_tokens(context_window),
        cost_usd=cost_usd,
    )


def format_tokens(tokens: int | None) -> str:
    if tokens is None:
        return "--"
    if tokens >= 1_000_000:
        return f"{tokens / 1_000_000:.1f}M"
    if tokens >= 1_000:
        return f"{tokens / 1_000:.0f}k"
    return str(tokens)


def progress_bar(percentage: int | None, width: int = 10) -> str:
    if percentage is None:
        return "░" * width
    filled = max(0, min(width, round(percentage * width / 100)))
    return "▓" * filled + "░" * (width - filled)


def render(status: ContextStatus) -> str:
    pct = "--" if status.used_percentage is None else f"{status.used_percentage}%"
    left = format_tokens(status.remaining_tokens)
    cost = "" if status.cost_usd is None else f" | ${status.cost_usd:.2f}"
    return (
        f"[{status.model}] {status.directory} | "
        f"ctx {progress_bar(status.used_percentage)} {pct} ({left} left){cost}"
    )


def main() -> int:
    print(render(build_status(read_input())))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
