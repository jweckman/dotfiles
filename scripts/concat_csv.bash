#!/bin/bash
# Usage:
# Pipe a list of files using ls or find to this script to combine the files into combined.csv
xargs -I {} sh -c "head -n 1 {} > combined.csv && tail -n+2 -q *.csv >> combined.csv"
