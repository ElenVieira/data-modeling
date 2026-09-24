-- Carga da dimensão calendário
-- Load the calendar dimension

BEGIN;

WITH source_dates AS (
    SELECT order_purchase_timestamp::DATE AS event_date
    FROM staging.stg_orders

    UNION ALL

    SELECT order_approved_at::DATE
    FROM staging.stg_orders

    UNION ALL

    SELECT order_delivered_carrier_date::DATE
    FROM staging.stg_orders

    UNION ALL

    SELECT order_delivered_customer_date::DATE
    FROM staging.stg_orders

    UNION ALL

    SELECT order_estimated_delivery_date::DATE
    FROM staging.stg_orders

    UNION ALL

    SELECT shipping_limit_date::DATE
    FROM staging.stg_order_items

    UNION ALL

    SELECT review_creation_date::DATE
    FROM staging.stg_order_reviews

    UNION ALL

    SELECT review_answer_timestamp::DATE
    FROM staging.stg_order_reviews
),
date_bounds AS (
    SELECT
        MIN(event_date) AS minimum_date,
        MAX(event_date) AS maximum_date
    FROM source_dates
    WHERE event_date IS NOT NULL
),
calendar AS (
    SELECT
        GENERATE_SERIES(
            minimum_date,
            maximum_date,
            INTERVAL '1 day'
        )::DATE AS full_date
    FROM date_bounds
)
INSERT INTO marts.dim_date (
    date_key,
    full_date,
    day_of_month,
    day_of_week,
    week_of_year,
    month_number,
    quarter_number,
    year_number,
    year_month,
    is_weekend
)
SELECT
    TO_CHAR(full_date, 'YYYYMMDD')::INTEGER,
    full_date,
    EXTRACT(DAY FROM full_date)::SMALLINT,
    EXTRACT(ISODOW FROM full_date)::SMALLINT,
    EXTRACT(WEEK FROM full_date)::SMALLINT,
    EXTRACT(MONTH FROM full_date)::SMALLINT,
    EXTRACT(QUARTER FROM full_date)::SMALLINT,
    EXTRACT(YEAR FROM full_date)::SMALLINT,
    TO_CHAR(full_date, 'YYYY-MM'),
    EXTRACT(ISODOW FROM full_date) IN (6, 7)
FROM calendar
ON CONFLICT (date_key)
DO UPDATE SET
    full_date = EXCLUDED.full_date,
    day_of_month = EXCLUDED.day_of_month,
    day_of_week = EXCLUDED.day_of_week,
    week_of_year = EXCLUDED.week_of_year,
    month_number = EXCLUDED.month_number,
    quarter_number = EXCLUDED.quarter_number,
    year_number = EXCLUDED.year_number,
    year_month = EXCLUDED.year_month,
    is_weekend = EXCLUDED.is_weekend;

COMMIT;
