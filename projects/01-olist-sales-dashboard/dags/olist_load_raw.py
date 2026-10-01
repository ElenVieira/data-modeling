from pathlib import Path

from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.sdk import dag, task
from pendulum import datetime


DATA_DIR = Path("/usr/local/airflow/data/raw")

RAW_DATASETS = [
    {"file_name": "olist_orders_dataset.csv", "table_name": "raw.olist_orders"},
    {"file_name": "olist_customers_dataset.csv", "table_name": "raw.olist_customers"},
    {"file_name": "olist_products_dataset.csv", "table_name": "raw.olist_products"},
    {"file_name": "olist_sellers_dataset.csv", "table_name": "raw.olist_sellers"},
    {
        "file_name": "product_category_name_translation.csv",
        "table_name": "raw.product_category_name_translation",
    },
    {"file_name": "olist_order_items_dataset.csv", "table_name": "raw.olist_order_items"},
    {
        "file_name": "olist_order_payments_dataset.csv",
        "table_name": "raw.olist_order_payments",
    },
    {"file_name": "olist_order_reviews_dataset.csv", "table_name": "raw.olist_order_reviews"},
    {"file_name": "olist_geolocation_dataset.csv", "table_name": "raw.olist_geolocation"},
]


@dag(
    dag_id="olist_load_raw",
    start_date=datetime(2026, 1, 1, tz="UTC"),
    schedule=None,
    catchup=False,
    max_active_tasks=2,
    tags=["olist", "raw", "load"],
)
def olist_load_raw():

    @task
    def load_csv(file_name: str, table_name: str):
        file_path = DATA_DIR / file_name

        if not file_path.exists():
            raise FileNotFoundError(f"CSV not found: {file_path}")

        hook = PostgresHook(postgres_conn_id="olist_postgres")
        hook.run(f"TRUNCATE TABLE {table_name};")
        hook.copy_expert(
            sql=f"COPY {table_name} FROM STDIN WITH CSV HEADER",
            filename=str(file_path),
        )

        row_count = hook.get_first(f"SELECT COUNT(*) FROM {table_name};")[0]
        return {"table": table_name, "rows": row_count}

    load_csv.expand_kwargs(RAW_DATASETS)


olist_load_raw()

