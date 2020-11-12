
SELECT 
    products.product_name,
    SUM((products.price * sales.count) - (products.price * sales.count * sales.discount)) as final_sum
FROM sales
LEFT JOIN products
ON sales.product_id = products.product_id 

GROUP BY products.product_name
ORDER BY final_sum DESC