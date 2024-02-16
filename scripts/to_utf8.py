import chardet
import sys

path_in = Path(sys.argv[1])
path_out = path_in.parent / (path_in.stem + '_utf8') + path_in.suffix

with open(path_in, 'r') as fp:
    chardet.detect(fp.read())
