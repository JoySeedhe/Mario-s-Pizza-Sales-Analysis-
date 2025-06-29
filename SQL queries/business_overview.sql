
-- BUSINESS PERFORMANCE OVERVIEW
-- This section provides key business metrics for executive reporting
-- ================================================================

-- BUSINESS QUESTION: What is our overall sales volume?
-- BUSINESS VALUE: Understand total business scale and transaction volume
-- Retrieve total number of orders placed 
SELECT COUNT(DISTINCT order_id) AS Total_orders FROM orders;

-- BUSINESS QUESTION: How many pizzas do we sell in total?
-- BUSINESS VALUE: Measure production capacity and product demand
-- Total pizzas sold
SELECT SUM(quantity) AS total_pizzas_sold FROM order_details;

-- BUSINESS QUESTION: What is our total revenue?
-- BUSINESS VALUE: Key financial metric for business performance evaluation
-- Total revenue generated 
SELECT ROUND(SUM(p.price * od.quantity), 2) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id;

-- BUSINESS QUESTION: What does an average customer spend per order?
-- BUSINESS VALUE: Important metric for pricing strategy and customer value analysis
-- Average order value 
SELECT 
  ROUND(SUM(p.price * od.quantity) / COUNT(DISTINCT od.order_id), 2) AS average_order_value
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id;

-- BUSINESS QUESTION: What are our highest and lowest value orders?
-- BUSINESS VALUE: Understand customer spending patterns and identify upselling opportunities
-- Top 1 highest order value
SELECT 
  od.order_id,
  ROUND(SUM(p.price * od.quantity), 2) AS order_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY od.order_id
ORDER BY order_revenue DESC
LIMIT 1;

-- Smallest order value 
SELECT 
  od.order_id,
  ROUND(SUM(p.price * od.quantity), 2) AS order_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY od.order_id
ORDER BY order_revenue ASC
LIMIT 1;

-- BUSINESS QUESTION: How many high-value customers do we have?
-- BUSINESS VALUE: Identify premium customer segment for targeted marketing
-- Count of high-value orders (>$100)
SELECT 
  COUNT(*) AS count_high_value_orders
FROM (
  SELECT 
    od.order_id,
    SUM(p.price * od.quantity) AS order_revenue
  FROM order_details od
  JOIN pizzas p ON od.pizza_id = p.pizza_id
  GROUP BY od.order_id
) sub
WHERE order_revenue > 100;

-- BUSINESS QUESTION: What is the revenue distribution by individual orders?
-- BUSINESS VALUE: Understand order value patterns for pricing optimization
-- Order wise revenue analysis
SELECT 
  od.order_id,
  ROUND(SUM(p.price * od.quantity), 2) AS order_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY od.order_id
ORDER BY order_revenue DESC;