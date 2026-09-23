-- Carga da camada raw para a staging de itens de pedido
-- Load raw order items into the staging layer

BEGIN;

TRUNCATE TABLE staging.stg_order_items;

INSERT INTO staging.stg_order_items (
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
)
SELECT
    NULLIF(BTRIM(order_id), ''),
    NULLIF(BTRIM(order_item_id), '')::INTEGER,
    NULLIF(BTRIM(product_id), ''),
    NULLIF(BTRIM(seller_id), ''),
    NULLIF(BTRIM(shipping_limit_date), '')::TIMESTAMP,
    NULLIF(BTRIM(price), '')::NUMERIC(12, 2),
    NULLIF(BTRIM(freight_value), '')::NUMERIC(12, 2)
FROM raw.olist_order_items
WHERE NULLIF(BTRIM(order_id), '') IS NOT NULL
  AND NULLIF(BTRIM(order_item_id), '') IS NOT NULL
  AND NULLIF(BTRIM(product_id), '') IS NOT NULL
  AND NULLIF(BTRIM(seller_id), '') IS NOT NULL
  AND NULLIF(BTRIM(price), '') IS NOT NULL
  AND NULLIF(BTRIM(freight_value), '') IS NOT NULL;

COMMIT;
