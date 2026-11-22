#!/usr/bin/env python3
"""Repair Outlook EML mojibake caused by UTF-16LE mis-decoding.

The damaged <file>.eml body is English UTF-8 text whose bytes were treated as
UTF-16LE code units, then written out as UTF-8/base64. Re-encoding the visible
mojibaked text as UTF-16LE reconstructs the original bytes.
"""

from __future__ import annotations

import argparse
from email import encoders, policy
from email.header import decode_header, make_header
from email.parser import BytesParser
from pathlib import Path
import string


PRINTABLE = set(string.printable)


def printable_ascii_ratio(text: str) -> float:
    if not text:
        return 0.0
    return sum(ch in PRINTABLE or ord(ch) >= 0x80 for ch in text) / len(text)


def ascii_letter_ratio(text: str) -> float:
    if not text:
        return 0.0
    return sum(("a" <= ch.lower() <= "z") for ch in text) / len(text)


def suspicious_wide_ratio(text: str) -> float:
    if not text:
        return 0.0
    wide = 0
    for ch in text:
        cp = ord(ch)
        if cp >= 0x3000 or cp in {0x0A0D, 0x0D0A}:
            wide += 1
    return wide / len(text)


def decode_reconstructed_bytes(raw: bytes) -> str | None:
    for encoding in ("utf-8", "windows-1252", "latin-1"):
        try:
            return raw.decode(encoding)
        except UnicodeDecodeError:
            continue
    return None


def repair_utf16le_mojibake(text: str) -> str:
    """Return repaired text when it matches this Outlook conversion failure."""
    if suspicious_wide_ratio(text) < 0.25 and "\u0a0d" not in text:
        return text

    candidate_bytes = text.encode("utf-16le", "surrogatepass")
    repaired = decode_reconstructed_bytes(candidate_bytes)
    if repaired is None:
        return text

    # Avoid rewriting genuine non-Latin text by requiring the repaired version
    # to look like normal prose and to be substantially more ASCII-letter heavy.
    if printable_ascii_ratio(repaired) < 0.90:
        return text
    if ascii_letter_ratio(repaired) <= ascii_letter_ratio(text) + 0.20:
        return text
    return repaired


def decode_header_to_text(value: str) -> str:
    try:
        return str(make_header(decode_header(value)))
    except Exception:
        return value


def repair_headers(message) -> int:
    changed = 0
    for name, value in list(message.items()):
        decoded = decode_header_to_text(str(value))
        repaired = repair_utf16le_mojibake(decoded)
        if repaired != decoded:
            message.replace_header(name, repaired)
            changed += 1
    return changed


def repair_all_headers(message) -> int:
    parts = message.walk() if message.is_multipart() else [message]
    return sum(repair_headers(part) for part in parts)


def decode_text_payload(part) -> str | None:
    payload = part.get_payload(decode=True)
    if payload is None:
        payload_text = part.get_payload()
        return payload_text if isinstance(payload_text, str) else None

    charset = part.get_content_charset() or "utf-8"
    for encoding in (charset, "utf-8", "windows-1252", "latin-1"):
        try:
            return payload.decode(encoding)
        except (LookupError, UnicodeDecodeError):
            continue
    return None


def replace_text_payload(part, text: str) -> None:
    part.set_payload(text.encode("utf-8"))
    if part.get_content_type() == "text/plain":
        part.set_type("text/plain")
    part.set_param("charset", "utf-8", header="Content-Type", replace=True)

    while part["Content-Transfer-Encoding"] is not None:
        del part["Content-Transfer-Encoding"]
    encoders.encode_base64(part)


def repair_text_parts(message) -> int:
    changed = 0
    parts = message.walk() if message.is_multipart() else [message]
    for part in parts:
        if part.is_multipart() or part.get_content_maintype() != "text":
            continue
        text = decode_text_payload(part)
        if text is None:
            continue
        repaired = repair_utf16le_mojibake(text)
        if repaired != text:
            replace_text_payload(part, repaired)
            changed += 1
    return changed


def repair_eml(input_path: Path, output_path: Path) -> tuple[int, int]:
    message = BytesParser(policy=policy.default).parsebytes(input_path.read_bytes())
    header_count = repair_all_headers(message)
    part_count = repair_text_parts(message)
    output_path.write_bytes(message.as_bytes(policy=policy.SMTP))
    return header_count, part_count


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Fix EML text corrupted by Outlook UTF-16LE mojibake."
    )
    parser.add_argument("input", nargs="?", default="email.eml", type=Path)
    parser.add_argument("output", nargs="?", default="email.fixed.eml", type=Path)
    args = parser.parse_args()

    header_count, part_count = repair_eml(args.input, args.output)
    print(
        f"Wrote {args.output} "
        f"({header_count} repaired header(s), {part_count} repaired text part(s))."
    )


if __name__ == "__main__":
    main()
