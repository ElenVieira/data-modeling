-- Fato analítica de avaliações
-- Analytical reviews fact table

CREATE TABLE IF NOT EXISTS marts.fct_reviews (
    review_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    review_id TEXT NOT NULL,
    order_key BIGINT NOT NULL
        REFERENCES marts.fct_orders (order_key),
    customer_key BIGINT NOT NULL
        REFERENCES marts.dim_customer (customer_key),
    purchase_date_key INTEGER NOT NULL
        REFERENCES marts.dim_date (date_key),
    review_date_key INTEGER NOT NULL
        REFERENCES marts.dim_date (date_key),
    review_answer_date_key INTEGER
        REFERENCES marts.dim_date (date_key),

    review_score SMALLINT NOT NULL,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_timestamp TIMESTAMP NOT NULL,
    review_answer_timestamp TIMESTAMP,
    review_response_hours NUMERIC(12, 2),

    UNIQUE (review_id, order_key),
    CHECK (review_score BETWEEN 1 AND 5)
);
