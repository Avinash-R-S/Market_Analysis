-- 1) Top 10 aisles with the highest number of products
SELECT a.aisle, COUNT(p.product_id) AS total_products
     FROM products p
     JOIN aisles a ON p.aisle_id = a.aisle_id
     GROUP BY a.aisle
     ORDER BY total_products DESC
     LIMIT 10;

-- 2) How many unique departments are there in the dataset
SELECT COUNT(DISTINCT department_id) AS unique_departments
     FROM departments;

-- 3) Distribution of products across departments
SELECT d.department, COUNT(p.product_id) AS product_count
     FROM products p
     JOIN departments d ON p.department_id = d.department_id
     GROUP BY d.department;

-- 4) Top 10 products with the highest reorder rates
SELECT pr.product_name,
            ROUND(SUM(op.reordered)/COUNT(op.product_id) * 100) AS reorder_rate
     FROM order_products_train op
     JOIN products pr ON op.product_id = pr.product_id
     GROUP BY pr.product_name
     ORDER BY reorder_rate DESC
     LIMIT 10;

-- 5) How many unique users have placed orders in the dataset
SELECT COUNT(DISTINCT user_id) AS unique_users
     FROM orders;

-- 6) Average number of days between orders for each user
	SELECT user_id, ROUND(AVG(days_since_prior_order), 2) AS avg_days_between_orders
	FROM orders
	WHERE days_since_prior_order IS NOT NULL
	GROUP BY user_id;

-- 7) Peak hours of order placement during the day
SELECT order_hour_of_day, COUNT(order_id) AS total_orders
     FROM orders
     GROUP BY order_hour_of_day
     ORDER BY total_orders DESC;

-- 8) How order volume varies by day of the week
SELECT order_dow, COUNT(order_id) AS total_orders
     FROM orders
     GROUP BY order_dow
     ORDER BY total_orders DESC;

-- 9) Top 10 most ordered products
SELECT p.product_name, COUNT(op.product_id) AS order_count
     FROM order_products_train op
     JOIN products p ON op.product_id = p.product_id
     GROUP BY p.product_name
     ORDER BY order_count DESC
     LIMIT 10;

-- 10) How many users have placed orders in each department
SELECT d.department, COUNT(DISTINCT o.user_id) AS user_count
     FROM order_products_train op
     JOIN products p ON op.product_id = p.product_id
     JOIN departments d ON p.department_id = d.department_id
     JOIN orders o ON op.order_id = o.order_id
     GROUP BY d.department;

-- 11) Average number of products per order
SELECT ROUND(AVG(product_count), 2) AS avg_products_per_order
     FROM (
         SELECT order_id, COUNT(product_id) AS product_count
         FROM order_products_train
         GROUP BY order_id
     ) AS sub;

-- 12) Most reordered products in each department
SELECT d.department, p.product_name, SUM(op.reordered) AS total_reorders
     FROM order_products_train op
     JOIN products p ON op.product_id = p.product_id
     JOIN departments d ON p.department_id = d.department_id
     GROUP BY d.department, p.product_name
     ORDER BY d.department, total_reorders DESC;

-- 13) How many products have been reordered more than once
SELECT count(*) as products_total_reordered 
FROM (
         SELECT product_id, SUM(reordered) AS total_reordered
         FROM order_products_train
         GROUP BY product_id
         HAVING total_reordered > 1
         )
         AS sub;

-- 14) Average number of products added to the cart per order
SELECT ROUND(AVG(cart_count), 2) AS avg_cart_size
     FROM (
         SELECT order_id, COUNT(add_to_cart_order) AS cart_count
         FROM order_products_train
         GROUP BY order_id
     ) AS sub;

-- 15) How number of orders varies by hour of the day
SELECT order_hour_of_day, COUNT(order_id) AS total_orders
     FROM orders
     GROUP BY order_hour_of_day
     ORDER BY order_hour_of_day;

-- 16) Distribution of order sizes (number of products per order)
SELECT product_count, COUNT(*) AS num_orders
     FROM (
         SELECT order_id, COUNT(product_id) AS product_count
         FROM order_products_train
         GROUP BY order_id
     ) AS sub
     GROUP BY product_count
     ORDER BY product_count;

-- 17) Average reorder rate for products in each aisle
SELECT a.aisle, ROUND(SUM(op.reordered)/COUNT(op.product_id) * 100, 2) AS avg_reorder_rate
     FROM order_products_train op
     JOIN products p ON op.product_id = p.product_id
     JOIN aisles a ON p.aisle_id = a.aisle_id
     GROUP BY a.aisle;

-- 18) How average order size varies by day of the week
SELECT order_dow, ROUND(AVG(product_count),2) AS avg_order_size
     FROM (
         SELECT o.order_id, o.order_dow, COUNT(op.product_id) AS product_count
         FROM orders o
         JOIN order_products_train op ON o.order_id = op.order_id
         GROUP BY o.order_id, o.order_dow
     ) AS sub
     GROUP BY order_dow;

-- 19) Top 10 users with highest number of orders
SELECT user_id, COUNT(order_id) AS total_orders
     FROM orders
     GROUP BY user_id
     ORDER BY total_orders DESC
     LIMIT 10;

-- 20) How many products belong to each aisle and department
SELECT d.department, a.aisle, COUNT(p.product_id) AS product_count
     FROM products p
     JOIN departments d ON p.department_id = d.department_id
     JOIN aisles a ON p.aisle_id = a.aisle_id
     GROUP BY d.department, a.aisle
     ORDER BY d.department, a.aisle;