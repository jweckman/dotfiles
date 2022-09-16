#!/usr/bin/python
from pathlib import Path
import sys

''' Clean up unwanted characters from filenames in a directory. WARNING: RECURSIVE!'''

def clean_name(p):
    base = p.parent
    new_name = p.name
    new_name = new_name.lower()
    new_name = new_name.replace(' ', '_')

    return base / new_name

if __name__ == '__main__':
    for line in sys.stdin:
        folder = Path(line.rstrip())
        for p in folder.rglob("*"):
            new = clean_name(p)
            p.rename(new)
