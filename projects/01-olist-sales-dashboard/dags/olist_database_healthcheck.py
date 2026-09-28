from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.sdk import dag, task
from pendulum import datetime


@dag(
    dag_id="olist_database_healthcheck",
    start_date=datetime(2026, 1, 1, tz="UTC"),
    schedule=None,
    catchup=False,
    tags=["olist", "database", "healthcheck"],
)
def olist_database_healthcheck():

    @task
    def check_database_connection():
        hook = PostgresHook(postgres_conn_id="olist_postgres")
        result = hook.get_first("SELECT current_database();")

        if result[0] != "olist_dw":
            raise ValueError(f"Unexpected database: {result[0]}")

        return result[0]

    check_database_connection()


olist_database_healthcheck()
