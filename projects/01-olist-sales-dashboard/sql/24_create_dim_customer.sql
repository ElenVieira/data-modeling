-- Dimensão analítica de clientes
-- Analytical customer dimension

CREATE TABLE IF NOT EXISTS marts.dim_customer (
    customer_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id TEXT NOT NULL UNIQUE,
    customer_unique_id TEXT NOT NULL,
    customer_zip_code_prefix TEXT,
    customer_city TEXT NOT NULL,
    customer_state CHAR(2) NOT NULL,
    customer_lat NUMERIC(9, 6),
    customer_lng NUMERIC(9, 6)
);
