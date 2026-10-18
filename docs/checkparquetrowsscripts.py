from pathlib import Path
import pandas as pd

file_path = Path(__file__).resolve().parent / "customers.parquet"

df = pd.read_parquet(file_path)

print("Total Rows:", len(df))
print("Unique Customers:", df["customer_id"].nunique())
print("Null Updated At:", df["updated_at"].isna().sum())
print(df.head())