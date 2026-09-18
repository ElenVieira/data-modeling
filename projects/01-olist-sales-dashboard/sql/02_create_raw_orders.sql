-- Tabela bruta de pedidos recebidos da Olist
-- Raw orders table received from Olist

CREATE TABLE IF NOT EXISTS raw.olist_orders (
    order_id TEXT,
    customer_id TEXT,
    order_status TEXT,
    order_purchase_timestamp TEXT,
    order_approved_at TEXT,
    order_delivered_carrier_date TEXT,
    order_delivered_customer_date TEXT,
    order_estimated_delivery_date TEXT
);
