#!/usr/bin/env python
import pandas as pd
from pathlib import Path
import sys

''' Concatenates all csv files in the folder passed to stdin '''

path = Path(sys.argv[1])

def get_csv_paths(path):
    return [p for p in path.iterdir() if p.suffix == '.csv']

def ask_details():
    print('Please specify the following:')
    encoding = input('Encoding\n')
    delimiter = input('Delimiter\n')

    return encoding, delimiter

def get_frames(files_list, encoding, delimiter):
    return [pd.read_csv(p, sep=delimiter, dtype='str', encoding=encoding) for p in csv_files]

def concat_output(frames):
    output = pd.DataFrame()
    for df in frames:
        output = pd.concat([output,df])
    path_out = path / 'COMBINED.csv'
    output.to_csv(path_out, sep=';', index=False)

if __name__ == '__main__':
    csv_files = get_csv_paths(path)
    encoding, delimiter = ask_details()
    try:
        frames = get_frames(csv_files, encoding, delimiter)
        concat_output(frames)
    except Exception as e:
        print('Seems like there were files that could not be read\n')
        print(str(e))
        encoding, delimiter = ask_details()
        frames = get_frames(csv_files, encoding, delimiter)
        concat_output(frames)
