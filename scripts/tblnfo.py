#!/usr/bin/env python
import polars as pl
import sys
import io
from pathlib import Path
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('infile', nargs='?')
args = parser.parse_args()

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
    '''
    Try various ways of autodetecting
    file type and other pieces of information
    required and parse the file into a
    dataframe.
    '''
    df = None
    if isinstance(f, Path):
        match f.suffix:
            case ".xls":
                raise ValueError("Old .xls files are not supported. Please convert to .xlsx or .csv")
            case ".csv":
                df = read_csv_file(f)
            case ".xlsx":
                print("File type is: MS excel\n")
                df = pl.read_excel(f)
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

def csv_sep_detect_logic(lines: list) -> str:
    counts = {',': 0, ';': 0}
    for l in lines:
        for k in counts:
            counts[k] = l.count(k)
    top_seps = [key for key, value in counts.items() if value == max(counts.values())]
    sep = top_seps[0]

    return sep

def read_csv_file(f: Path | io.StringIO) -> pl.DataFrame:
    print("File type is: csv\n")
    sep = detect_csv_sep(f)

    try:
        df = pl.read_csv(
            f,
            infer_schema_length = 100000,
            separator = sep,
            try_parse_dates = True,
        )
    except:
        # Bad date formats can seemingly break things instead of falling back to Utf8
        df = pl.read_csv(
            f,
            infer_schema_length = 100000,
            separator = sep,
        )
    if isinstance(f, io.StringIO):
        f.close()
    return df


# Column type assignment & cleanup functions
def assign_df_types(df: pl.DataFrame) -> None:
    '''Changes types in place'''
    for column, tpe in df.schema.items():
        base_type = tpe.base_type()
        if base_type == pl.Utf8:
            uq = df.get_column(column).drop_nans().drop_nulls().unique()
            if len(uq) == 0:
                continue
            # Try to cast to date
            first_str = str(uq.item(0))
            if any([x in first_str for x in ['.', '-']]):
                assign_col_datetime(df, column, first_str)
            if base_type != pl.Datetime:
                # TODO: think of what other casts may be useful
                pass

def assign_col_datetime(
        df: pl.DataFrame,
        column_name: str,
        sample_value: str,
    ):
    '''Applied in-place if successful. Fails silently and keeps string format'''
    date_format = None
    if '-' in sample_value:
        date_format = '%Y-%m-%d'
    elif '.' in sample_value:
        date_format = '%Y.%m.%d'
    try:
        date_series = df.get_column(column_name).str.to_datetime(date_format)
        df = df.with_columns(date_series.alias(column_name))
    except:
        pass

def string_column_cleanup(df: pl.DataFrame) -> None:
    # TODO: Add generic cleanup here
    pass


# Column analysis candidate finding functions
def get_analysis_candidates(df: pl.DataFrame) -> dict[str, list]:
    columns = list(df.schema.keys())
    col_candidates = dict(keys=columns)
    for column in columns:
        col_candidates[column] = get_col_analysis_candidates(df.get_column(column))
    return col_candidates

def get_col_analysis_candidates(s: pl.Series) -> list:
    candidates = []
    if s.dtype in [pl.Datetime, pl.Date]:
        candidates.append('numeric_cron_date')
    if s.dtype in [pl.Int64, pl.Float64]:
        if _detect_year_col(s):
            candidates.append('year')
        else:
            candidates.append('numeric')
            candidates.append('basic_stats')
    if s.dtype == pl.Utf8:
        candidates.append('grouper')
        candidates.append('value_counts')

    return candidates

def _detect_year_col(series: pl.Series) -> bool:
    if all(series.drop_nulls().drop_nans().is_between(1900, 2100)):
        return True
    return False

# Analysis functions

def _col_empty_percentage(s: pl.Series) -> float | None:
    if len(s) > 0:
        original_length = len(s)
        return (original_length - len(s.drop_nulls().drop_nans())) / original_length * 100
    return None

def column_level_overview_text(
            df: pl.DataFrame,
            analysis_candidates: dict[str, list]
        ) -> None:
    divider = "----------------------------------------------"
    for i, (column_name, tpe) in enumerate(df.schema.items()):
        column: pl.Series = df.get_column(column_name)
        print(f"SUMMARY FOR COLUMN: {column_name}, index: {i} [{tpe.base_type()}]")
        if len(column.drop_nulls().drop_nans()) == 0:
            print("Column is completely empty")
            print(divider)
            break
        empty_percentage = _col_empty_percentage(column)
        if empty_percentage:
            print(f"Empty percentage: {empty_percentage:.4f} %")
        else:
            print(f"No empty values")
        candidates = analysis_candidates[column_name]
        if 'year' in candidates:
            print(f"Contains years between: {column.min()} - {column.max()}")
        if 'numeric_cron_date' in candidates:
            print(f"Date range: {column.dt.date().min()} - {column.dt.date().max()}")
        elif 'basic_stats' in candidates and 'numeric' in candidates:
            median = column.median()
            print(f"median     {median:.6f}")
            print(column.describe())
        elif 'grouper' in candidates and 'value_counts' in candidates:
            print(column.value_counts().sort(by='counts', descending=True))
        print(divider)


if __name__ == '__main__':
    dfm = read_data()
    assign_df_types(dfm)
    candidates = get_analysis_candidates(dfm)
    column_level_overview_text(dfm, candidates)
