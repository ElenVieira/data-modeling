-- Carga da fato de pagamentos
-- Load the payments fact table

BEGIN;

INSERT INTO marts.fct_payments (
    order_key,
    payment_sequential,
    customer_key,
    purchase_date_key,
    payment_type,
    payment_installments,
    payment_value
)
SELECT
    order_fact.order_key,
    payment.payment_sequential,
    order_fact.customer_key,
    order_fact.purchase_date_key,
    payment.payment_type,
    payment.payment_installments,
    payment.payment_value
FROM staging.stg_order_payments AS payment
JOIN marts.fct_orders AS order_fact
    ON payment.order_id = order_fact.order_id
ON CONFLICT (order_key, payment_sequential)
DO UPDATE SET
    customer_key = EXCLUDED.customer_key,
    purchase_date_key = EXCLUDED.purchase_date_key,
    payment_type = EXCLUDED.payment_type,
    payment_installments = EXCLUDED.payment_installments,
    payment_value = EXCLUDED.payment_value;

COMMIT;
