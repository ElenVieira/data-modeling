-- Carga da camada raw para a staging de avaliações
-- Load raw reviews into the staging layer

BEGIN;

TRUNCATE TABLE staging.stg_order_reviews;

INSERT INTO staging.stg_order_reviews (
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
)
SELECT
    NULLIF(BTRIM(review_id), ''),
    NULLIF(BTRIM(order_id), ''),
    NULLIF(BTRIM(review_score), '')::SMALLINT,
    NULLIF(BTRIM(review_comment_title), ''),
    NULLIF(BTRIM(review_comment_message), ''),
    NULLIF(BTRIM(review_creation_date), '')::TIMESTAMP,
    NULLIF(BTRIM(review_answer_timestamp), '')::TIMESTAMP
FROM raw.olist_order_reviews
WHERE NULLIF(BTRIM(review_id), '') IS NOT NULL
  AND NULLIF(BTRIM(order_id), '') IS NOT NULL
  AND BTRIM(review_score) ~ '^[1-5]$'
  AND NULLIF(BTRIM(review_creation_date), '') IS NOT NULL;

COMMIT;
