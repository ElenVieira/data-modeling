from pathlib import Path

from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from airflow.sdk import dag
from pendulum import datetime


SQL_DIR = Path("/usr/local/airflow/sql")

MARTS_TABLE_SCRIPTS = [
    "24_create_dim_customer.sql",
    "26_create_dim_product.sql",
    "28_create_dim_seller.sql",
    "30_create_dim_date.sql",
    "32_create_fct_orders.sql",
    "34_create_fct_sales_items.sql",
    "36_create_fct_payments.sql",
    "38_create_fct_reviews.sql",
]


@dag(
    dag_id="olist_create_marts_tables",
    start_date=datetime(2026, 1, 1, tz="UTC"),
    schedule=None,
    catchup=False,
    tags=["olist", "marts", "setup"],
)
def olist_create_marts_tables():
    previous_task = None

    for script_name in MARTS_TABLE_SCRIPTS:
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


olist_create_marts_tables()

