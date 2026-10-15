"""Smoke test for the pydex Zed config. Open in Zed and walk the checklist in docs/PROGRESS.md."""

import os  # ruff should flag: unused import (F401)
import time


def add(a: int, b: int) -> int:
    return a + b


add("1", "2")  # basedpyright should flag: str is not int (runs fine anyway)

for i in range(5, 0, -1):
    print(f"running... {i}  (Ctrl+C now to test stop, or wait to test normal exit)")
    time.sleep(1)
print("done")
