SELECT *, qty AS Quantity FROM sales;

SELECT ord_num FROM sales AS Test;

SELECT * FROM sales;
SELECT * FROM stores;
SELECT * FROM titles;

SELECT 
    stores.city
FROM
    sales
        LEFT JOIN
    stores USING (stor_id)
        LEFT JOIN
    titles USING (title_id)
WHERE
    title = 'Is Anger the Enemy?'; 

SELECT * FROM employee
WHERE lname = "snyder"; 

SELECT title FROM publishers
RIGHT JOIN employee
USING (pub_id)
RIGHT JOIN titles
USING (pub_id)
WHERE employee.fname ="Howard" AND employee.lname= "Snyder"; 


SELECT t.title, e.fname, e.lname
FROM employee AS e
RIGHT JOIN
titles AS t ON e.pub_id = t.pub_id
WHERE e.fname = 'Howard' AND e.lname = 'Snyder';

SELECT a.au_id, a.au_fname, a.au_lname,e.fname, e.lname FROM authors AS a
INNER JOIN titleauthor AS ta ON a.au_id = ta.au_id
INNER JOIN titles AS t ON ta.title_id = t.title_id
INNER JOIN publishers AS p ON t.pub_id = p.pub_id
INNER JOIN employee as e ON p.pub_id = e.pub_id
WHERE e.fname = "Howard" AND e.lname = "Snyder";

SELECT SUM(qty), t.title_id, t.title FROM sales AS s
LEFT JOIN titles AS t ON s.title_id = t.title_id
GROUP BY s.title_id
ORDER BY SUM(qty) DESC
LIMIT 1; 

SELECT  
CASE
	WHEN qty >= 50 THEN "High Sales"
    WHEN qty < 20 THEN "Low Sales"
    ELSE "Medium Sales"
END AS sales_category, 
SUM(qty)
FROM sales
GROUP BY sales_category
HAVING sum(qty) > 100
ORDER BY SUM(qty) DESC;

SELECT pub_id, 
CASE 
WHEN price <= 5 THEN "super Low"
WHEN price <= 10 THEN "Low"
WHEN price <= 15 THEN "Medium"
ELSE "High"
END AS price_category, 
ROUND(AVG(price),2) AS "Average Price"
FROM titles
WHERE type IN ("Business", "trad_cook", "psychology")
GROUP BY pub_id, price_category;


SELECT type, pub_id,
CASE 
WHEN avg(price) <= 5 THEN "super low"
WHEN avg(price) <= 10 THEN "low"
WHEN avg(price) <= 15 THEN "medium"
WHEN avg(price) > 15 THEN "High"
END AS price_category, 
ROUND(avg(price),2) AS "average price"
FROM titles
WHERE type = "Business" OR type = "psychology" OR type = "trad_cook"
GROUP BY pub_id, type;

SELECT 
    pub_id,
    CASE
        WHEN price <= 5 THEN 'super low'
        WHEN price <= 10 THEN 'low'
        WHEN price <= 15 THEN 'medium'
        ELSE 'high'
    END AS price_category,
    AVG(price) AS 'avg_price'
FROM
    titles
WHERE
    type IN ('business' , 'trad_cook', 'psychology')
GROUP BY pub_id , price_category;

