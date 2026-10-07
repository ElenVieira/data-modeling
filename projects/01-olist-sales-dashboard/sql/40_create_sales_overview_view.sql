BEGIN;

CREATE SCHEMA IF NOT EXISTS analytics;

CREATE OR REPLACE VIEW analytics.vw_sales_overview AS
SELECT
    sales.sales_item_key,
    orders.order_id,
    sales.order_item_id,
    purchase_date.full_date AS purchase_date,
    purchase_date.year_number,
    purchase_date.quarter_number,
    purchase_date.month_number,
    purchase_date.year_month,
    customer.customer_state,
    customer.customer_city,
    product.product_category_name_pt,
    product.product_category_name_en,
    orders.order_status,
    sales.price AS product_revenue,
    sales.freight_value,
    sales.price + sales.freight_value AS total_value,
    sales.is_delivered,
    orders.is_late
FROM marts.fct_sales_items AS sales
JOIN marts.fct_orders AS orders
    ON sales.order_key = orders.order_key
JOIN marts.dim_date AS purchase_date
    ON sales.purchase_date_key = purchase_date.date_key
JOIN marts.dim_customer AS customer
    ON sales.customer_key = customer.customer_key
JOIN marts.dim_product AS product
    ON sales.product_key = product.product_key;

COMMIT;
