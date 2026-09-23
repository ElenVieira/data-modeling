-- Avaliações tratadas para uso nas camadas analíticas
-- Cleaned reviews for analytical layers

CREATE TABLE IF NOT EXISTS staging.stg_order_reviews (
    review_id TEXT NOT NULL,
    order_id TEXT NOT NULL,
    review_score SMALLINT NOT NULL CHECK (review_score BETWEEN 1 AND 5),
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP NOT NULL,
    review_answer_timestamp TIMESTAMP,

    PRIMARY KEY (review_id, order_id)
);
