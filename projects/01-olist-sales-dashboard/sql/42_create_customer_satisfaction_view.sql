BEGIN;

CREATE OR REPLACE VIEW analytics.vw_customer_satisfaction AS
SELECT
    reviews.review_id,
    orders.order_id,
    purchase_date.full_date AS purchase_date,
    review_date.full_date AS review_date,
    customer.customer_state,
    customer.customer_city,
    orders.order_status,
    orders.total_delivery_days,
    orders.is_late,
    reviews.review_score,
    reviews.review_comment_title,
    reviews.review_comment_message,
    reviews.review_response_hours
FROM marts.fct_reviews AS reviews
JOIN marts.fct_orders AS orders
    ON reviews.order_key = orders.order_key
JOIN marts.dim_customer AS customer
    ON reviews.customer_key = customer.customer_key
JOIN marts.dim_date AS purchase_date
    ON reviews.purchase_date_key = purchase_date.date_key
JOIN marts.dim_date AS review_date
    ON reviews.review_date_key = review_date.date_key;

COMMIT;
