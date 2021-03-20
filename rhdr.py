import sys

''' Generates headers for a csv file to a .headers file for the specified file. Made for Rainbow CSV plugin that is available for most IDEs'''

f = sys.argv[1]

with open(f, 'r', encoding='utf-8') as fp:
    first_line = fp.readline()

headers = first_line.split(';')

with open(f + '.header', 'w', encoding='utf-8') as fp:
    fp.write('\n')
    for h in headers[:-1]:
        fp.write(h + '\n')
    fp.write(headers[-1])
