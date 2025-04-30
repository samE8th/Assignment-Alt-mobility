-- CREATING DATABASE NAME IT ASSIGNMENT
create database assignment;
use assignment;
SELECT * FROM assignment.payments;


-- TASK 1
-- Order and Sales Analysis

-- how many order are pending ,deliver or shipped?
SELECT *FROM (SELECT 
	order_status,
    COUNT(*) As total_orders
FROM customer_orders
group by order_status)
as order_summary

-- 1.2 REVENUE TRENDS OVER TIME
SELECT
    DATE_FORMAT(payment_date, '%Y-%m') AS month,
    SUM(payment_amount) AS total_revenue
FROM
    payments
WHERE
    payment_status = 'completed'
GROUP BY DATE_FORMAT(payment_date, '%Y-%m')
ORDER BY month;

-- TASK 2
-- Customer Analysis
	-- top 5 high value customers
SELECT 
    c.customer_id, SUM(p.payment_amount) AS total_spent
FROM
    customer_orders c
        JOIN
    payments p ON c.order_id = p.order_id
WHERE
    p.payment_status = 'completed'
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 5;

-- Customer geographical analysis
SELECT 
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(order_id) AS total_orders,
    SUBSTR(shipping_address, - 9, 9) AS location
FROM
    customer_orders
GROUP BY location
ORDER BY total_orders DESC;

-- order frequency .. 
SELECT 
    customer_id,
    COUNT(order_id) AS total_orders,
    MIN(order_date) AS first_order,
    MAX(order_date) AS last_order,
    DATEDIFF(MAX(order_date), MIN(order_date)) AS days_between,
    ROUND(COUNT(order_id) / (DATEDIFF(MAX(order_date), MIN(order_date)) + 1),
            2) AS order_frequency_per_day
FROM
    customer_orders
GROUP BY customer_id;

-- TASK 3--
-- payment status analysis
-- identifying the potential issue which leads to payment success or failures

-- Which payment methods have high failure rates?
SELECT 
    payment_method, payment_status, COUNT(*) AS count
FROM
    payments
GROUP BY payment_method , payment_status
ORDER BY payment_method;

-- TASK 4----
-- ORDER DETAIL REPORT

-- THE PERCENTAGE OF ORDER FULLFILL WITHOUT ANY ERROR
SELECT 
    COUNT(*) AS total_orders,
    SUM(CASE
        WHEN order_status = 'delivered' THEN 1
        ELSE 0
    END) AS delivered_orders,
    ROUND(100.0 * SUM(CASE
                WHEN order_status = 'delivered' THEN 1
                ELSE 0
            END) / COUNT(*),
            2) AS order_accuracy_percent
FROM
    customer_orders;

-- TOTAL SUCCESSFUL ORDERS BY MONTH
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS order_month,
    COUNT(*) AS successful_orders
FROM
    customer_orders
WHERE
    order_status = 'delivered'
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY order_month;







