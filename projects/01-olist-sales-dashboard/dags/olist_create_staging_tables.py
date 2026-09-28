from pathlib import Path

from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from airflow.sdk import dag
from pendulum import datetime


SQL_DIR = Path("/usr/local/airflow/sql")

STAGING_TABLE_SCRIPTS = [
    "06_create_stg_orders.sql",
    "08_create_stg_customers.sql",
    "10_create_stg_products.sql",
    "12_create_stg_sellers.sql",
    "14_create_stg_order_items.sql",
    "16_create_stg_order_payments.sql",
    "18_create_stg_order_reviews.sql",
    "20_create_stg_category_translation.sql",
    "22_create_stg_geolocation.sql",
]


@dag(
    dag_id="olist_create_staging_tables",
    start_date=datetime(2026, 1, 1, tz="UTC"),
    schedule=None,
    catchup=False,
    tags=["olist", "staging", "setup"],
)
def olist_create_staging_tables():
    previous_task = None

    for script_name in STAGING_TABLE_SCRIPTS:
        current_task = SQLExecuteQueryOperator(
            task_id=f"run_{script_name.removesuffix('.sql')}",
            conn_id="olist_postgres",
            sql=(SQL_DIR / script_name).read_text(encoding="utf-8"),
            split_statements=True,
            autocommit=True,
        )

        if previous_task:
            previous_task >> current_task

        previous_task = current_task


olist_create_staging_tables()
