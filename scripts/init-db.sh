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

# --- 3️⃣ Load SQL files---
echo "[INFO] Executing SQL files in explicit order..."

echo "[INFO] Creating Bronze table..."
psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /docker-entrypoint-initdb.d/scripts/bronze/ddl_bronze.sql
echo "[INFO] Creating Bronze load procedure..."
psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /docker-entrypoint-initdb.d/scripts/bronze/load_bronze.sql
echo "[INFO] Running Bronze load procedure..."
psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "CALL bronze.load_bronze();"

echo "[INFO] Creating Silver table..."
psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /docker-entrypoint-initdb.d/scripts/silver/ddl_silver.sql
echo "[INFO] Creating Silver load procedure..."
psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /docker-entrypoint-initdb.d/scripts/silver/load_silver.sql
echo "[INFO] Running Silver load procedure..."
psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "CALL silver.load_silver();"

echo "[INFO] Creating Gold view procedure..."
psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /docker-entrypoint-initdb.d/scripts/gold/view_gold.sql
echo "[INFO] Running Gold view procedure..."
psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "CALL gold.view_gold();"

echo "[SUCCESS] All SQL executed in manual order."

echo "[INIT COMPLETE] Data Warehouse setup is ready."


