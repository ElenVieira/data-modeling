-- Carga da fato de pedidos
-- Load the orders fact table

BEGIN;

WITH order_totals AS (
    SELECT
        order_id,
        COUNT(*)::INTEGER AS item_count,
        SUM(price)::NUMERIC(14, 2) AS order_product_value,
        SUM(freight_value)::NUMERIC(14, 2) AS order_freight_value
    FROM staging.stg_order_items
    GROUP BY order_id
)
INSERT INTO marts.fct_orders (
    order_id,
    customer_key,
    purchase_date_key,
    approved_date_key,
    carrier_date_key,
    delivered_date_key,
    estimated_delivery_date_key,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    item_count,
    order_product_value,
    order_freight_value,
    dispatch_days,
    transit_days,
    total_delivery_days,
    is_delivered,
    is_late
)
SELECT
    source_order.order_id,
    customer.customer_key,
    purchase_date.date_key,
    approved_date.date_key,
    carrier_date.date_key,
    delivered_date.date_key,
    estimated_date.date_key,
    source_order.order_status,
    source_order.order_purchase_timestamp,
    source_order.order_approved_at,
    source_order.order_delivered_carrier_date,
    source_order.order_delivered_customer_date,
    source_order.order_estimated_delivery_date,
    COALESCE(totals.item_count, 0),
    COALESCE(totals.order_product_value, 0),
    COALESCE(totals.order_freight_value, 0),

    ROUND((
        EXTRACT(EPOCH FROM (
            source_order.order_delivered_carrier_date
            - source_order.order_purchase_timestamp
        )) / 86400
    )::NUMERIC, 2),

    ROUND((
        EXTRACT(EPOCH FROM (
            source_order.order_delivered_customer_date
            - source_order.order_delivered_carrier_date
        )) / 86400
    )::NUMERIC, 2),

    ROUND((
        EXTRACT(EPOCH FROM (
            source_order.order_delivered_customer_date
            - source_order.order_purchase_timestamp
        )) / 86400
    )::NUMERIC, 2),

    source_order.order_status = 'delivered',

    CASE
        WHEN source_order.order_delivered_customer_date IS NOT NULL
         AND source_order.order_estimated_delivery_date IS NOT NULL
        THEN source_order.order_delivered_customer_date
             > source_order.order_estimated_delivery_date
        ELSE NULL
    END
FROM staging.stg_orders AS source_order
JOIN marts.dim_customer AS customer
    ON source_order.customer_id = customer.customer_id
JOIN marts.dim_date AS purchase_date
    ON source_order.order_purchase_timestamp::DATE =
       purchase_date.full_date
LEFT JOIN marts.dim_date AS approved_date
    ON source_order.order_approved_at::DATE =
       approved_date.full_date
LEFT JOIN marts.dim_date AS carrier_date
    ON source_order.order_delivered_carrier_date::DATE =
       carrier_date.full_date
LEFT JOIN marts.dim_date AS delivered_date
    ON source_order.order_delivered_customer_date::DATE =
       delivered_date.full_date
LEFT JOIN marts.dim_date AS estimated_date
    ON source_order.order_estimated_delivery_date::DATE =
       estimated_date.full_date
LEFT JOIN order_totals AS totals
    ON source_order.order_id = totals.order_id
ON CONFLICT (order_id)
DO UPDATE SET
    customer_key = EXCLUDED.customer_key,
    purchase_date_key = EXCLUDED.purchase_date_key,
    approved_date_key = EXCLUDED.approved_date_key,
    carrier_date_key = EXCLUDED.carrier_date_key,
    delivered_date_key = EXCLUDED.delivered_date_key,
    estimated_delivery_date_key =
        EXCLUDED.estimated_delivery_date_key,
    order_status = EXCLUDED.order_status,
    order_purchase_timestamp = EXCLUDED.order_purchase_timestamp,
    order_approved_at = EXCLUDED.order_approved_at,
    order_delivered_carrier_date =
        EXCLUDED.order_delivered_carrier_date,
    order_delivered_customer_date =
        EXCLUDED.order_delivered_customer_date,
    order_estimated_delivery_date =
        EXCLUDED.order_estimated_delivery_date,
    item_count = EXCLUDED.item_count,
    order_product_value = EXCLUDED.order_product_value,
    order_freight_value = EXCLUDED.order_freight_value,
    dispatch_days = EXCLUDED.dispatch_days,
    transit_days = EXCLUDED.transit_days,
    total_delivery_days = EXCLUDED.total_delivery_days,
    is_delivered = EXCLUDED.is_delivered,
    is_late = EXCLUDED.is_late;

COMMIT;
