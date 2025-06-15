#!/bin/bash
set -e

# This script uses psql to execute SQL commands.
# The shell substitutes $N8N_DB_PASSWORD with the real password before psql runs.
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER n8n_user WITH PASSWORD '$N8N_DB_PASSWORD';
    CREATE DATABASE n8n_data WITH OWNER n8n_user;
EOSQL