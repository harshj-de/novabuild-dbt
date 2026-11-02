import os
import psycopg2

conn = psycopg2.connect(
    host=os.environ["PG_HOST"],
    port=os.environ["PG_PORT"],
    database=os.environ["PG_DATABASE"],
    user=os.environ["PG_USER"],
    password=os.environ["PG_PASSWORD"],
    sslmode="require"
)

cur = conn.cursor()

# List all tables in the public schema
cur.execute("""
    SELECT table_name 
    FROM information_schema.tables 
    WHERE table_schema = 'public' 
    ORDER BY table_name;
""")
tables = [row[0] for row in cur.fetchall()]

print(f"\nFound {len(tables)} tables in schema 'public':\n")

# For each table, count rows
for table in tables:
    cur.execute(f'SELECT COUNT(*) FROM public."{table}";')
    count = cur.fetchone()[0]
    print(f"  {table:40s} {count:>10,} rows")

cur.close()
conn.close()
print("\nConnection closed successfully.")