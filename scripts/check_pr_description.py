#!/usr/bin/env python3
"""Require useful Summary and Checks sections in pull request descriptions."""

from __future__ import annotations

import os
import re


HEADINGS = re.compile(r"^##[ \t]+(.+?)[ \t]*$", re.MULTILINE)
COMMENTS = re.compile(r"<!--.*?-->", re.DOTALL)
REQUIRED = ("Summary", "Checks")


def missing_sections(body: str) -> list[str]:
    """Return sections that are absent or contain only template hints."""
    body = COMMENTS.sub("", body)
    headings = list(HEADINGS.finditer(body))
    sections = {}
    for index, heading in enumerate(headings):
        end = headings[index + 1].start() if index + 1 < len(headings) else len(body)
        sections[heading.group(1).strip().casefold()] = body[heading.end() : end]
    return [
        name
        for name in REQUIRED
        if not re.search(r"[\w]", sections.get(name.casefold(), ""))
    ]


if __name__ == "__main__":
    missing = missing_sections(os.environ.get("PR_BODY", ""))
    if missing:
        print(f"::error::Fill in the PR description's {', '.join(missing)} section(s).")
        raise SystemExit(1)
    print("PR description includes Summary and Checks.")
