
-- PRODUCT PERFORMANCE ANALYSIS
-- This section identifies top-performing products and categories
-- ================================================================

-- BUSINESS QUESTION: Which pizza sizes are most popular?
-- BUSINESS VALUE: Optimize inventory and production planning
-- Most popular pizza sizes
SELECT p.size, SUM(od.quantity) AS total_sold
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY total_sold DESC;

-- BUSINESS QUESTION: What are our best-selling pizza varieties?
-- BUSINESS VALUE: Identify top performers for marketing and menu optimization
-- Top 5 pizzas sold 
SELECT pt.name, SUM(od.quantity) AS total_sold
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_sold DESC
LIMIT 5;

-- BUSINESS QUESTION: Which pizza categories perform best?
-- BUSINESS VALUE: Understand category preferences for menu development
-- Pizza sales by category 
SELECT pt.category, SUM(od.quantity) AS total_sold
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY total_sold DESC;

-- BUSINESS QUESTION: Which pizzas generate the most revenue?
-- BUSINESS VALUE: Focus marketing efforts on highest revenue generators
-- Total revenue generating pizzas 
SELECT 
  pt.name AS pizza_name,
  ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_revenue DESC
LIMIT 5;

-- BUSINESS QUESTION: What revenue does each category generate?
-- BUSINESS VALUE: Allocate resources to most profitable categories
-- Revenue by category 
SELECT 
  pt.category,
  ROUND(SUM(p.price * od.quantity), 2) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY total_revenue DESC;

-- BUSINESS QUESTION: How do different pizza sizes contribute to revenue?
-- BUSINESS VALUE: Optimize pricing strategy across different sizes
-- Revenue by pizza size 
SELECT 
  p.size,
  ROUND(SUM(p.price * od.quantity), 2) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY total_revenue DESC;

-- BUSINESS QUESTION: What's the performance of category-size combinations?
-- BUSINESS VALUE: Identify most profitable product combinations
-- Revenue by pizza size + category combo
SELECT 
  pt.category,
  p.size,
  ROUND(SUM(p.price * od.quantity), 2) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category, p.size
ORDER BY total_revenue DESC;
