-- Vendedores tratados para uso nas camadas analíticas
-- Cleaned sellers for analytical layers

CREATE TABLE IF NOT EXISTS staging.stg_sellers (
    seller_id TEXT PRIMARY KEY,
    seller_zip_code_prefix TEXT,
    seller_city TEXT NOT NULL,
    seller_state CHAR(2) NOT NULL
);
