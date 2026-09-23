-- Carga da camada raw para a staging de clientes
-- Load raw customers into the staging layer

BEGIN;

TRUNCATE TABLE staging.stg_customers;

INSERT INTO staging.stg_customers (
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
)
SELECT
    NULLIF(BTRIM(customer_id), ''),
    NULLIF(BTRIM(customer_unique_id), ''),
    NULLIF(BTRIM(customer_zip_code_prefix), ''),
    LOWER(NULLIF(BTRIM(customer_city), '')),
    UPPER(NULLIF(BTRIM(customer_state), ''))
FROM raw.olist_customers
WHERE NULLIF(BTRIM(customer_id), '') IS NOT NULL
  AND NULLIF(BTRIM(customer_unique_id), '') IS NOT NULL
  AND NULLIF(BTRIM(customer_city), '') IS NOT NULL
  AND NULLIF(BTRIM(customer_state), '') IS NOT NULL;

COMMIT;
