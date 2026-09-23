-- Carga da camada raw para a staging de pagamentos
-- Load raw payments into the staging layer

BEGIN;

TRUNCATE TABLE staging.stg_order_payments;

INSERT INTO staging.stg_order_payments (
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
)
SELECT
    NULLIF(BTRIM(order_id), ''),
    NULLIF(BTRIM(payment_sequential), '')::INTEGER,
    LOWER(NULLIF(BTRIM(payment_type), '')),
    NULLIF(BTRIM(payment_installments), '')::INTEGER,
    NULLIF(BTRIM(payment_value), '')::NUMERIC(12, 2)
FROM raw.olist_order_payments
WHERE NULLIF(BTRIM(order_id), '') IS NOT NULL
  AND NULLIF(BTRIM(payment_sequential), '') IS NOT NULL
  AND NULLIF(BTRIM(payment_type), '') IS NOT NULL
  AND NULLIF(BTRIM(payment_installments), '') IS NOT NULL
  AND NULLIF(BTRIM(payment_value), '') IS NOT NULL;

COMMIT;
