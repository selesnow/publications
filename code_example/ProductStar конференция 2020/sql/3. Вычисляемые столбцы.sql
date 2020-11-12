# ֲûקטסכÿולûו סעמכבצû

SELECT 
    sales.sale_id, 
    sales.date,
    products.price * sales.count as sale_sum,
    products.price * sales.count * sales.discount as discount_sum,
    (products.price * sales.count) - (products.price * sales.count * sales.discount) as final_sum
FROM sales
LEFT JOIN products
ON sales.product_id = products.product_id 