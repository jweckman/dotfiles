#!/usr/bin/env python
import os
import sys

# --- Configuration ---
CPU_SCALE = 0.50
HEAVY_PACKAGES = ["webkit", "chromium", "firefox", "rust", "llvm", "qt6-webengine"]
# ---------------------

def main():
    cwd = os.getcwd()

    # Check if a heavy package keyword is in the current build directory
    for pattern in HEAVY_PACKAGES:
        if pattern in cwd:
            total_cores = os.cpu_count() or 1
            scaled_cores = max(1, int(total_cores * CPU_SCALE))
            percent_label = f"{int(CPU_SCALE * 100)}%"

            # Print data line-by-line for Bash to easily ingest
            print(scaled_cores)
            print(percent_label)
            print(pattern)
            sys.exit(0)

if __name__ == "__main__":
    main()
