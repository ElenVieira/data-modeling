-- Carga da camada raw para a staging de vendedores
-- Load raw sellers into the staging layer

BEGIN;

TRUNCATE TABLE staging.stg_sellers;

INSERT INTO staging.stg_sellers (
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
)
SELECT
    NULLIF(BTRIM(seller_id), ''),
    NULLIF(BTRIM(seller_zip_code_prefix), ''),
    LOWER(NULLIF(BTRIM(seller_city), '')),
    UPPER(NULLIF(BTRIM(seller_state), ''))
FROM raw.olist_sellers
WHERE NULLIF(BTRIM(seller_id), '') IS NOT NULL
  AND NULLIF(BTRIM(seller_city), '') IS NOT NULL
  AND NULLIF(BTRIM(seller_state), '') IS NOT NULL;

COMMIT;
