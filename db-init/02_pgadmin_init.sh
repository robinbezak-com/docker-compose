#!/bin/bash
set -e

# This script creates the dedicated user for pgAdmin to connect to the database.
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER pgadmin_user WITH PASSWORD '$PGADMIN_VIEWER_PASSWORD';

    -- Grant connect privilege on the default 'postgres' database
    GRANT CONNECT ON DATABASE postgres TO pgadmin_user;

    -- Grant connect privilege on the 'n8n_data' database
    -- This relies on 01_n8n_init.sh having already created this database
    GRANT CONNECT ON DATABASE n8n_data TO pgadmin_user;

    -- Grant usage privileges for pgAdmin to browse schemas
    GRANT SELECT ON ALL TABLES IN SCHEMA pg_catalog TO pgadmin_user;
    GRANT SELECT ON ALL TABLES IN SCHEMA information_schema TO pgadmin_user;
    ALTER DEFAULT PRIVILEGES IN SCHEMA pg_catalog GRANT SELECT ON TABLES TO pgadmin_user;
    ALTER DEFAULT PRIVILEGES IN SCHEMA information_schema GRANT SELECT ON TABLES TO pgadmin_user;
EOSQL