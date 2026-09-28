from pathlib import Path

from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from airflow.sdk import dag
from pendulum import datetime


SQL_DIR = Path("/usr/local/airflow/sql")

RAW_TABLE_SCRIPTS = [
    "02_create_raw_orders.sql",
    "03_create_raw_reference_tables.sql",
    "04_create_raw_transaction_tables.sql",
    "05_create_raw_geolocation.sql",
]


@dag(
    dag_id="olist_create_raw_tables",
    start_date=datetime(2026, 1, 1, tz="UTC"),
    schedule=None,
    catchup=False,
    tags=["olist", "raw", "setup"],
)
def olist_create_raw_tables():
    previous_task = None

    for script_name in RAW_TABLE_SCRIPTS:
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


olist_create_raw_tables()
