#!/usr/bin/env python
import pandas as pd
from sys import argv, stdin
import select
from pathlib import Path
from typing import List, TextIO
import warnings

def read_data() -> pd.DataFrame:
    '''Function that dynamically picks data from
    stdin or argv depending on what is available. Stdin
    only supports csv content at the moment'''
    if select.select([stdin, ], [], [], 0.0)[0]:
        file_object = stdin
    else:
        file_name = argv[1]
        file_object = Path(file_name)
    df = read_table_file(file_object)

    return df

# File detection functions
def read_table_file(f: Path | TextIO) -> pd.DataFrame:
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
    if not df:
        raise ValueError(
            "Passed file could not be matched as a csv or MS excel file"
        )

    return df

def detect_csv_sep(f: Path | TextIO) -> str:
    '''Initial support for autodetecting:
    - comma
    - semicolon
    Defaults to ","
    '''
    sep = ','
    if isinstance(f, Path):
        fp = open(f, 'r')
    else:
        fp = f
    l1 = fp.readline()
    l2 = fp.readline()
    lines = [l1, l2]
    csv_sep_detect_logic(lines)
    if isinstance(f, Path):
        fp.close()

    return sep

def csv_sep_detect_logic(lines: List) -> str:
    counts = {',': 0, ';': 0}
    for l in lines:
        for k in counts:
            counts[k] = l.count(k)
    top_seps = [key for key, value in counts.items() if value == max(counts.values())]
    sep = top_seps[0]

    return sep

def read_csv_file(f: Path | TextIO) -> pd.DataFrame:
    print("Filetype is: csv\n")
    sep = detect_csv_sep(f)
    df = pd.read_csv(
        f,
        sep = sep,
    )
    return df


# Column type assignment & cleanup functions
def assign_df_types(df: pd.DataFrame) -> None:
    '''Changes types in place'''
    for col in df.columns:
        if df[col].dtype == 'object':
            uq = df[col].dropna().unique()
            # Try to cast to date
            if any([x in str(uq[0]) for x in ['.', '-', '/']]):
                try:
                    df[col] = pd.to_datetime(df[col])
                except:
                    pass
            if df[col].dtype != 'datetime64[ns]':
                # TODO: think of what other casts may be useful
                pass

def string_column_cleanup(df: pd.DataFrame) -> None:
    # TODO: Add generic cleanup here
    pass


# Column analysis candidate finding functions
def get_analysis_candidates(df: pd.DataFrame) -> dict[str, list]:
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
def column_level_overview_text(
            df: pd.DataFrame,
            analysis_candidates: dict[str, list]
        ) -> None:
    for i, col in enumerate(df.columns):
        print(f"SUMMARY FOR COLUMN: {col}, index: {i} [{df[col].dtype}]")
        if all(df[col].isna()):
            print("Column is completely empty")
            print("--------------------------------------------")
            break
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
    candidates = get_analysis_candidates(dfm)
    column_level_overview_text(dfm, candidates)
