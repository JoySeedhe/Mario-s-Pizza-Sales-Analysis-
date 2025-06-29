
-- TIME-BASED TREND ANALYSIS
-- This section reveals patterns for operational optimization
-- ================================================================

-- BUSINESS QUESTION: What are our daily order patterns?
-- BUSINESS VALUE: Identify busy days for inventory and staffing planning
-- Daily order trend 
SELECT date, COUNT(*) AS total_orders
FROM orders
GROUP BY date
ORDER BY date;

-- BUSINESS QUESTION: What are our peak operating hours?
-- BUSINESS VALUE: Optimize staffing and inventory during high-demand periods
-- Hourly order trend 
SELECT EXTRACT(HOUR FROM time) AS hour, COUNT(*) AS orders
FROM orders
GROUP BY hour
ORDER BY hour;

-- More optimized hourly trend with AM/PM labels
SELECT 
  TO_CHAR(time, 'HH12 AM') AS hour_label,
  COUNT(*) AS total_orders
FROM orders
GROUP BY hour_label
ORDER BY MIN(EXTRACT(HOUR FROM time));

-- BUSINESS QUESTION: How does revenue vary by day?
-- BUSINESS VALUE: Identify high-revenue days for promotional planning
-- Daily revenue trend analysis
SELECT 
  o.date,
  ROUND(SUM(p.price * od.quantity), 2) AS daily_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN orders o ON od.order_id = o.order_id
GROUP BY o.date
ORDER BY o.date;

-- BUSINESS QUESTION: Which are our highest revenue days?
-- BUSINESS VALUE: Understand peak performance days
-- Top 5 revenue days only
SELECT 
  o.date,
  ROUND(SUM(p.price * od.quantity), 2) AS daily_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN orders o ON od.order_id = o.order_id
GROUP BY o.date
ORDER BY daily_revenue DESC
LIMIT 5;

-- BUSINESS QUESTION: What are our monthly revenue trends?
-- BUSINESS VALUE: Understand seasonal patterns and business growth
-- Monthly revenue trend 
SELECT 
  TO_CHAR(o.date, 'YYYY-MM') AS month,
  ROUND(SUM(p.price * od.quantity), 2) AS monthly_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN orders o ON od.order_id = o.order_id
GROUP BY month
ORDER BY month;

-- BUSINESS QUESTION: Which days of the week perform best?
-- BUSINESS VALUE: Optimize weekly staffing and promotional schedules
-- Orders and revenue by days of week 
SELECT 
  TO_CHAR(o.date, 'Day') AS day_name,
  COUNT(DISTINCT o.order_id) AS total_orders,
  ROUND(SUM(p.price * od.quantity), 2) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN orders o ON od.order_id = o.order_id
GROUP BY day_name
ORDER BY total_revenue DESC;

-- BUSINESS QUESTION: How is our revenue growing over time?
-- BUSINESS VALUE: Track business growth and identify growth trends
-- Cumulative revenue analysis 
SELECT 
  o.date,
  ROUND(SUM(p.price * od.quantity), 2) AS daily_revenue,
  ROUND(SUM(SUM(p.price * od.quantity)) OVER (ORDER BY o.date), 2) AS cumulative_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN orders o ON od.order_id = o.order_id
GROUP BY o.date
ORDER BY o.date;

-- BUSINESS QUESTION: Which months contribute most to annual growth?
-- BUSINESS VALUE: Understand seasonal impact on business performance
-- Monthly contribution analysis
SELECT 
  TO_CHAR(o.date, 'Month') AS month,
  ROUND(SUM(p.price * od.quantity), 2) AS monthly_revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY TO_CHAR(o.date, 'Month')
ORDER BY monthly_revenue DESC;

-- BUSINESS QUESTION: How do different time periods perform in terms of orders and revenue?
-- BUSINESS VALUE: Optimize operations and marketing by time of day
-- Hourly performance with AM/PM breakdown
SELECT 
  EXTRACT(HOUR FROM o.time) AS hour,
  CASE 
    WHEN EXTRACT(HOUR FROM o.time) < 12 THEN 'AM'
    ELSE 'PM'
  END AS period,
  COUNT(DISTINCT o.order_id) AS total_orders,
  ROUND(SUM(p.price * od.quantity), 2) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN orders o ON od.order_id = o.order_id
GROUP BY hour, period
ORDER BY hour;
