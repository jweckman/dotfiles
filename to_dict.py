#!/usr/bin/env python
from sys import argv,stdin
from statistics import median, mean
from typing import Any
"""
    Vim tool for transforming key value pair text to python dictionary / json format.
    Does not work on nested structures. Takes in stdin and prints out a pretty printed python dictionary.
    Supports the delimiters defined in the detect_input_delimiters function.

    Usage
    Select the key value pair text in vim either with visual or the entire file and feed it to this script. The script will then return the string formatted as a dictionary string.

    Sample input:
    key1,value1
    key2,value2
    key3,value3
"""

def is_float(element: Any) -> bool:
    '''Integers are not OK'''
    try:
        if isinstance(element, str):
            if '.' not in element:
                return False
        float(element)
        return True
    except ValueError:
        return False

def is_int(element: Any) -> bool:
    '''Floats are not ok'''
    try:
        if isinstance(element, str):
            if '.' in element:
                return False
        int(element)
        return True
    except ValueError:
        return False

def replace_last(source_string, replace_what, replace_with):
    head, _sep, tail = source_string.rpartition(replace_what)
    return head + replace_with + tail

def input_to_list(ip):
    if isinstance(ip, str):
        lines = ip.split('\n')
    else:
        lines = ip
    return lines

def detect_input_delimiter(lines):
    delimiters = {' ': 0, '\t': 0, ',': 0, ';': 0} 
    line_lengths = []
    avposdist = {' ': [], '\t': [], ',': [], ';': []}
    for l in lines:
        line_lengths.append(len(l))
        positions = {' ': [], '\t': [], ',': [], ';': []}
        for i,c in enumerate(l):
            if c in delimiters.keys():
                positions[c].append(i)
                delimiters[c] += 1
        for delim, ps in positions.items():
            if len(ps) != 0:
                avposdist[delim].append(mean(ps))
            else:
                avposdist[delim] = []

    m_line_length = median(line_lengths)
    for k,v in avposdist.items():
        if len(avposdist[k]) != 0:
            avposdist[k] = mean(avposdist[k]) - (m_line_length / 2) 
        else:
            avposdist[k] = 1000000
    avcount = dict()
    for d, count in delimiters.items():
        avcount[d] = count / len(lines)

    # Criteria for selecting delimiter is that count per line should be closest to 1
    # Option to use delimiter closest to middle of line implemented, but currently not used as count closest to 1 probably is sufficient for 99% of the cases.
    delim_closest_to_middle = min(avposdist, key=avposdist.get)
    delim_closest_to_one = min(avcount.items(), key=lambda x: abs(1 - x[1]))[0]

    return delim_closest_to_one, delim_closest_to_middle

def input_to_dict(lines, delimiter, debug=False):
    d = dict() 
    for i,l in enumerate(lines):
        try:
            key, value = l.split(delimiter)
        except Exception as e:
            if debug:
                print(f"Line {l} failed to parse due to {e}. Ignored")
        d[key] = value

    return d

def all_types_are_same(values, type_lengths, length):
    type_lengths[0] = len([x for x in values if is_int(x)]) == length
    type_lengths[1] = len([x for x in values if is_float(x)]) == length
    return type_lengths

def first_true_index(l, type_hierarchy):
    '''Returns first True index if available, otherwise
    returns index of fallback type which is the last
    one in the hierarchy'''
    for i, x in enumerate(l):
        if x:
            return i
    return len(type_hierarchy) - 1

def get_dict_types(d):
    ''' 
    Check values for various types and
    and use the lowest level type cast possible.

    Note that mixing integer and floating point notation will
    result in casting to a string.
    '''
    type_hierarchy = (int, float, str)
    length = len(d)
    # Represents if all elements match a type
    # Order: Integer, Float
    k_types = [False, False]
    v_types = [False, False]
    k_types = all_types_are_same(d.keys(), k_types, length)
    v_types = all_types_are_same(d.values(), v_types, length)
    k_type = type_hierarchy[first_true_index(k_types, type_hierarchy)]
    v_type = type_hierarchy[first_true_index(v_types, type_hierarchy)]
    return k_type, v_type

def prettify_dict(d, k_type, v_type, indent=4, last_line_comma=True):
    res = '{'
    for k,v in d.items():
        k_form = f'"{k}"' if k_type == str else k
        v_form = f'"{v}"' if v_type == str else v
        res = f"{res}\n{indent*' '}{k_form}: {v_form},"
    if not last_line_comma:
        res = replace_last(res, ',', '')
    res = res + '\n}'
    return res

if __name__ == '__main__':
    ip = stdin.read() 
    lines = input_to_list(ip)
    dcto, dctm = detect_input_delimiter(lines)
    d = input_to_dict(lines, dcto)
    k_type, v_type = get_dict_types(d)
    print(prettify_dict(d, k_type, v_type, indent=4, last_line_comma=True))

