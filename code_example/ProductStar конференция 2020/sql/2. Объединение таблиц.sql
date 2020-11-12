# Объединение таблиц

SELECT *
FROM sales
LEFT JOIN products
ON sales.product_id = products.product_id 