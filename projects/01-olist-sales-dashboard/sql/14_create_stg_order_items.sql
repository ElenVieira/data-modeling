-- Itens de pedido tratados para uso nas camadas analíticas
-- Cleaned order items for analytical layers

CREATE TABLE IF NOT EXISTS staging.stg_order_items (
    order_id TEXT NOT NULL,
    order_item_id INTEGER NOT NULL,
    product_id TEXT NOT NULL,
    seller_id TEXT NOT NULL,
    shipping_limit_date TIMESTAMP,
    price NUMERIC(12, 2) NOT NULL,
    freight_value NUMERIC(12, 2) NOT NULL,

    PRIMARY KEY (order_id, order_item_id)
);
