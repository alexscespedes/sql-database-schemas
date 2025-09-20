-- USE ECommerceSystemDb;

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(150) UNIQUE NOT NULL,
    Phone NVARCHAR(20),
    CreatedAt DATETIME DEFAULT GETDATE()
);

CREATE TABLE Addresses (
    AddressID INT PRIMARY KEY IDENTITY,
    CustomerID INT NOT NULL,
    Street NVARCHAR(200),
    City NVARCHAR(100),
    State NVARCHAR(100),
    PostalCode NVARCHAR(20),
    Country NVARCHAR(100),
    AddressType NVARCHAR(50) CHECK (AddressType IN ('Billing', 'Shipping')),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(250)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(150) NOT NULL,
    Description NVARCHAR(500),
    Price DECIMAL(10, 2) NOT NULL,
    Stock INT NOT NULL CHECK (Stock >= 0),
    CategoryID INT,
    FOREIGN KEY (ProductID) REFERENCES Categories(CategoryID)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY,
    CustomerID INT NOT NULL,
    OrderDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(50) CHECK (Status IN ('Pending', 'Paid', 'Shipped', 'Delivered', 'Cancelled')),
    ShippingAddressID INT,
    BillingAddressID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ShippingAddressID) REFERENCES Addresses(AddressID),
    FOREIGN KEY (BillingAddressID) REFERENCES Addresses(AddressID)
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY IDENTITY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY IDENTITY,
    OrderID INT NOT NULL,
    PaymentDate DATETIME DEFAULT GETDATE(),
    Amount DECIMAL(10, 2) NOT NULL,
    Method NVARCHAR(50) CHECK (Method IN ('CreditCard', 'PayPal', 'BankTransfer')),
    Status NVARCHAR(50) CHECK (Status IN ('Pending', 'Completed', 'Failed')),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);