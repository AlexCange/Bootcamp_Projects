
-- PRODUCT RELATED :


	-- What categories of tech products does Magist have?
SELECT DISTINCT
    (product_category_name_english)
FROM
    product_category_name_translation;
    SELECT * FROM products;
				-- "audio", "computers", "pc_gamer", "security_and_services", "consoles_games", 
                -- "computers_accessories", "tablets_printing_image", "telephony", "electronics"

	-- How many products of these tech categories have been sold (within the time window of the database snapshot)? 
SELECT 
    eng.product_category_name_english AS "Category",
    COUNT(oi.order_item_id) AS "Quantity"
FROM
    products AS p
        JOIN
    order_items AS oi USING (product_id)
        JOIN
    product_category_name_translation AS eng USING (product_category_name)
GROUP BY product_category_name
HAVING 
	product_category_name_english 
		IN ("audio", "computers", "pc_gamer", "security_and_services", "consoles_games", "computers_accessories", "tablets_printing_image", "telephony", "electronics")
ORDER BY COUNT(oi.order_item_id) DESC
;

SELECT 
    pt.product_category_name_english AS 'category',
    COUNT(DISTINCT p.product_id) AS 'product_count',
    ROUND(COUNT(oi.order_id) / 112650 * 100, 2) AS '%_of_total'
FROM
    order_items AS oi
        JOIN
    products AS p USING (product_id)
        JOIN
    product_category_name_translation AS pt ON p.product_category_name = pt.product_category_name
WHERE
    pt.product_category_name_english IN (
		'audio' , 'computers_accessories', 'telephony', 'electronics', 'consoles_games',
        'signaling_and_security','computers','pc_gamer','watches_gifts')
GROUP BY p.product_category_name
ORDER BY COUNT(DISTINCT p.product_id) DESC;

SELECT count(*) FROM order_items;

	-- What’s the average price of the products being sold?
		-- From tech products
SELECT 
    eng.product_category_name_english,
    ROUND(AVG(price), 2) AS 'AVG Price'
FROM
    order_items
        JOIN
    products USING (product_id)
        JOIN
    product_category_name_translation AS eng USING (product_category_name)
GROUP BY products.product_category_name
HAVING 
	product_category_name_english IN (
    'audio' , 'computers','pc_gamer','security_and_services','consoles_games',
    'computers_accessories','tablets_printing_image','electronics'
    )
ORDER BY AVG(price) DESC;


			-- From all products 
SELECT 
    ROUND(AVG(price), 2) AS 'AVG Price'
FROM
    order_items;

-- COUNT ITEM / CAT / SUM PRICE 
		
SELECT 
	eng.product_category_name_english "CATEGORY",
    COUNT(p.product_id) "TOTAL PRODUCTS SOLD",
    ROUND(SUM(oi.price), 2) "TOTAL REVENUE"
FROM
    products AS p
        JOIN
    product_category_name_translation AS eng USING (product_category_name)
        JOIN
    order_items AS oi USING (product_id)
GROUP BY eng.product_category_name_english
ORDER BY ROUND(SUM(oi.price), 2) DESC;

			-- How many products > 500
SELECT 
    eng.product_category_name_english AS 'Category',
    COUNT(p.product_id) AS 'Total Items',
    ROUND(AVG(oi.price), 2) 'Average Price'
FROM
    products AS p
        JOIN
    product_category_name_translation AS eng USING (product_category_name)
        JOIN
    order_items AS oi USING (product_id)
WHERE
    product_category_name_english IN (
    'audio' , 'computers','pc_gamer','security_and_services','consoles_games',
    'computers_accessories','tablets_printing_image','electronics')
        AND price > 500
GROUP BY eng.product_category_name_english
ORDER BY COUNT(p.product_id) DESC
;

			-- How many products > 1000
SELECT 
    eng.product_category_name_english AS 'Category',
    COUNT(p.product_id) AS 'Total Items',
    ROUND(AVG(oi.price), 2) 'Average Price'
FROM
    products AS p
        JOIN
    product_category_name_translation AS eng USING (product_category_name)
        JOIN
    order_items AS oi USING (product_id)
WHERE
    product_category_name_english IN (
    'audio' , 'computers','pc_gamer','security_and_services','consoles_games',
    'computers_accessories','tablets_printing_image','electronics')
        AND price > 1000
