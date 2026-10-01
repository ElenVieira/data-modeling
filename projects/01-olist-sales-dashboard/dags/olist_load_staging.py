from pathlib import Path

from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from airflow.sdk import dag
from pendulum import datetime


SQL_DIR = Path("/usr/local/airflow/sql")

STAGING_LOAD_SCRIPTS = [
    "07_load_stg_orders.sql",
    "09_load_stg_customers.sql",
    "11_load_stg_products.sql",
    "13_load_stg_sellers.sql",
    "15_load_stg_order_items.sql",
    "17_load_stg_order_payments.sql",
    "19_load_stg_order_reviews.sql",
    "21_load_stg_category_translation.sql",
    "23_load_stg_geolocation.sql",
]


@dag(
    dag_id="olist_load_staging",
    start_date=datetime(2026, 1, 1, tz="UTC"),
    schedule=None,
    catchup=False,
    tags=["olist", "staging", "transform"],
)
def olist_load_staging():
    previous_task = None

    for script_name in STAGING_LOAD_SCRIPTS:
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


olist_load_staging()
