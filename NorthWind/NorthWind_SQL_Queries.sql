-- Analyzing the Northwind Data
USE Northwind;

-- Exercise 1
-- Rank all the orders of the customeer whose customer ID is 'ALFKI' from most to least recent using window functions
SELECT
	customerID,
    orderID,
    OrderDate,
    RANK() OVER(
    ORDER BY OrderDate DESC) AS customer_order_rank
FROM orders
WHERE customerID = 'ALFKI';

-- Exercise 2
-- Calculate a running total of the quantity of orders using window functions.
SELECT
    OrderID,
    Quantity,
    SUM(Quantity) OVER(						-- Sums the quantitiy column
    ORDER BY OrderID) AS RunningTotal		-- Ensures the summation is applied per OrderID thereby creating the running total
FROM orderdetails;

-- Exercise 3
-- Find the difference in successive order dates for each customer.
-- This will require the use of window functions to obtain the previous order date for each customer, then
-- the previous order date is subtracted from the customer's next order date, repeating the process for each new order date
SELECT
	CustomerID,
    OrderID,
    OrderDate,
    CAST(OrderDate AS DATE) AS NewDate,									-- Changes the orderdate datatype from DATETIME to DATE
    DATEDIFF(															-- Executes the subtraction to get the date difference
    CAST(OrderDate AS DATE), LAG(CAST(OrderDate AS DATE), 1) OVER (		-- LAG function returns the previous date since n=1
    PARTITION BY CustomerID												-- Ensures each Customer ID is evaluated seperately
    ORDER BY OrderDate)													-- Ensures chronological order of customer's orderdates
    ) AS DateDifference
FROM orders;
    
-- Exercise 4
-- Calculate the moving average of the quantity of the last 3 orders for each product
SELECT
	OrderID,
    ProductID,
    Quantity,
    AVG(Quantity) OVER (
    PARTITION BY ProductID
    ORDER BY OrderID
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS MovingAvgQuantity
FROM OrderDetails;