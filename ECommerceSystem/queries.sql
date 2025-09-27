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