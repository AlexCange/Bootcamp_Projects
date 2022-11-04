
-- STATUS
SELECT order_status, COUNT(order_id) AS "Qty Orders"
FROM orders
GROUP BY order_status;

-- CUSTOMERS 
 -- How many customers?
SELECT COUNT(distinct customer_id) FROM customers;

-- Amount of order / customer
SELECT customer_id, COUNT(order_id) FROM orders
GROUP BY customer_id
ORDER BY COUNT(*) DESC;

-- PRODUCTS
	-- Total of Products
SELECT COUNT(DISTINCT product_id)
FROM products;

	-- Category 
SELECT COUNT(DISTINCT product_category_name)
FROM products; 

	-- How many products in each category:
SELECT product_category_name_translation.product_category_name_english AS product_category, COUNT(product_id) AS "Total Count"
FROM products
LEFT JOIN product_category_name_translation USING(product_category_name)
GROUP BY products.product_category_name
ORDER BY COUNT(product_id) DESC;

	-- Which products were never/how many time sold?
SELECT p.product_id, COUNT(oi.order_id)
FROM products as p
JOIN order_items as oi
USING(product_id)
GROUP BY p.product_id
ORDER BY COUNT(oi.order_id) DESC;

	-- Price
    -- Most Expensive:
SELECT products.product_id, price, eng.product_category_name_english FROM order_items
JOIN products USING(product_id)
JOIN product_category_name_translation AS eng USING(product_category_name)
ORDER BY price DESC
LIMIT 30;
	-- Cheapest:
SELECT products.product_id, price, eng.product_category_name_english FROM order_items
JOIN products USING(product_id)
JOIN product_category_name_translation AS eng USING(product_category_name)
ORDER BY price 
LIMIT 100
;

SELECT * FROM products;
	
-- ORDERS:
	-- How many orders?
SELECT COUNT(*) AS "Total Amount Orders" FROM orders; 
SELECT * FROM orders;
	-- How many Items in an order :
SELECT order_id, COUNT(order_item_id) AS "Qty items" FROM order_items
GROUP BY order_id
ORDER BY COUNT(order_item_id) DESC;

	-- Orders Growth
SELECT 
    YEAR(order_purchase_timestamp) AS 'Year',
    MONTH(order_purchase_timestamp) AS 'Month',
    COUNT(*) AS 'Orders'
FROM
    orders
GROUP BY YEAR(order_purchase_timestamp) , MONTH(order_purchase_timestamp)
ORDER BY YEAR(order_purchase_timestamp) , MONTH(order_purchase_timestamp);

select *, count((order_purchase_timestamp)) from orders 
group by year(order_purchase_timestamp) 
order by year(order_purchase_timestamp),  month(order_purchase_timestamp) asc;


 -- FOR THE YEAR
SELECT 
    YEAR(order_purchase_timestamp) AS 'Year',
    COUNT(*) AS 'Orders'
FROM
    orders
GROUP BY YEAR(order_purchase_timestamp) 
ORDER BY YEAR(order_purchase_timestamp);

	-- Value of Orders :
    -- Highest
SELECT order_id, payment_value from order_payments
ORDER BY payment_value DESC
LIMIT 10;

SELECT AVG(payment_value) FROM order_payments;
	-- Lowest
SELECT order_id, payment_value from order_payments
ORDER BY payment_value;

SELECT COUNT(*)
FROM order_payments
WHERE payment_value = 0;
SELECT * FROM GEO;
SELECT price
FROM
    order_items
        JOIN
    products USING (product_id)
        JOIN
    product_category_name_translation AS eng USING (product_category_name)
WHERE product_category_name_english IN ('consoles_games' , 'cool_stuff',
    'electronics',
    'computer accessories',
    'pc_gamer',
    'computers',
    'security_and_services',
    'tablets_printing_image',
    'Telephony')
ORDER BY price DESC;