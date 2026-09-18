-- Camadas do projeto Olist | Olist project layers

-- Dados brutos recebidos da fonte
-- Raw data received from the source
CREATE SCHEMA IF NOT EXISTS raw;

-- Dados padronizados e validados
-- Standardized and validated data
CREATE SCHEMA IF NOT EXISTS staging;

-- Tabelas analíticas para consumo no dashboard
-- Analytical tables for dashboard consumption
CREATE SCHEMA IF NOT EXISTS marts;
