import pandas as pd
df = pd.read_parquet(
    r"customers.parquet"
)

print("Total rows:", len(df))
print("Schema:")
print(df.dtypes)
print(df.head())