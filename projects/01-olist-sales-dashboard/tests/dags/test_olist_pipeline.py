from airflow.models import DagBag


PIPELINE_DAGS = [
    "olist_initialize_database",
    "olist_create_raw_tables",
    "olist_load_raw",
    "olist_validate_raw",
    "olist_create_staging_tables",
    "olist_load_staging",
    "olist_create_marts_tables",
    "olist_load_marts",
    "olist_validate_marts",
]


def test_olist_pipeline_task_order():
    dag_bag = DagBag(
        dag_folder="/usr/local/airflow/dags",
        include_examples=False,
    )
    pipeline = dag_bag.dags.get("olist_pipeline")

    assert pipeline is not None

    expected_tasks = [
        f"trigger_{dag_id}" for dag_id in PIPELINE_DAGS
    ]

    assert set(pipeline.task_ids) == set(expected_tasks)

    for current_task, next_task in zip(
        expected_tasks,
        expected_tasks[1:],
    ):
        downstream_tasks = pipeline.get_task(
            current_task
        ).downstream_task_ids

        assert next_task in downstream_tasks
