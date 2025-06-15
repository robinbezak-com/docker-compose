-- db-init/02_pgadmin_init.sql
-- This script runs inside the PostgreSQL container on its first startup.
-- It sets up a dedicated user for PgAdmin to connect and manage databases.

-- Create a dedicated user for PgAdmin to connect to the PostgreSQL server.
-- This user should have restricted privileges, not superuser access.
CREATE USER pgadmin_user WITH PASSWORD '${PGADMIN_VIEWER_PASSWORD}';

-- Grant CONNECT privilege on specific databases for pgadmin_user.
-- This allows pgadmin_user to see and access these databases via PgAdmin.
GRANT CONNECT ON DATABASE postgres TO pgadmin_user; -- Default database
GRANT CONNECT ON DATABASE n8n_data TO pgadmin_user; -- N8N's database

-- Grant SELECT privileges on information schema and pg_catalog for pgadmin_user.
-- This allows PgAdmin to list databases, schemas, and tables properly.
GRANT SELECT ON ALL TABLES IN SCHEMA pg_catalog TO pgadmin_user;
GRANT SELECT ON ALL TABLES IN SCHEMA information_schema TO pgadmin_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA pg_catalog GRANT SELECT ON TABLES TO pgadmin_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA information_schema GRANT SELECT ON TABLES TO pgadmin_user;