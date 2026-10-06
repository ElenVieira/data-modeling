from airflow.providers.common.sql.operators.sql import SQLCheckOperator
from airflow.sdk import dag
from pendulum import datetime


MART_TABLES = [
    "dim_customer",
    "dim_product",
    "dim_seller",
    "dim_date",
    "fct_orders",
    "fct_sales_items",
    "fct_payments",
    "fct_reviews",
]


@dag(
    dag_id="olist_validate_marts",
    start_date=datetime(2026, 1, 1, tz="UTC"),
    schedule=None,
    catchup=False,
    tags=["olist", "data-quality"],
)
def olist_validate_marts():
    for table_name in MART_TABLES:
        SQLCheckOperator(
            task_id=f"check_{table_name}_not_empty",
            conn_id="olist_postgres",
            sql=f"SELECT COUNT(*) > 0 FROM marts.{table_name};",
        )


olist_validate_marts()
