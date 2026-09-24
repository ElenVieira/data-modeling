-- Fato analítica de itens vendidos
-- Analytical sales items fact table

CREATE TABLE IF NOT EXISTS marts.fct_sales_items (
    sales_item_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_key BIGINT NOT NULL
        REFERENCES marts.fct_orders (order_key),
    order_item_id INTEGER NOT NULL,
    customer_key BIGINT NOT NULL
        REFERENCES marts.dim_customer (customer_key),
    product_key BIGINT NOT NULL
        REFERENCES marts.dim_product (product_key),
    seller_key BIGINT NOT NULL
        REFERENCES marts.dim_seller (seller_key),
    purchase_date_key INTEGER NOT NULL
        REFERENCES marts.dim_date (date_key),
    shipping_limit_date_key INTEGER
        REFERENCES marts.dim_date (date_key),

    shipping_limit_timestamp TIMESTAMP,
    price NUMERIC(12, 2) NOT NULL,
    freight_value NUMERIC(12, 2) NOT NULL,
    is_delivered BOOLEAN NOT NULL,

    UNIQUE (order_key, order_item_id),
    CHECK (price >= 0),
    CHECK (freight_value >= 0)
);
