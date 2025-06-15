-- db-init/01_n8n_init.sql
-- This script runs inside the PostgreSQL container on its first startup.
-- It sets up the database and user specifically for N8N.

-- Create the database for N8N
CREATE DATABASE n8n_data;

-- Create a dedicated user for N8N with a password.
-- The password will be replaced by Docker Compose from the N8N_DB_PASSWORD environment variable.
CREATE USER n8n_user WITH PASSWORD '${N8N_DB_PASSWORD}';

-- Grant all privileges on the n8n_data database to the n8n_user.
-- For production, you might want more granular privileges.
GRANT ALL PRIVILEGES ON DATABASE n8n_data TO n8n_user;