-- Carga da tradução de categorias para a staging
-- Load category translations into the staging layer

BEGIN;

TRUNCATE TABLE staging.stg_category_translation;

INSERT INTO staging.stg_category_translation (
    product_category_name,
    product_category_name_english
)
SELECT
    LOWER(NULLIF(BTRIM(product_category_name), '')),
    LOWER(NULLIF(BTRIM(product_category_name_english), ''))
FROM raw.product_category_name_translation
WHERE NULLIF(BTRIM(product_category_name), '') IS NOT NULL
  AND NULLIF(BTRIM(product_category_name_english), '') IS NOT NULL;

COMMIT;
