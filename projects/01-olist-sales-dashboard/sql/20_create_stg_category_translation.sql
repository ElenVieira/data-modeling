-- Tradução das categorias de produtos
-- Product category translations

CREATE TABLE IF NOT EXISTS staging.stg_category_translation (
    product_category_name TEXT PRIMARY KEY,
    product_category_name_english TEXT NOT NULL
);
