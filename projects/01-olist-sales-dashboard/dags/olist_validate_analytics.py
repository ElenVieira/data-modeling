from airflow.providers.common.sql.operators.sql import SQLCheckOperator
from airflow.sdk import dag
from pendulum import datetime


ANALYTICS_VIEWS = [
    "vw_sales_overview",
    "vw_logistics_overview",
    "vw_customer_satisfaction",
]


@dag(
    dag_id="olist_validate_analytics",
    start_date=datetime(2026, 1, 1, tz="UTC"),
    schedule=None,
    catchup=False,
    tags=["olist", "analytics", "data-quality"],
)
def olist_validate_analytics():
    for view_name in ANALYTICS_VIEWS:
        SQLCheckOperator(
            task_id=f"check_{view_name}_not_empty",
            conn_id="olist_postgres",
            sql=f"SELECT COUNT(*) > 0 FROM analytics.{view_name};",
        )


olist_validate_analytics()
