-- Dimensão analítica de vendedores
-- Analytical seller dimension

CREATE TABLE IF NOT EXISTS marts.dim_seller (
    seller_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    seller_id TEXT NOT NULL UNIQUE,
    seller_zip_code_prefix TEXT,
    seller_city TEXT NOT NULL,
    seller_state CHAR(2) NOT NULL,
    seller_lat NUMERIC(9, 6),
    seller_lng NUMERIC(9, 6)
);
