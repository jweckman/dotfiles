#!/usr/bin/env python

from pathlib import Path

def get_lengths(path):
    lengths = []
    for m in path:
        with open(m, 'r') as fp:
            lengths.append(len(fp.readlines()))
    return lengths

def get_files(base, dir, suffix):
    folder = d / dir
    if folder.is_dir():
        return [x for x in folder.iterdir() if x.suffix == '.py']

grand_models = []
grand_wizards = []
for d in Path.cwd().iterdir():
    models = get_files(d, 'models', '.py')
    wizards = get_files(d, 'wizard', '.py')
    models_total = sum(get_lengths(models)) if models else 0
    wizards_total = sum(get_lengths(wizards)) if wizards else 0
    grand_models.append(models_total)
    grand_wizards.append(wizards_total)
    print(f"{d.stem}: M:{models_total}, W:{wizards_total}")

print(f"GRAND TOTAL: M:{sum(grand_models)} W:{sum(grand_wizards)}")

