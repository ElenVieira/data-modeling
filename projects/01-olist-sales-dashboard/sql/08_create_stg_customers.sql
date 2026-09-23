-- Clientes tratados para uso nas camadas analíticas
-- Cleaned customers for analytical layers

CREATE TABLE IF NOT EXISTS staging.stg_customers (
    customer_id TEXT PRIMARY KEY,
    customer_unique_id TEXT NOT NULL,
    customer_zip_code_prefix TEXT,
    customer_city TEXT NOT NULL,
    customer_state CHAR(2) NOT NULL
);
