from pathlib import Path

from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from airflow.sdk import dag
from pendulum import datetime


SQL_DIR = Path("/usr/local/airflow/sql")

ANALYTICS_VIEW_SCRIPTS = [
    "40_create_sales_overview_view.sql",
    "41_create_logistics_overview_view.sql",
    "42_create_customer_satisfaction_view.sql",
]


@dag(
    dag_id="olist_create_analytics_views",
    start_date=datetime(2026, 1, 1, tz="UTC"),
    schedule=None,
    catchup=False,
    tags=["olist", "analytics", "setup"],
)
def olist_create_analytics_views():
    previous_task = None

    for script_name in ANALYTICS_VIEW_SCRIPTS:
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


olist_create_analytics_views()
