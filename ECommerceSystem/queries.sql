-- 1. Get all active orders for a customer

DECLARE @CustomerID INT = 1;

SELECT
    o.OrderID,
    o.OrderDate,
    o.Status,
    SUM(od.Quantity * od.UnitPrice) AS OrderTotal
From Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
WHERE o.CustomerID = @CustomerID
    AND o.Status IN ('Pending', 'Processing', 'Shipped')
GROUP BY o.OrderID, o.OrderDate, o.Status
ORDER BY o.OrderDate DESC;

-- 2. Get order history with payment details

SELECT
    o.OrderID,
    o.OrderDate,
    o.Status,
    SUM(od.Quantity * od.UnitPrice) AS TotalAmount,
    p.Method AS PaymentMethod,
    p.Amount AS PaidAmount,
    p.PaymentDate
From Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
LEFT JOIN Payments p ON o.OrderID = p.OrderID
WHERE o.CustomerID = 2
GROUP BY o.OrderID, o.OrderDate, o.Status, p.Method, p.Amount, p.PaymentDate
ORDER BY o.OrderDate DESC;

-- 3. List top 5 best-selling products

SELECT TOP 5
    p.Name AS Product,
    SUM(od.Quantity) AS TotalUnitsSold,
    SUM(od.Quantity * od.UnitPrice) AS RevenueGenerated
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.Name
ORDER BY TotalUnitsSold DESC;

-- 4. Get all products in stock with category info

SELECT
    p.ProductID,
    p.Name,
    p.Stock,
    p.Price,
    c.Name AS Category
From Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE p.Stock > 0
ORDER BY c.Name, p.Name;

-- 5. Monthly sales per category

SELECT
    c.Name AS Category,
    FORMAT(o.OrderDate, 'yyyy-MM') AS Month,
    SUM(od.Quantity * od.UnitPrice) AS TotalSales
From OrderDetails od
JOIN Orders o ON o.OrderID = od.OrderID
JOIN Products p ON o.OrderID = od.OrderID
JOIN Categories c ON o.OrderID = od.OrderID
WHERE o.Status = 'Delivered'
GROUP BY c.Name, FORMAT(o.OrderDate, 'yyyy-MM')
ORDER BY Month DESC, TotalSales DESC;

-- 6 Average order value per customer

SELECT 
    c.CustomerID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    AVG(OrderTotal) AS AvgOrderValue
FROM (
    SELECT
        o.OrderID,
        o.CustomerID,
        SUM(od.Quantity * od.UnitPrice) AS OrderTotal
    FROM Orders o
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    GROUP BY o.OrderID, o.CustomerID
) AS OrderSummary
JOIN Customers c ON c.CustomerID = OrderSummary.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY AvgOrderValue DESC;

-- 7 Most popular payment methods

SELECT
    p.Method,
    COUNT(p.PaymentID) AS TotalPayments,
    SUM(p.Amount) AS TotalAmount
FROM Payments p
GROUP BY p.Method
ORDER BY TotalPayments DESC;

-- 8 List products never sold

SELECT
    p.ProductID,
    p.Name,
    p.Price,
    p.Stock
FROM Products p
LEFT JOIN OrderDetails od ON p.ProductID = od.ProductID
WHERE od.ProductID IS NULL;

-- 9 Customer purchase frequency

SELECT
    c.CustomerID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    MIN(o.OrderDate) AS FirstOrder,
    MAX(o.OrderDate) AS LastOrder
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY TotalOrders DESC;

-- 10 Pending shipments (orders paid but not shipped yet)

SELECT
    o.OrderID,
    o.OrderDate,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    SUM(od.Quantity * od.UnitPrice) AS OrderTotal,
    p.Amount AS PaidAmount,
    p.Method AS PaidMethod,
    p.PaymentDate
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Payments p ON o.OrderID = p.OrderID
WHERE o.Status = 'Paid'
    AND P.Amount >= (SELECT SUM(od2.Quantity * od2.UnitPrice)
                    FROM OrderDetails od2 WHERE od2.OrderID = o.OrderID)
GROUP BY o.OrderID, o.OrderDate, c.FirstName, c.LastName, p.Amount, p.Method, p.PaymentDate
ORDER BY o.OrderDate;