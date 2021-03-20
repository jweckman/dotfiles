import pandas as pd
import sys

''' Filter duplicates from a utf-8 ; csv file by specifying filename and column name as arguments in that order. NB! Applies .lower() to the duplicates column so this may change your data'''

filename = sys.argv[1] 

df = pd.read_csv(filename, sep=';', dtype='str')

print(f"Length of df before: {len(df)}")
l = len(df)
col_name = sys.argv[2] 

df[col_name] = df[col_name].str.lower()
df.drop_duplicates(subset=[col_name], inplace=True)
percent_diff = round((1 - (len(df) / l))*100)
print(f"Length after: {len(df)} an {percent_diff}% decrease in size") 

dot = filename.rfind('.')
fname = f"{filename[:dot]}_no_{col_name}_duplicates.csv"

df.to_csv(fname, sep=';', index=False)
