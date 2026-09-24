-- Dimensão analítica de produtos
-- Analytical product dimension

CREATE TABLE IF NOT EXISTS marts.dim_product (
    product_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_id TEXT NOT NULL UNIQUE,
    product_category_name_pt TEXT NOT NULL,
    product_category_name_en TEXT NOT NULL,
    product_name_length INTEGER,
    product_description_length INTEGER,
    product_photos_qty INTEGER,
    product_weight_g INTEGER,
    product_length_cm INTEGER,
    product_height_cm INTEGER,
    product_width_cm INTEGER
);
