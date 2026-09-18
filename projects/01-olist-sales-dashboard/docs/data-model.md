# Modelo de Dados | Data Model

## Português

### Arquitetura em camadas

- **raw:** cópia dos dados originais recebidos da fonte.
- **staging:** dados com tipos ajustados, nomes padronizados e validações aplicadas.
- **marts:** tabelas analíticas preparadas para o dashboard.

### Tabelas analíticas

| Tabela | Granularidade | Descrição |
|---|---|---|
| `fct_orders` | Uma linha por pedido | Status, datas de compra e entrega, cliente e métricas do pedido. |
| `fct_sales_items` | Uma linha por item do pedido | Produto, vendedor, preço e frete. |
| `fct_payments` | Uma linha por pagamento | Método, parcelas e valor do pagamento. |
| `fct_reviews` | Uma linha por avaliação | Nota, comentário e datas da avaliação. |
| `dim_customer` | Uma linha por contexto de cliente | Cliente, cidade e estado de entrega. |
| `dim_product` | Uma linha por produto | Categoria e atributos físicos do produto. |
| `dim_seller` | Uma linha por vendedor | Cidade e estado do vendedor. |
| `dim_date` | Uma linha por dia | Calendário para análises temporais. |

### Regras de negócio iniciais

- Receita realizada considera apenas pedidos com status `delivered`.
- Receita de produtos é calculada pela soma de `order_items.price`.
- O frete é analisado separadamente como métrica logística.
- A data da venda é `order_purchase_timestamp`.

---

## English

### Layered architecture

- **raw:** copy of the original data received from the source.
- **staging:** data with adjusted types, standardized names, and applied validations.
- **marts:** analytical tables prepared for the dashboard.

### Analytical tables

| Table | Grain | Description |
|---|---|---|
| `fct_orders` | One row per order | Status, purchase and delivery dates, customer, and order metrics. |
| `fct_sales_items` | One row per order item | Product, seller, price, and freight. |
| `fct_payments` | One row per payment | Payment method, installments, and payment amount. |
| `fct_reviews` | One row per review | Score, comment, and review dates. |
| `dim_customer` | One row per customer context | Customer, delivery city, and state. |
| `dim_product` | One row per product | Category and physical product attributes. |
| `dim_seller` | One row per seller | Seller city and state. |
| `dim_date` | One row per day | Calendar for time-based analysis. |

### Initial business rules

- Realized revenue includes only orders with `delivered` status.
- Product revenue is calculated as the sum of `order_items.price`.
- Freight is analyzed separately as a logistics metric.
- The sales date is `order_purchase_timestamp`.
