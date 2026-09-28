from pathlib import Path

from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from airflow.sdk import dag
from pendulum import datetime


SQL_DIR = Path("/usr/local/airflow/sql")


@dag(
    dag_id="olist_initialize_database",
    start_date=datetime(2026, 1, 1, tz="UTC"),
    schedule=None,
    catchup=False,
    tags=["olist", "database", "setup"],
)
def olist_initialize_database():

    SQLExecuteQueryOperator(
        task_id="create_schemas",
        conn_id="olist_postgres",
        sql=(SQL_DIR / "01_create_schemas.sql").read_text(encoding="utf-8"),
        split_statements=True,
        autocommit=True,
    )


olist_initialize_database()
