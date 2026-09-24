-- Fato analítica de pagamentos
-- Analytical payments fact table

CREATE TABLE IF NOT EXISTS marts.fct_payments (
    payment_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_key BIGINT NOT NULL
        REFERENCES marts.fct_orders (order_key),
    payment_sequential INTEGER NOT NULL,
    customer_key BIGINT NOT NULL
        REFERENCES marts.dim_customer (customer_key),
    purchase_date_key INTEGER NOT NULL
        REFERENCES marts.dim_date (date_key),

    payment_type TEXT NOT NULL,
    payment_installments INTEGER NOT NULL,
    payment_value NUMERIC(12, 2) NOT NULL,

    UNIQUE (order_key, payment_sequential),
    CHECK (payment_installments >= 0),
    CHECK (payment_value >= 0)
);
