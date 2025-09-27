INSERT INTO Customers (FirstName, LastName, Email, Phone)
VALUES
('Alice', 'Johnson', 'alice.johnson@email.com', '555-1010'),
('Bob', 'Smith', 'bob.smith@email.com', '555-2020'),
('Catherine', 'Wong', 'catherine.wong@email.com', '555-3030'),
('Daniel', 'Martinez', 'daniel.martinez@email.com', '555-4040'),
('Eva', 'Lopez', 'eva.lopez@gemail.com', '555-5050');

-- TRUNCATE TABLE Addresses;

INSERT INTO Addresses (CustomerID, Street, City, State, PostalCode, Country, AddressType)
VALUES
(1, '123 Main St', 'New York City', 'NY', '10001', 'USA', 'Shipping'),
(1, '456 Park Ave', 'New York City', 'NY', '10002', 'USA', 'Billing'),

(2, '789 Oak Rd', 'Los Angeles', 'CA', '90001', 'USA', 'Shipping'),
(2, '321 Maple St', 'Los Angeles', 'CA', '90002', 'USA', 'Billing'),

(3, '654 Pine Ln', 'Chicago', 'IL', '60601', 'USA', 'Shipping'),

(4, '987 Elm St', 'Miami', 'FL', '33101', 'USA', 'Shipping'),
(4, '123 Main St', 'New York City', 'NY', '33102', 'USA', 'Billing'),

(5, '246 Sunset Blvd', 'Dallas', 'TX', '75201', 'USA', 'Shipping');


INSERT INTO Categories (Name, Description) 
VALUES
('Electronics', 'Devices, gadgets, and accessories'),
('Clothing', 'Devices, gadgets, and accessories'),
('Books', 'Devices, gadgets, and accessories'),
('Home Appliances', 'Kitchen and household appliances'),
('Sports', 'Sports equipment and gear');

INSERT INTO Products (Name, Description, Price, Stock, CategoryID)
VALUES
('iPhone 14', 'Latest Apple smartphone', 999.99, 50, 1),
('Samsung Galaxy S23', 'Flagship Android phone', 899.99, 40, 1),
('Sony Headphones', 'Noise cancelling headphones', 199.99, 100, 1),
('Men T-Shirt', '100% cotton casual wear', 25.50, 200, 2),
('Women Jacket', 'Leather stylish jacket', 150.00, 80, 2),
('Novel - The Great Adventure', 'Fiction bestseller', 18.75, 120, 3),
('Cookbook - Healthy Meals', 'Guide to healthy recipes', 22.90, 60, 3),
('Microwave Oven', '700W kitchen microwave', 120.00, 30, 4),
('Vacuum Cleaner', 'Bagless vacuum cleaner', 250.00, 25, 4),
('Football', 'Official size match ball', 35.00, 150, 5),
('Tennis Racket', 'Ligthweight racket', 80.00, 50, 5);

INSERT INTO Orders (CustomerID, Status, ShippingAddressID, BillingAddressID)
VALUES
(1, 'Pending', 1, 2),
(1, 'Paid', 1, 2),
(2, 'Shipped', 3, 4),
(3, 'Delivered', 5, 5),
(4, 'Cancelled', 6, 7),
(5, 'Pending', 8, 8);

INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice)
VALUES

(1, 1, 1, 999.99),
(1, 3, 2, 199.99),

(2, 4, 3, 25.50),
(2, 6, 1, 18.75),

(3, 2, 1, 899.99),
(3, 5, 1, 150.00),

(4, 7, 2, 22.90),
(4, 10, 1, 35.00),

-- (5, 8, 1, 120.00),

(5, 11, 2, 80.00),
(5, 9, 1, 250.00);

INSERT INTO Payments (OrderID, Amount, Method, Status)
VALUES
(2, 95.25, 'CreditCard', 'Completed'),
(3, 1049.99, 'PayPal', 'Completed'),
(4, 81.80, 'BankTransfer', 'Completed'),
(5, 410.00, 'CreditCard', 'Completed');