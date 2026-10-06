from airflow.providers.standard.operators.trigger_dagrun import (
    TriggerDagRunOperator,
)
from airflow.sdk import dag
from pendulum import datetime


PIPELINE_DAGS = [
    "olist_initialize_database",
    "olist_create_raw_tables",
    "olist_load_raw",
    "olist_validate_raw",
    "olist_create_staging_tables",
    "olist_load_staging",
    "olist_create_marts_tables",
    "olist_load_marts",
]


@dag(
    dag_id="olist_pipeline",
    start_date=datetime(2026, 1, 1, tz="UTC"),
    schedule=None,
    catchup=False,
    tags=["olist", "orchestration"],
)
def olist_pipeline():
    previous_task = None

    for dag_id in PIPELINE_DAGS:
        current_task = TriggerDagRunOperator(
            task_id=f"trigger_{dag_id}",
            trigger_dag_id=dag_id,
            wait_for_completion=True,
            poke_interval=10,
            allowed_states=["success"],
            failed_states=["failed"],
        )

        if previous_task:
            previous_task >> current_task

        previous_task = current_task


olist_pipeline()
