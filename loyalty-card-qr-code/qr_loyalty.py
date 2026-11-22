#!/usr/bin/env python3
"""Generate QR codes from plain loyalty membership numbers."""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

BOX_SIZE = 10
BORDER = 1
ERROR_CORRECTION = "ERROR_CORRECT_M"
FILL_COLOR = "black"
BACK_COLOR = "white"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Create a QR code for a plain loyalty membership number."
    )
    parser.add_argument(
        "--data",
        required=True,
        help="The membership number or other plain text value to encode.",
    )
    parser.add_argument(
        "--output",
        type=Path,
        help="Output PNG path. Defaults to qr_<value>.png.",
    )
    return parser.parse_args()


def sanitize_filename(value: str) -> str:
    sanitized = re.sub(r"[^A-Za-z0-9._-]+", "_", value.strip())
    return sanitized[:80] or "qr_code"


def build_qr_image(value: str):
    import qrcode

    qr = qrcode.QRCode(
        version=None,
        error_correction=getattr(qrcode.constants, ERROR_CORRECTION),
        box_size=BOX_SIZE,
        border=BORDER,
    )
    qr.add_data(value)
    qr.make(fit=True)
    return qr.make_image(fill_color=FILL_COLOR, back_color=BACK_COLOR)


def save_qr(value: str, destination: Path) -> None:
    destination.parent.mkdir(parents=True, exist_ok=True)
    image = build_qr_image(value)
    image.save(destination)


def single_output_path(value: str, output: Path | None) -> Path:
    if output is not None:
        return output
    return Path(f"qr_{sanitize_filename(value)}.png")


def main() -> int:
    args = parse_args()

    try:
        output_path = single_output_path(args.data, args.output)
        save_qr(args.data, output_path)
        print(f"Saved QR code to {output_path}")
        return 0
    except Exception as exc:
        print(f"Error: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
