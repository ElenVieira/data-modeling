-- Carga da camada raw para a staging de produtos
-- Load raw products into the staging layer

BEGIN;

TRUNCATE TABLE staging.stg_products;

INSERT INTO staging.stg_products (
    product_id,
    product_category_name,
    product_name_length,
    product_description_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
)
SELECT
    NULLIF(BTRIM(product_id), ''),
    LOWER(NULLIF(BTRIM(product_category_name), '')),
    NULLIF(BTRIM(product_name_lenght), '')::INTEGER,
    NULLIF(BTRIM(product_description_lenght), '')::INTEGER,
    NULLIF(BTRIM(product_photos_qty), '')::INTEGER,
    NULLIF(BTRIM(product_weight_g), '')::INTEGER,
    NULLIF(BTRIM(product_length_cm), '')::INTEGER,
    NULLIF(BTRIM(product_height_cm), '')::INTEGER,
    NULLIF(BTRIM(product_width_cm), '')::INTEGER
FROM raw.olist_products
WHERE NULLIF(BTRIM(product_id), '') IS NOT NULL;

COMMIT;
