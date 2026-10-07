BEGIN;

CREATE OR REPLACE VIEW analytics.vw_logistics_overview AS
SELECT
    orders.order_key,
    orders.order_id,
    purchase_date.full_date AS purchase_date,
    delivered_date.full_date AS delivered_date,
    estimated_date.full_date AS estimated_delivery_date,
    customer.customer_state,
    customer.customer_city,
    orders.order_status,
    orders.item_count,
    orders.order_product_value,
    orders.order_freight_value,
    orders.dispatch_days,
    orders.transit_days,
    orders.total_delivery_days,
    orders.is_delivered,
    orders.is_late
FROM marts.fct_orders AS orders
JOIN marts.dim_customer AS customer
    ON orders.customer_key = customer.customer_key
JOIN marts.dim_date AS purchase_date
    ON orders.purchase_date_key = purchase_date.date_key
LEFT JOIN marts.dim_date AS delivered_date
    ON orders.delivered_date_key = delivered_date.date_key
LEFT JOIN marts.dim_date AS estimated_date
    ON orders.estimated_delivery_date_key = estimated_date.date_key;

COMMIT;
