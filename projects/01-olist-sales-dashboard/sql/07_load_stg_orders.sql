-- Carga da camada raw para a staging de pedidos
-- Load raw orders into the staging layer

-- Atualização completa: evita duplicar dados ao reexecutar o processo.
-- Full refresh: prevents duplicate data when the process is rerun.
TRUNCATE TABLE staging.stg_orders;

INSERT INTO staging.stg_orders (
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
)
SELECT
    NULLIF(BTRIM(order_id), ''),
    NULLIF(BTRIM(customer_id), ''),
    LOWER(NULLIF(BTRIM(order_status), '')),
    NULLIF(BTRIM(order_purchase_timestamp), '')::TIMESTAMP,
    NULLIF(BTRIM(order_approved_at), '')::TIMESTAMP,
    NULLIF(BTRIM(order_delivered_carrier_date), '')::TIMESTAMP,
    NULLIF(BTRIM(order_delivered_customer_date), '')::TIMESTAMP,
    NULLIF(BTRIM(order_estimated_delivery_date), '')::TIMESTAMP
FROM raw.olist_orders
WHERE NULLIF(BTRIM(order_id), '') IS NOT NULL
  AND NULLIF(BTRIM(customer_id), '') IS NOT NULL
  AND NULLIF(BTRIM(order_status), '') IS NOT NULL
  AND NULLIF(BTRIM(order_purchase_timestamp), '') IS NOT NULL;
