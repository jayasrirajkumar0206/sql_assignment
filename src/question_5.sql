CREATE TABLE sales_data (
    productid INT,
    sale_date DATE,
    quantity_sold INT
);


INSERT INTO sales_data VALUES
(1, '2022-01-01', 20),
(2, '2022-01-01', 15),
(1, '2022-01-02', 10),
(2, '2022-01-02', 25),
(1, '2022-01-03', 30),
(2, '2022-01-03', 18),
(1, '2022-01-04', 12),
(2, '2022-01-04', 22);

SELECT
    productid,
    sale_date,
    quantity_sold,
    RANK() OVER (
        PARTITION BY productid
        ORDER BY sale_date DESC
    ) AS rnk
FROM sales_data;


SELECT *
FROM (
    SELECT *,
           RANK() OVER (
               PARTITION BY productid
               ORDER BY sale_date DESC
           ) AS rnk
    FROM sales_data
) t
WHERE rnk = 1;

SELECT
    productid,
    sale_date,
    quantity_sold,
    LAG(quantity_sold) OVER (
        PARTITION BY productid
        ORDER BY sale_date
    ) AS prev_quantity,
    quantity_sold - LAG(quantity_sold) OVER (
        PARTITION BY productid
        ORDER BY sale_date
    ) AS difference
FROM sales_data;

SELECT
    productid,
    sale_date,
    quantity_sold,
    FIRST_VALUE(quantity_sold) OVER (
        PARTITION BY productid
        ORDER BY sale_date
    ) AS first_quantity,
    LAST_VALUE(quantity_sold) OVER (
        PARTITION BY productid
        ORDER BY sale_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS last_quantity
FROM sales_data;
