from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.sdk import dag, task
from pendulum import datetime


EXPECTED_ROWS = [
    {"table_name": "raw.olist_orders", "expected_rows": 99441},
    {"table_name": "raw.olist_customers", "expected_rows": 99441},
    {"table_name": "raw.olist_products", "expected_rows": 32951},
    {"table_name": "raw.olist_sellers", "expected_rows": 3095},
    {"table_name": "raw.product_category_name_translation", "expected_rows": 71},
    {"table_name": "raw.olist_order_items", "expected_rows": 112650},
    {"table_name": "raw.olist_order_payments", "expected_rows": 103886},
    {"table_name": "raw.olist_order_reviews", "expected_rows": 99224},
    {"table_name": "raw.olist_geolocation", "expected_rows": 1000163},
]


@dag(
    dag_id="olist_validate_raw",
    start_date=datetime(2026, 1, 1, tz="UTC"),
    schedule=None,
    catchup=False,
    tags=["olist", "raw", "quality"],
)
def olist_validate_raw():

    @task
    def validate_row_count(table_name: str, expected_rows: int):
        hook = PostgresHook(postgres_conn_id="olist_postgres")
        actual_rows = hook.get_first(f"SELECT COUNT(*) FROM {table_name};")[0]

        if actual_rows != expected_rows:
            raise ValueError(
                f"{table_name}: expected {expected_rows}, found {actual_rows}"
            )

        return {"table": table_name, "rows": actual_rows}

    validate_row_count.expand_kwargs(EXPECTED_ROWS)


olist_validate_raw()