GROUP BY eng.product_category_name_english
ORDER BY COUNT(p.product_id) DESC;


		-- PRICE CATEGORY FOR TECH
SELECT 
	eng.product_category_name_english AS "Category", 
    COUNT(p.product_id) AS "Total Items", 
    ROUND(AVG(oi.price),2)"Average Price",
	CASE 
		WHEN ROUND(AVG(oi.price)) >= 1000 THEN "Expensive"
        WHEN ROUND(AVG(oi.price)) >= 300 THEN "Medium"
        ELSE "Low"
	END AS "Price Category"
FROM products AS p
JOIN product_category_name_translation AS eng 
	USING(product_category_name)
JOIN order_items AS oi 
	USING(product_id)
GROUP BY eng.product_category_name_english
HAVING product_category_name_english IN ("audio", "computers", "pc_gamer", "security_and_services", "consoles_games", "computers_accessories", "tablets_printing_image", "telephony", "electronics")
ORDER BY COUNT(p.product_id) DESC;



-- SELLERS RELATED:



	-- How many months are included in database?
SELECT 
    YEAR(order_purchase_timestamp) AS 'Year',
    COUNT(distinct MONTH(order_purchase_timestamp)) AS "Total Months"
FROM
    orders
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY YEAR(order_purchase_timestamp);


		-- How many Sellers ?
SELECT COUNT(*) FROM sellers; 

			-- In Tech 
SELECT 
	eng.product_category_name_english,
    COUNT(distinct s.seller_id) AS "Total_Sellers"
FROM order_items AS oi
	JOIN 
		products AS p USING(product_id)
    JOIN 
		product_category_name_translation AS eng USING (product_category_name) 
    JOIN 
		sellers AS s USING(seller_id)
GROUP BY product_category_name_english
HAVING product_category_name_english IN (
	"audio", "computers", "pc_gamer", "security_and_services", "consoles_games", 
    "computers_accessories", "tablets_printing_image", "telephony", "electronics"
)
ORDER BY COUNT(distinct s.seller_id) DESC;





		-- Amount earned from Tech companies

SELECT 
    COUNT(DISTINCT seller_id) "Total Sellers", 
    ROUND(SUM(payment_value), 2) "Total Revenue"
FROM
    sellers
        JOIN
    order_items USING (seller_id)
        JOIN
    order_payments USING (order_id)
        JOIN
    products USING (product_id)
        JOIN
    product_category_name_translation USING (product_category_name)
WHERE
    product_category_name_english IN (
    "audio", "computers", "pc_gamer", "security_and_services", "consoles_games", 
    "computers_accessories", "tablets_printing_image", "telephony", "electronics"
);
        
-- In total: 
SELECT ROUND(SUM(payment_value),2) FROM order_payments;









-- Monthly income of all sellers

SELECT 
    -- oi.seller_id AS "seller ID", 
    eng.product_category_name_english AS "Category",
    COUNT(DISTINCT seller_id) AS "Amount of Sellers",
	MONTH(orders.order_purchase_timestamp) AS "Month",
    YEAR(orders.order_purchase_timestamp) AS "Year",
    ROUND(SUM(oi.price),2) AS "Monthly Total Incomes", 
    ROUND(AVG(price),2) AS "AVG Products Price"
FROM order_items as oi
JOIN sellers USING(seller_id)
JOIN orders USING(order_id)
JOIN products USING(product_id)
JOIN product_category_name_translation AS eng USING(product_category_name)
GROUP BY 
	-- oi.seller_id, 
	YEAR(orders.order_purchase_timestamp), 
	MONTH(orders.order_purchase_timestamp),
	eng.product_category_name_english
ORDER BY 
	eng.product_category_name_english,
	YEAR(orders.order_purchase_timestamp), 
	MONTH(orders.order_purchase_timestamp);

SELECT SUM(payment_value) FROM order_payments
JOIN orders USING(order_id)
JOIN order_items USING(order_id)
JOIN products USING(product_id)
JOIN product_category_name_translation USING(product_category_name)
WHERE product_category_name_english IN 
	("audio", "computers", "pc_gamer", "security_and_services", "consoles_games", 
	"computers_accessories", "tablets_printing_image", "telephony", "electronics");









