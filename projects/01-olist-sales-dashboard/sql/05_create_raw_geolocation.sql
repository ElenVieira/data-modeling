-- Tabela bruta de geolocalização da Olist
-- Raw Olist geolocation table

CREATE TABLE IF NOT EXISTS raw.olist_geolocation (
    geolocation_zip_code_prefix TEXT,
    geolocation_lat TEXT,
    geolocation_lng TEXT,
    geolocation_city TEXT,
    geolocation_state TEXT
);
