-- Pagamentos tratados para uso nas camadas analíticas
-- Cleaned payments for analytical layers

CREATE TABLE IF NOT EXISTS staging.stg_order_payments (
    order_id TEXT NOT NULL,
    payment_sequential INTEGER NOT NULL,
    payment_type TEXT NOT NULL,
    payment_installments INTEGER NOT NULL,
    payment_value NUMERIC(12, 2) NOT NULL,

    PRIMARY KEY (order_id, payment_sequential)
);
