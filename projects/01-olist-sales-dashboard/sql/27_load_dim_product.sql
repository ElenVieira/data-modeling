-- Carga da dimensão de produtos
-- Load the product dimension

BEGIN;

INSERT INTO marts.dim_product (
    product_id,
    product_category_name_pt,
    product_category_name_en,
    product_name_length,
    product_description_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
)
SELECT
    product.product_id,
    COALESCE(product.product_category_name, 'sem_categoria'),
    COALESCE(
        translation.product_category_name_english,
        product.product_category_name,
        'uncategorized'
    ),
    product.product_name_length,
    product.product_description_length,
    product.product_photos_qty,
    product.product_weight_g,
    product.product_length_cm,
    product.product_height_cm,
    product.product_width_cm
FROM staging.stg_products AS product
LEFT JOIN staging.stg_category_translation AS translation
    ON product.product_category_name =
       translation.product_category_name
ON CONFLICT (product_id)
DO UPDATE SET
    product_category_name_pt = EXCLUDED.product_category_name_pt,
    product_category_name_en = EXCLUDED.product_category_name_en,
    product_name_length = EXCLUDED.product_name_length,
    product_description_length = EXCLUDED.product_description_length,
    product_photos_qty = EXCLUDED.product_photos_qty,
    product_weight_g = EXCLUDED.product_weight_g,
    product_length_cm = EXCLUDED.product_length_cm,
    product_height_cm = EXCLUDED.product_height_cm,
    product_width_cm = EXCLUDED.product_width_cm;

COMMIT;
