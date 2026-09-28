-- Cria o banco analítico somente se ele ainda não existir.
-- Creates the analytical database only if it does not exist yet.

SELECT format('CREATE DATABASE %I', 'olist_dw')
WHERE NOT EXISTS (
    SELECT 1
    FROM pg_database
    WHERE datname = 'olist_dw'
)
\gexec
