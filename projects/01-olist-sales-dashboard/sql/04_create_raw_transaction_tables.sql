-- Tabelas brutas transacionais da Olist
-- Raw Olist transactional tables

CREATE TABLE IF NOT EXISTS raw.olist_order_items (
    order_id TEXT,
    order_item_id TEXT,
    product_id TEXT,
    seller_id TEXT,
    shipping_limit_date TEXT,
    price TEXT,
    freight_value TEXT
);

CREATE TABLE IF NOT EXISTS raw.olist_order_payments (
    order_id TEXT,
    payment_sequential TEXT,
    payment_type TEXT,
    payment_installments TEXT,
    payment_value TEXT
);

CREATE TABLE IF NOT EXISTS raw.olist_order_reviews (
    review_id TEXT,
    order_id TEXT,
    review_score TEXT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TEXT,
    review_answer_timestamp TEXT
);
