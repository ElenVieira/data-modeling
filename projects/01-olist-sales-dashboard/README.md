# Olist Sales Dashboard | Dashboard de Vendas Olist

## Português

### Objetivo

Projeto de modelagem de dados e pipeline com Apache Airflow para analisar vendas, logística e satisfação de clientes usando dados públicos da Olist.

### Visões analíticas planejadas

- **Vendas:** receita de produtos, pedidos entregues, ticket médio, itens vendidos e categorias.
- **Logística e satisfação:** prazo de entrega, atrasos, status dos pedidos e avaliações.
- **Geográfica:** vendas, clientes, vendedores e desempenho logístico por estado.

### Tecnologias previstas

- PostgreSQL
- Apache Airflow
- Docker e Astro
- Power BI
- Azure Virtual Machine

---

## English

### Objective

A data modeling project and Apache Airflow pipeline to analyze sales, logistics, and customer satisfaction using public Olist data.

### Planned analytical views

- **Sales:** product revenue, delivered orders, average order value, items sold, and categories.
- **Logistics and satisfaction:** delivery time, delays, order status, and reviews.
- **Geographic:** sales, customers, sellers, and logistics performance by state.

### Planned technologies

- PostgreSQL
- Apache Airflow
- Docker and Astro
- Power BI
- Azure Virtual Machine

## Execução do pipeline | Pipeline execution

### Português

Antes da execução, os nove CSVs originais devem estar em `data/raw/` e a conexão `olist_postgres` deve estar configurada no arquivo `.env`.

Ordem dos DAGs:

1. `olist_initialize_database`
2. `olist_create_raw_tables`
3. `olist_load_raw`
4. `olist_validate_raw`
5. `olist_create_staging_tables`
6. `olist_load_staging`
7. `olist_create_marts_tables`
8. `olist_load_marts`

A camada `raw` preserva os dados originais, `staging` aplica tipagem e limpeza, e `marts` disponibiliza dimensões e fatos para análise.

### English

Before execution, the nine original CSV files must be available in `data/raw/`, and the `olist_postgres` connection must be configured in the `.env` file.

Run the DAGs in the order listed above. The `raw` layer preserves source data, `staging` applies typing and cleaning, and `marts` provides dimensions and facts for analytics.
