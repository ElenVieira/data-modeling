-- Carga da dimensão de vendedores
-- Load the seller dimension

BEGIN;

INSERT INTO marts.dim_seller (
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state,
    seller_lat,
    seller_lng
)
SELECT
    seller.seller_id,
    seller.seller_zip_code_prefix,
    seller.seller_city,
    seller.seller_state,
    geolocation.geolocation_lat,
    geolocation.geolocation_lng
FROM staging.stg_sellers AS seller
LEFT JOIN staging.stg_geolocation AS geolocation
    ON seller.seller_zip_code_prefix =
       geolocation.geolocation_zip_code_prefix
ON CONFLICT (seller_id)
DO UPDATE SET
    seller_zip_code_prefix = EXCLUDED.seller_zip_code_prefix,
    seller_city = EXCLUDED.seller_city,
    seller_state = EXCLUDED.seller_state,
    seller_lat = EXCLUDED.seller_lat,
    seller_lng = EXCLUDED.seller_lng;

COMMIT;
