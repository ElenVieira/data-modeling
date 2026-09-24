-- Carga da fato de itens vendidos
-- Load the sales items fact table

BEGIN;

INSERT INTO marts.fct_sales_items (
    order_key,
    order_item_id,
    customer_key,
    product_key,
    seller_key,
    purchase_date_key,
    shipping_limit_date_key,
    shipping_limit_timestamp,
    price,
    freight_value,
    is_delivered
)
SELECT
    order_fact.order_key,
    order_item.order_item_id,
    order_fact.customer_key,
    product.product_key,
    seller.seller_key,
    order_fact.purchase_date_key,
    shipping_date.date_key,
    order_item.shipping_limit_date,
    order_item.price,
    order_item.freight_value,
    order_fact.is_delivered
FROM staging.stg_order_items AS order_item
JOIN marts.fct_orders AS order_fact
    ON order_item.order_id = order_fact.order_id
JOIN marts.dim_product AS product
    ON order_item.product_id = product.product_id
JOIN marts.dim_seller AS seller
    ON order_item.seller_id = seller.seller_id
LEFT JOIN marts.dim_date AS shipping_date
    ON order_item.shipping_limit_date::DATE =
       shipping_date.full_date
ON CONFLICT (order_key, order_item_id)
DO UPDATE SET
    customer_key = EXCLUDED.customer_key,
    product_key = EXCLUDED.product_key,
    seller_key = EXCLUDED.seller_key,
    purchase_date_key = EXCLUDED.purchase_date_key,
    shipping_limit_date_key = EXCLUDED.shipping_limit_date_key,
    shipping_limit_timestamp = EXCLUDED.shipping_limit_timestamp,
    price = EXCLUDED.price,
    freight_value = EXCLUDED.freight_value,
    is_delivered = EXCLUDED.is_delivered;

COMMIT;
