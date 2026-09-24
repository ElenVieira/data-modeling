-- Carga da fato de avaliações
-- Load the reviews fact table

BEGIN;

INSERT INTO marts.fct_reviews (
    review_id,
    order_key,
    customer_key,
    purchase_date_key,
    review_date_key,
    review_answer_date_key,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_timestamp,
    review_answer_timestamp,
    review_response_hours
)
SELECT
    review.review_id,
    order_fact.order_key,
    order_fact.customer_key,
    order_fact.purchase_date_key,
    review_date.date_key,
    answer_date.date_key,
    review.review_score,
    review.review_comment_title,
    review.review_comment_message,
    review.review_creation_date,
    review.review_answer_timestamp,
    ROUND((
        EXTRACT(EPOCH FROM (
            review.review_answer_timestamp
            - review.review_creation_date
        )) / 3600
    )::NUMERIC, 2)
FROM staging.stg_order_reviews AS review
JOIN marts.fct_orders AS order_fact
    ON review.order_id = order_fact.order_id
JOIN marts.dim_date AS review_date
    ON review.review_creation_date::DATE =
       review_date.full_date
LEFT JOIN marts.dim_date AS answer_date
    ON review.review_answer_timestamp::DATE =
       answer_date.full_date
ON CONFLICT (review_id, order_key)
DO UPDATE SET
    customer_key = EXCLUDED.customer_key,
    purchase_date_key = EXCLUDED.purchase_date_key,
    review_date_key = EXCLUDED.review_date_key,
    review_answer_date_key = EXCLUDED.review_answer_date_key,
    review_score = EXCLUDED.review_score,
    review_comment_title = EXCLUDED.review_comment_title,
    review_comment_message = EXCLUDED.review_comment_message,
    review_creation_timestamp =
        EXCLUDED.review_creation_timestamp,
    review_answer_timestamp =
        EXCLUDED.review_answer_timestamp,
    review_response_hours = EXCLUDED.review_response_hours;

COMMIT;
