import os
import pandas as pd
from sqlalchemy import create_engine, text
from dotenv import load_dotenv
from time import time

# Load environment variables
load_dotenv()

DB_USER = os.getenv("POSTGRES_USER")
DB_PASS = os.getenv("POSTGRES_PASSWORD")
DB_HOST = os.getenv("POSTGRES_HOST")
DB_PORT = os.getenv("POSTGRES_PORT")
DB_NAME = os.getenv("POSTGRES_DB")

DATA_DIR = "../../datasets"
BRONZE_SCHEMA = "bronze"

engine = create_engine(f"postgresql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}")

def make_table_name(filepath: str, base_dir: str) -> str:
    """
    Convert full path (under base_dir) to a table name.
    Example: ../data/sales/transactions.csv → sales_transactions
    """
    rel_path = os.path.relpath(filepath, base_dir)    
    table_name = os.path.splitext(rel_path)[0]               
    table_name = table_name.replace(os.sep, "_").lower()    
    return table_name

def load_file_to_bronze(filepath: str, base_dir: str):
    filename = os.path.basename(filepath)
    table_name = make_table_name(filepath, base_dir)
    print(f"\n📥 Loading '{filename}' into {BRONZE_SCHEMA}.{table_name} ...")

    start = time()
    try:
        if filepath.endswith(".csv"):
            df = pd.read_csv(filepath)
        else:
            print(f"⚠️ Unsupported file type: {filename}, skipping.")
            return

        df.columns = df.columns.str.lower()
        df.to_sql(
            table_name,
            engine,
            schema=BRONZE_SCHEMA,
            if_exists="append",
            index=False,
            chunksize=50_000
        )

        print(f"✅ {len(df)} rows → {BRONZE_SCHEMA}.{table_name} ({time() - start:.2f}s)")
    except Exception as e:
        print(f"❌ Failed to ingest {filename}: {e}")

def main():
    print("🚀 Starting automated Bronze data ingestion...")
    print(f"🔗 Connecting to {DB_NAME} at {DB_HOST}:{DB_PORT}")

    # Ensure schema exists
    with engine.begin() as conn:
        try:
            conn.execute(text(f"CREATE SCHEMA IF NOT EXISTS {BRONZE_SCHEMA};"))
        except Exception as e:
            print(f"❌ Failed to create schema {BRONZE_SCHEMA}: {e}")
            return

    # Walk through all subdirectories
    for root, _, files in os.walk(DATA_DIR):
        for file in files:
            filepath = os.path.join(root, file)
            if os.path.isfile(filepath):
                load_file_to_bronze(filepath, DATA_DIR)

    print("\n🏁 Ingestion complete for all data sources.")

if __name__ == "__main__":
    main()
