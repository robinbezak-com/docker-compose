-- db-init/01_n8n_init.sql
-- This script runs inside the PostgreSQL container on its first startup.
-- It creates the dedicated user and database for N8n, setting the user as owner.

-- Create the dedicated user for N8n
CREATE USER n8n_user WITH PASSWORD '${N8N_DB_PASSWORD}';

-- Create the database for N8n and assign n8n_user as its owner
CREATE DATABASE n8n_data WITH OWNER n8n_user;