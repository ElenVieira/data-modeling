from pathlib import Path

from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from airflow.sdk import dag
from pendulum import datetime


SQL_DIR = Path("/usr/local/airflow/sql")

MARTS_LOAD_SCRIPTS = [
    "25_load_dim_customer.sql",
    "27_load_dim_product.sql",
    "29_load_dim_seller.sql",
    "31_load_dim_date.sql",
    "33_load_fct_orders.sql",
    "35_load_fct_sales_items.sql",
    "37_load_fct_payments.sql",
    "39_load_fct_reviews.sql",
]


@dag(
    dag_id="olist_load_marts",
    start_date=datetime(2026, 1, 1, tz="UTC"),
    schedule=None,
    catchup=False,
    tags=["olist", "marts", "transform"],
)
def olist_load_marts():
    previous_task = None

    for script_name in MARTS_LOAD_SCRIPTS:
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


olist_load_marts()
