-- Consolidação da geolocalização por prefixo de CEP
-- Consolidate geolocation by ZIP code prefix

BEGIN;

TRUNCATE TABLE staging.stg_geolocation;

INSERT INTO staging.stg_geolocation (
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
)
SELECT
    NULLIF(BTRIM(geolocation_zip_code_prefix), ''),
    PERCENTILE_CONT(0.5) WITHIN GROUP (
        ORDER BY NULLIF(BTRIM(geolocation_lat), '')::NUMERIC
    )::NUMERIC(9, 6),
    PERCENTILE_CONT(0.5) WITHIN GROUP (
        ORDER BY NULLIF(BTRIM(geolocation_lng), '')::NUMERIC
    )::NUMERIC(9, 6),
    MODE() WITHIN GROUP (
        ORDER BY LOWER(NULLIF(BTRIM(geolocation_city), ''))
    ),
    MODE() WITHIN GROUP (
        ORDER BY UPPER(NULLIF(BTRIM(geolocation_state), ''))
    )
FROM raw.olist_geolocation
WHERE NULLIF(BTRIM(geolocation_zip_code_prefix), '') IS NOT NULL
  AND BTRIM(geolocation_lat) ~ '^-?[0-9]+([.][0-9]+)?$'
  AND BTRIM(geolocation_lng) ~ '^-?[0-9]+([.][0-9]+)?$'
  AND NULLIF(BTRIM(geolocation_city), '') IS NOT NULL
  AND NULLIF(BTRIM(geolocation_state), '') IS NOT NULL
GROUP BY NULLIF(BTRIM(geolocation_zip_code_prefix), '');

COMMIT;
