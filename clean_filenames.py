#!/usr/bin/env python
from pathlib import Path
''' Clean up unwanted characters from filenames and directories in a directory. WARNING: RECURSIVE!'''

def clean_name(p):
    base = p.parent
    new_name = p.name
    new_name = new_name.lower()
    new_name = new_name.replace(' ', '_')

    return base / new_name

if __name__ == '__main__':
    folder = Path().cwd()
    for p in folder.rglob("*"):
        new = clean_name(p)
        p.rename(new)
