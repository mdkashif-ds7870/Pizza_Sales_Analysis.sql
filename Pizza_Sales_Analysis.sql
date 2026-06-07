-- =====================================================
-- DATABASE CREATION
-- =====================================================

CREATE DATABASE pizzahut;


-- =====================================================
-- TABLE CREATION: ORDER_DETAILS
-- =====================================================

CREATE TABLE order_details (
    order_details_id INT NOT NULL,
    order_id INT NOT NULL,
    pizza_id TEXT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY(order_details_id)
);


-- =====================================================
-- QUESTION 1:
-- Retrieve the Total Number of Orders Placed
-- =====================================================

SELECT COUNT(order_id) AS total_orders
FROM orders;


-- =====================================================
-- QUESTION 2:
-- Calculate the Total Revenue Generated from Pizza Sales
-- =====================================================

SELECT
    ROUND(SUM(order_details.quantity * pizzas.price), 2) AS total_sales
FROM order_details
JOIN pizzas
ON pizzas.pizza_id = order_details.pizza_id;


-- =====================================================
-- QUESTION 3:
-- Identify the Highest-Priced Pizza
-- =====================================================

SELECT
    pizza_types.name,
    pizzas.price
FROM pizza_types
JOIN pizzas
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;


-- =====================================================
-- QUESTION 4:
-- Identify the Most Common Pizza Size Ordered
-- =====================================================

SELECT
    pizzas.size,
    COUNT(order_details.order_details_id) AS order_count
FROM pizzas
JOIN order_details
ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC
LIMIT 1;


-- =====================================================
-- QUESTION 5:
-- List the Top 5 Most Ordered Pizza Types
-- Along with Their Quantities
-- =====================================================

SELECT
    pizza_types.name,
    SUM(order_details.quantity) AS quantity
FROM pizza_types
JOIN pizzas
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details
ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity DESC
LIMIT 5;


-- =====================================================
-- QUESTION 6:
-- Find the Total Quantity of Each Pizza Category Ordered
-- =====================================================

SELECT
    pizza_types.category,
    SUM(order_details.quantity) AS quantity
FROM pizza_types
JOIN pizzas
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details
ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY quantity DESC;


-- =====================================================
-- QUESTION 7:
-- Determine the Distribution of Orders by Hour of the Day
-- =====================================================

SELECT
    HOUR(order_time) AS hour,
    COUNT(order_id) AS order_count
FROM orders
GROUP BY HOUR(order_time);


-- =====================================================
-- QUESTION 8:
-- Find the Category-Wise Distribution of Pizzas
-- =====================================================

SELECT
    category,
    COUNT(name)
FROM pizza_types
GROUP BY category;


-- =====================================================
-- QUESTION 9:
-- Calculate the Average Number of Pizzas Ordered Per Day
-- =====================================================

SELECT ROUND(AVG(quantity), 0)
FROM (
    SELECT
        orders.order_date,
        SUM(order_details.quantity) AS quantity
    FROM orders
    JOIN order_details
    ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date
) AS order_quantity;


-- =====================================================
-- QUESTION 10:
-- Determine the Top 3 Most Ordered Pizza Types
-- Based on Revenue
-- =====================================================

SELECT
    pizza_types.name,
    SUM(order_details.quantity * pizzas.price) AS revenue
FROM pizza_types
JOIN pizzas
ON pizzas.pizza_type_id = pizza_types.pizza_type_id
JOIN order_details
ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC
LIMIT 3;


-- =====================================================
-- QUESTION 11:
-- Calculate the Percentage Contribution of Each
-- Pizza Category to Total Revenue
-- =====================================================

SELECT
    pizza_types.category,
    ROUND(
        SUM(order_details.quantity * pizzas.price) /
        (
            SELECT
                ROUND(SUM(order_details.quantity * pizzas.price), 2) AS total_sales
            FROM order_details
            JOIN pizzas
            ON pizzas.pizza_id = order_details.pizza_id
        ) * 100,
        2
    ) AS revenue
FROM pizza_types
JOIN pizzas
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details
ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue DESC;


-- =====================================================
-- QUESTION 12:
-- Analyze the Cumulative Revenue Generated Over Time
-- =====================================================

SELECT
    order_date,
    SUM(revenue) OVER(ORDER BY order_date) AS cum_revenue
FROM (
    SELECT
        orders.order_date,
        SUM(order_details.quantity * pizzas.price) AS revenue
    FROM order_details
    JOIN pizzas
    ON order_details.pizza_id = pizzas.pizza_id
    JOIN orders
    ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date
) AS sales;
