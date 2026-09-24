-- Fato analítica de pedidos
-- Analytical orders fact table

CREATE TABLE IF NOT EXISTS marts.fct_orders (
    order_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id TEXT NOT NULL UNIQUE,
    customer_key BIGINT NOT NULL
        REFERENCES marts.dim_customer (customer_key),

    purchase_date_key INTEGER NOT NULL
        REFERENCES marts.dim_date (date_key),
    approved_date_key INTEGER
        REFERENCES marts.dim_date (date_key),
    carrier_date_key INTEGER
        REFERENCES marts.dim_date (date_key),
    delivered_date_key INTEGER
        REFERENCES marts.dim_date (date_key),
    estimated_delivery_date_key INTEGER
        REFERENCES marts.dim_date (date_key),

    order_status TEXT NOT NULL,
    order_purchase_timestamp TIMESTAMP NOT NULL,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP,

    item_count INTEGER NOT NULL,
    order_product_value NUMERIC(14, 2) NOT NULL,
    order_freight_value NUMERIC(14, 2) NOT NULL,

    dispatch_days NUMERIC(10, 2),
    transit_days NUMERIC(10, 2),
    total_delivery_days NUMERIC(10, 2),
    is_delivered BOOLEAN NOT NULL,
    is_late BOOLEAN,

    CHECK (item_count >= 0),
    CHECK (order_product_value >= 0),
    CHECK (order_freight_value >= 0)
);
