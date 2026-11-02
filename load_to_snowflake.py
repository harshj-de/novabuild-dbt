import os
import pandas as pd
import snowflake.connector
from snowflake.connector.pandas_tools import write_pandas
from pathlib import Path

DATA_DIR = Path("/workspaces/novabuild-dbt/data")

# Connect to Snowflake
print("Connecting to Snowflake...")
conn = snowflake.connector.connect(
    account=os.environ["SF_ACCOUNT"],
    user=os.environ["SF_USER"],
    password=os.environ["SF_PASSWORD"],
    warehouse=os.environ["SF_WAREHOUSE"],
    database=os.environ["SF_DATABASE"],
    schema=os.environ["SF_SCHEMA"],
    role=os.environ["SF_ROLE"],
)
print("Connected.\n")

# Find all CSVs
csv_files = sorted(DATA_DIR.glob("*.csv"))
print(f"Found {len(csv_files)} CSV files to load.\n")

results = []

for csv_path in csv_files:
    table_name = csv_path.stem.upper()  # Snowflake prefers uppercase
    print(f"Loading {csv_path.name} -> {table_name} ...", end=" ", flush=True)

    try:
        # Read CSV with pandas, infer types
        df = pd.read_csv(csv_path)
        # Uppercase column names (Snowflake convention)
        df.columns = [c.upper() for c in df.columns]
        row_count = len(df)

        # Write to Snowflake - auto-creates table, bulk loads
        success, nchunks, nrows, _ = write_pandas(
            conn=conn,
            df=df,
            table_name=table_name,
            auto_create_table=True,
            overwrite=True,  # Replaces table if exists
        )

        if success:
            print(f"OK ({nrows:,} rows)")
            results.append((table_name, row_count, "OK"))
        else:
            print(f"FAILED")
            results.append((table_name, row_count, "FAILED"))

    except Exception as e:
        print(f"ERROR: {e}")
        results.append((table_name, 0, f"ERROR: {str(e)[:50]}"))

# Summary
print("\n" + "=" * 60)
print("LOAD SUMMARY")
print("=" * 60)
total_loaded = 0
for table, count, status in results:
    print(f"  {table:30s} {count:>8,} rows   {status}")
    if status == "OK":
        total_loaded += count

print("=" * 60)
print(f"  TOTAL: {total_loaded:,} rows across {len([r for r in results if r[2] == 'OK'])} tables")

conn.close()
print("\nConnection closed.")