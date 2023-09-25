#!/usr/bin/env python
import pandas as pd
import polars as pl
import sys
import select
import io
from pathlib import Path
from typing import List, TextIO
import warnings
import argparse
from enum import Enum
parser = argparse.ArgumentParser()
parser.add_argument('infile', nargs='?')
args = parser.parse_args()

class ContentType(Enum):
    FILE_NAME = 1
    CSV = 2

def read_data() -> pl.DataFrame:
    '''Function that dynamically picks data from
    stdin or argv depending on what is available. Stdin
    only supports csv content at the moment'''
    data: Path | io.StringIO = args.infile
    if not data:
        data = io.StringIO(sys.stdin.read())
    else:
        data = Path(data)
    df = read_table_file(data)

    return df

# File detection functions
def read_table_file(f: io.StringIO | Path) -> pl.DataFrame:
    ''' Try various ways of autodetecting
    file type and other pieces of information
    required and parse the file into a
    pandas dataframe'''
    df = None
    if isinstance(f, Path):
        match f.suffix:
            case ".csv":
                df = read_csv_file(f)
            case ".xls" | ".xlsx":
                print("Filetype is: MS excel\n")
                df = pd.read_excel(f)
    else:
        df = read_csv_file(f)
    if not isinstance(df, pl.DataFrame):
        raise ValueError(
            "Passed file could not be matched as a csv or MS excel file"
        )

    return df

def detect_csv_sep(f: Path | io.StringIO ) -> str:
    '''Initial support for autodetecting:
    - comma
    - semicolon
    '''
    sep = ','
    if isinstance(f, Path):
        fp = open(f, 'r')
    else:
        fp = f
    l1 = fp.readline()
    l2 = fp.readline()
    lines = [l1, l2]
    sep = csv_sep_detect_logic(lines)
    fp.seek(0)

    return sep

def csv_sep_detect_logic(lines: List) -> str:
    counts = {',': 0, ';': 0}
    for l in lines:
        for k in counts:
            counts[k] = l.count(k)
    top_seps = [key for key, value in counts.items() if value == max(counts.values())]
    sep = top_seps[0]

    return sep

def read_csv_file(f: Path | io.StringIO) -> pl.DataFrame:
    print("Filetype is: csv\n")
    sep = detect_csv_sep(f)

    df = pl.read_csv(f, infer_schema_length=10000, separator=sep)
    if isinstance(f, io.StringIO):
        f.close()
    return df


# Column type assignment & cleanup functions
def assign_df_types(df: pl.DataFrame) -> None:
    '''Changes types in place'''
    print(df.schema)
    for column, tpe in df.schema.items():
        base_type = tpe.base_type()
        print(tpe.base_type())
        if base_type == pl.Utf8:
            uq = pl.col(column).drop_nans().drop_nulls().unique()
            # Try to cast to date
            if any([x in str(uq[0]) for x in ['.', '-', '/']]):
                try:
                    # TODO: cast to date
                    df.col(column)
                except:
                    pass
            if base_type != pl.Datetime:
                # TODO: think of what other casts may be useful
                pass

def string_column_cleanup(df: pl.DataFrame) -> None:
    # TODO: Add generic cleanup here
    pass


# Column analysis candidate finding functions
def get_analysis_candidates(df: pl.DataFrame) -> dict[str, list]:
    col_candidates = dict(keys=df.columns)
    for col in df.columns:
        col_candidates[col] = get_col_analysis_candidates(df[col])
    return col_candidates

def get_col_analysis_candidates(s: pd.Series) -> list:
    candidates = []
    if 'datetime64' in str(s.dtype):
        candidates.append('numeric_cron_date')
    if s.dtype in [int, float]:
        if _detect_year_col(s):
            candidates.append('year')
        else:
            candidates.append('numeric')
            candidates.append('basic_stats')
    if s.dtype == 'object':
        candidates.append('grouper')
        candidates.append('value_counts')

    return candidates

def _detect_year_col(series: pd.Series) -> bool:
    if all(series.dropna().between(1900, 2100)):
        return True
    return False

# Analysis functions

def _col_nan_percentage(s: pd.Series) -> float | None:
    if len(s) > 0:
        return s.isna().tolist().count(True) / len(s)

def column_level_overview_text(
            df: pl.DataFrame,
            analysis_candidates: dict[str, list]
        ) -> None:
    for i, col in enumerate(df.columns):
        print(f"SUMMARY FOR COLUMN: {col}, index: {i} [{df[col].dtype}]")
        if all(df[col].isna()):
            print("Column is completely empty")
            print("--------------------------------------------")
            break
        nan_percentage = _col_nan_percentage(df[col]) * 100
        if nan_percentage:
            print(f"NaN percentage: {nan_percentage:.4f} %")
        else:
            print(f"No NaN values")
        candidates = analysis_candidates[col]
        if 'year' in candidates:
            print(f"Contains years between: {df[col].min()} - {df[col].max()}")
        if 'numeric_cron_date' in candidates:
            print(f"Date range: {df[col].dt.date.min()} - {df[col].dt.date.max()}")
        elif 'basic_stats' in candidates and 'numeric' in candidates:
            median = df[col].median()
            print(f"median     {median:.6f}")
            print(df[col].describe())
        elif 'grouper' in candidates and 'value_counts' in candidates:
            print(df[col].value_counts())
        print("--------------------------------------------")


if __name__ == '__main__':
    dfm = read_data()
    assign_df_types(dfm)
    # candidates = get_analysis_candidates(dfm)
    # column_level_overview_text(dfm, candidates)