-- AVG / seller : All Sellers
SELECT 
    oi.seller_id AS "seller ID", 
    ROUND(avg(oi.price),2) AS "Average Incomes",
    MONTH(orders.order_purchase_timestamp),
	eng.product_category_name_english AS "Category"
FROM order_items as oi
JOIN orders USING(order_id)
JOIN products USING(product_id)
JOIN product_category_name_translation AS eng USING(product_category_name)
GROUP BY oi.seller_id,MONTH(orders.order_purchase_timestamp);

-- AVG / Category : Tech Sellers
SELECT 
	eng.product_category_name_english AS "Category", 
    ROUND(avg(oi.price),2) AS "Monthly Average Incomes"
FROM order_items as oi
JOIN orders USING(order_id)
JOIN products USING(product_id)
JOIN product_category_name_translation AS eng USING(product_category_name)
GROUP BY eng.product_category_name_english
HAVING product_category_name_english IN (
	"audio", "computers", "pc_gamer", "security_and_services", "consoles_games", 
	"computers_accessories", "tablets_printing_image", "telephony", "electronics")
;
SELECT AVG(price) FROM order_items;

SELECT AVG(price) FROM order_items;


-- Delivery time:
-- AVG delivery time for all
SELECT ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)),2) FROM orders;
SELECT ROUND(AVG(DATEDIFF(order_delivered_carrier_date, order_purchase_timestamp)),2) FROM orders;
SELECT ROUND(AVG(DATEDIFF(order_delivered_carrier_date, order_approved_at)),2) FROM orders;
SELECT ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_delivered_carrier_date)),2) FROM orders;
SELECT ROUND(AVG(DATEDIFF(order_delivered_customer_date,order_estimated_delivery_date )),2) FROM orders;
SELECT ROUND(AVG(DATEDIFF(order_estimated_delivery_date, order_purchase_timestamp)),2) FROM orders;

SELECT order_purchase_timestamp, order_delivered_customer_date, order_estimated_delivery_date FROM orders;
SELECT * FROM orders;

-- AVG delivery time for Tech
SELECT eng.product_category_name_english AS "Category",
CASE 
	WHEN order_status = "delivered" THEN ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)),3)
    ELSE "Not delivered"
END AS "Day count"
FROM orders
JOIN order_items USING(order_id)
JOIN products USING(product_id)
JOIN product_category_name_translation AS eng USING(product_category_name)
GROUP BY eng.product_category_name_english
HAVING product_category_name_english IN (
	"audio", "computers", "pc_gamer", "security_and_services", "consoles_games", 
	"computers_accessories", "tablets_printing_image", "telephony", "electronics");
    
    
-- AVG Time difference between estimated and delivered

SELECT 
	eng.product_category_name_english AS "Category", 
CASE 
	WHEN order_status = "delivered" THEN ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date)),3)
    ELSE "Not delivered"
END AS "Day count"
FROM orders
JOIN order_items USING(order_id)
JOIN products USING(product_id)
JOIN product_category_name_translation AS eng USING(product_category_name)
GROUP BY eng.product_category_name_english
HAVING product_category_name_english IN (
	"audio", "computers", "pc_gamer", "security_and_services", "consoles_games", 
	"computers_accessories", "tablets_printing_image", "telephony", "electronics");
    
    
-- Time for Carriers

SELECT 
	eng.product_category_name_english AS "Category", 
CASE 
	WHEN order_status = "delivered" THEN ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_delivered_carrier_date)),3)
END AS "Day count"
FROM orders
JOIN order_items USING(order_id)
JOIN products USING(product_id)
JOIN product_category_name_translation AS eng USING(product_category_name)
GROUP BY eng.product_category_name_english
HAVING product_category_name_english IN (
	"audio", "computers", "pc_gamer", "security_and_services", "consoles_games", 
	"computers_accessories", "tablets_printing_image", "telephony", "electronics");
    
-- Internal Magist Time
SELECT 
CASE 
	WHEN order_status = "delivered" THEN ROUND(AVG(DATEDIFF(order_delivered_carrier_date, order_purchase_timestamp)),3)
