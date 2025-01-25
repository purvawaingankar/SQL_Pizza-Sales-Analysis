create database Pizza_Shop;

-- Export csv file data through Table data import wizard and create new table
-- File pizza_types and pizzas have been imported
-- File orders and order_details schema need to be creted as it does not imported with proper data type  

CREATE TABLE orders (
    order_id INT NOT NULL PRIMARY KEY,
    date DATE NOT NULL,
    time TIME NOT NULL
);

CREATE TABLE order_details (
    order_details_id INT NOT NULL,
    order_id INT NOT NULL,
    pizza_id TEXT NOT NULL,
    quantity INT NOT NULL
);
-- Import orders and orser_details data through Table data import wizard using existing table



-- Retrieve total numbers of order placed in a particular Monthorders
SELECT 
    MONTH(date), COUNT(*) AS total_order_placed
FROM
    orders
GROUP BY MONTH(date); 



-- Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(p.price * od.quantity), 0) AS total_revenue
FROM
    pizzas p
        JOIN
    order_details od ON od.pizza_id = p.pizza_id;



-- Identify the highest-priced pizza.
SELECT 
    pt.name, p.price
FROM
    pizza_types pt
        JOIN
    pizzas p ON p.pizza_type_id = pt.pizza_type_id
    Order By p.price Desc
    limit 1;



-- Identify the most common pizza size ordered.
SELECT 
    p.size, COUNT(od.order_details_id) AS Ordered_Frequency
FROM
    pizzas p
        JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY Ordered_Frequency DESC
LIMIT 1; 



-- List the top 5 most ordered pizza types along with their quantities.
SELECT 
    pt.name, SUM(od.quantity) AS Total_Quantity
FROM
    pizza_types pt
        JOIN
    pizzas p ON p.pizza_type_id = pt.pizza_type_id
        JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY Total_Quantity DESC
LIMIT 5;



-- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    pt.category, SUM(od.quantity) AS total_quantity_Ordered
FROM
    pizza_types pt
        JOIN
    pizzas p ON p.pizza_type_id = pt.pizza_type_id
        JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY pt.category;



-- Determine the distribution of orders by hour of the day.
SELECT 
    COUNT(od.order_id) AS total_orders, HOUR(o.time) AS Hour
FROM
    order_details od
        JOIN
    orders o ON od.order_id = o.order_id
GROUP BY Hour;



-- Join relevant tables to find the category-wise distribution of pizzas.
SELECT 
    pt.category, COUNT(pt.name) AS Pizzas_Types
FROM
    pizza_types pt
GROUP BY pt.category;



-- Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT 
    AVG(order_details.quantity)
FROM
    (SELECT 
        o.date, SUM(od.quantity) AS Average_Pizza_Order
    FROM
        order_details od
    JOIN orders o ON o.order_id = od.order_id
    GROUP BY o.date) AS order_quantity;


-- Calculate the percentage contribution of each pizza type to total revenue.
SELECT 
    pt.category,
    (SUM(p.price * od.quantity) / (SELECT 
            ROUND(SUM(p.price * od.quantity), 3) AS total_revenue
        FROM
            pizzas p
                JOIN
            order_details od ON od.pizza_id = p.pizza_id)) * 100 AS revenue
FROM
    pizzas p
        JOIN
    order_details od ON od.pizza_id = p.pizza_id
        JOIN
    pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.category
ORDER BY revenue DESC;
    
    
    








