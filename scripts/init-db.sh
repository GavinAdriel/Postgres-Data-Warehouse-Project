#!/bin/bash
set -e

echo "[INIT] Starting Data Warehouse initialization..."
echo "[INIT] Using database: $POSTGRES_DB, user: $POSTGRES_USER"

# --- Create schemas (Bronze / Silver / Gold) ---
echo "[INFO] Creating Medallion Schemas..."
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE SCHEMA IF NOT EXISTS ${BRONZE_SCHEMA};
    CREATE SCHEMA IF NOT EXISTS ${SILVER_SCHEMA};
    CREATE SCHEMA IF NOT EXISTS ${GOLD_SCHEMA};
EOSQL
echo "[SUCCESS] Schemas created: $BRONZE_SCHEMA, $SILVER_SCHEMA, $GOLD_SCHEMA"

# --- 3️⃣ Load SQL files automatically ---
SQL_DIR="/docker-entrypoint-initdb.d/sql"
if [ -d "$SQL_DIR" ]; then
  echo "[INFO] Found SQL directory at $SQL_DIR"
  for sql_file in "$SQL_DIR"/*.sql; do
    if [ -f "$sql_file" ]; then
      echo "[RUNNING] Executing $sql_file ..."
      psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f "$sql_file"
      echo "[SUCCESS] Executed: $sql_file"
    else
      echo "[INFO] No .sql files found in $SQL_DIR"
    fi
  done
else
  echo "[WARN] SQL directory not found at $SQL_DIR"
fi

echo "[INIT COMPLETE] Data Warehouse setup is ready."