END AS "Day count"
FROM orders
JOIN order_items USING(order_id)
JOIN products USING(product_id)
JOIN product_category_name_translation AS eng USING(product_category_name)
GROUP BY eng.product_category_name_english
HAVING product_category_name_english IN (
	"audio", "computers", "pc_gamer", "security_and_services", "consoles_games", 
	"computers_accessories", "tablets_printing_image", "telephony", "electronics");




SELECT * FROM order_reviews;


		-- ARE PACKAGES DELAYED IN TECH CATEGORIES ?
SELECT 
    CASE
        WHEN
            DATEDIFF(order_delivered_customer_date,
                    order_estimated_delivery_date) >= 0
        THEN
            'deleyed'
        ELSE 'Ontime'
    END AS 'duration',
    COUNT('duration') AS num
FROM
    orders
JOIN order_items USING(order_id)
JOIN products USING(product_id)
JOIN product_category_name_translation USING(product_category_name)
WHERE
    product_category_name_english IN ('audio' , 'computers',
        'pc_gamer',
        'security_and_services',
        'consoles_games',
        'computers_accessories',
        'tablets_printing_image',
        'telephony',
        'electronics')
GROUP BY duration;


		-- ARE DELAYED ORDERS HAVING PATTERNS?
SELECT 
	CASE
			WHEN
				DATEDIFF(order_delivered_customer_date,
						order_estimated_delivery_date) >= 0
			THEN
				'deleyed'
			ELSE 'Ontime'
		END AS 'duration',
    CASE
			WHEN 
				products.product_weight_g > 4000 THEN 'Heavy'
			WHEN 
				products.product_length_cm > 50 THEN 'Long'
			WHEN 
				products.product_width_cm > 50 THEN 'Wide'
			ELSE "No Patterns"
		END AS 'Patterns',
    COUNT('Patterns') AS "Amount Products"
FROM
    orders
        JOIN
    order_items USING (order_id)
        JOIN
    products USING (product_id)
        JOIN
    product_category_name_translation USING (product_category_name)
WHERE
    product_category_name_english IN ('audio' , 'computers',
        'pc_gamer',
        'security_and_services',
        'consoles_games',
        'computers_accessories',
        'tablets_printing_image',
        'telephony',
        'electronics') 
	AND 
    'Patterns' != "No Patterns"
GROUP BY  duration,
    CASE
       WHEN 
			products.product_weight_g > 4000 THEN 'Heavy'
        WHEN 
			products.product_length_cm > 30 THEN 'Long'
        WHEN 
			products.product_width_cm > 30 THEN 'Wide'
		ELSE "No Patterns"
    END;




SELECT AVG(review_score) FROM order_reviews;

SELECT COUNT(*) FROM order_reviews;




-- SUMMARY OF KEY INFOS 




SELECT 
product_category_name_translation.product_category_name_english AS "Category", 
COUNT(distinct seller_id) "Sellers", 
COUNT(order_id) "Item Ordered",
COUNT(product_id) "Products",
ROUND(AVG(order_items.price),2) "AVG item Price",
CASE 
		WHEN ROUND(AVG(order_items.price)) > 1000 THEN "Expensive"
        WHEN ROUND(AVG(order_items.price)) > 500 THEN "Medium"
        WHEN ROUND(AVG(order_items.price)) > 100 THEN "Low"
        ELSE "Cheap"
	END AS "Price Category",
ROUND((SUM(payment_value)/25),2) "Monthly Income",
ROUND(AVG(payment_value),2) "AVG Payment Values",
ROUND(AVG(review_score),2) "AVG Reviews", 
ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)),2) "Delivery Time (Days)",
ROUND(AVG(DATEDIFF(order_estimated_delivery_date, order_purchase_timestamp)),2) "Estimated Delivery Time (Days)"
FROM order_reviews
JOIN orders USING (order_id)
JOIN order_items USING(order_id)
JOIN order_payments USING(order_id)
JOIN products USING (product_id)
JOIN product_category_name_translation USING (product_category_name)
GROUP BY product_category_name_english
HAVING product_category_name_english IN ("audio", "computers", "pc_gamer", "security_and_services", "consoles_games", "computers_accessories", "tablets_printing_image", "telephony", "electronics"
);


select avg(freight_value) FROM order_items;
SELECT * FROM order_items;
