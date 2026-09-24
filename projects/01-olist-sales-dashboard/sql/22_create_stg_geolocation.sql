-- Geolocalização consolidada por prefixo de CEP
-- Geolocation consolidated by ZIP code prefix

CREATE TABLE IF NOT EXISTS staging.stg_geolocation (
    geolocation_zip_code_prefix TEXT PRIMARY KEY,
    geolocation_lat NUMERIC(9, 6) NOT NULL,
    geolocation_lng NUMERIC(9, 6) NOT NULL,
    geolocation_city TEXT NOT NULL,
    geolocation_state CHAR(2) NOT NULL
);
