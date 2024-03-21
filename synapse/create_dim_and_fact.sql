-- Creating Dimensional Model - Dims & Fact

-- 1. Customer
CREATE VIEW dbo.dim_customer AS
WITH cte_dim_customer AS (
SELECT *
FROM
    OPENROWSET(
    BULK '{URL đến file dữ liệu storage account}',
    FORMAT = 'PARQUET'
    ) AS [result]
)
SELECT *
FROM
    cte_dim_customer
GO

-- 2. Product
CREATE VIEW dbo.dim_product AS
WITH cte_dim_product AS (
SELECT *
FROM
    OPENROWSET(
    BULK '{URL đến file dữ liệu storage account}',
    FORMAT = 'PARQUET'
    ) AS [result]
)
SELECT *
FROM
    cte_dim_product
GO

-- 3. Sales Order
CREATE VIEW dbo.dim_sale_order AS
WITH cte_dim_sale_order AS (
SELECT *
FROM
    OPENROWSET(
    BULK '{URL đến file dữ liệu storage account}',
    FORMAT = 'PARQUET'
    ) AS [result]
)
SELECT *
FROM
    cte_dim_sale_order
GO

-- 4. Date
CREATE VIEW dbo.dim_date AS
WITH cte_dim_date AS (
SELECT *
FROM
    OPENROWSET(
    BULK '{URL đến file dữ liệu storage account}',
    FORMAT = 'PARQUET'
    ) AS [result]
)
SELECT *
FROM
    cte_dim_date
GO


-- 5. Fct Revenua
CREATE VIEW dbo.fact_revenua AS
WITH cte_fact_revenua AS (
SELECT
    DISTINCT CONCAT(r.id,dt.id) AS id,
    r.id as dim_sale_order_id,
    r.quantity as quantity,
    r.order_date as order_date,
    p.price as price,
    dt.id as dim_date_id
FROM
    OPENROWSET(
    BULK '{URL đến file dữ liệu storage account}',
    FORMAT = 'PARQUET'
    ) AS r
LEFT JOIN dbo.dim_product p
ON p.id=r.dim_product_id
LEFT JOIN dbo.dim_date dt
ON r.order_date=dt.date
WHERE dt.id IS NOT NULL
)
SELECT DISTINCT
    id,
    dim_sale_order_id,
    dim_date_id,
    (price * quantity) as revenua
FROM 
    cte_fact_revenua