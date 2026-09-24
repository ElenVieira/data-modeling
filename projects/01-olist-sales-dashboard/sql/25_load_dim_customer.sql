-- Carga da dimensão de clientes
-- Load the customer dimension

BEGIN;

INSERT INTO marts.dim_customer (
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state,
    customer_lat,
    customer_lng
)
SELECT
    customer.customer_id,
    customer.customer_unique_id,
    customer.customer_zip_code_prefix,
    customer.customer_city,
    customer.customer_state,
    geolocation.geolocation_lat,
    geolocation.geolocation_lng
FROM staging.stg_customers AS customer
LEFT JOIN staging.stg_geolocation AS geolocation
    ON customer.customer_zip_code_prefix =
       geolocation.geolocation_zip_code_prefix
ON CONFLICT (customer_id)
DO UPDATE SET
    customer_unique_id = EXCLUDED.customer_unique_id,
    customer_zip_code_prefix = EXCLUDED.customer_zip_code_prefix,
    customer_city = EXCLUDED.customer_city,
    customer_state = EXCLUDED.customer_state,
    customer_lat = EXCLUDED.customer_lat,
    customer_lng = EXCLUDED.customer_lng;

COMMIT;
