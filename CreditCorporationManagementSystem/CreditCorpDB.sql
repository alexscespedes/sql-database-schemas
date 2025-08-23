IF DB_ID('CreditCorpDB') IS NULL
    CREATE DATABASE CreditCorpDB;
GO

-- USE CreditCorpDB;
-- GO

IF OBJECT_ID('dbo.AccountNumberSeq', 'SO') IS NULL
    CREATE SEQUENCE dbo.AccountNumberSeq
    AS BIGINT
    START WITH 1000000001
    INCREMENT BY 1;
GO

IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL DROP TABLE dbo.Users;
GO
CREATE TABLE dbo.Users (
    UserID INT IDENTITY(1,1) CONSTRAINT PK_Users PRIMARY KEY,
    Username NVARCHAR(100) NOT NULL CONSTRAINT UQ_Users_Username UNIQUE,
    PasswordHash VARBINARY(64) NOT NULL,
    Role NVARCHAR(50) NOT NULL CHECK(Role IN ('Admin', 'Teller', 'LoanOfficer', 'Auditor')),
    IsActive BIT NOT NULL CONSTRAINT DF_Users_IsActive DEFAULT(1),
    CreatedAt DATETIME2(0) NOT NULL CONSTRAINT DF_Users_CreatedAt DEFAULT SYSUTCDATETIME(),
    UpdateAt DATETIME2(0) NOT NULL CONSTRAINT DF_Users_UpdatedAt DEFAULT SYSUTCDATETIME(),
    RowVersion ROWVERSION
);
GO

IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL DROP TABLE dbo.Customers;
GO
CREATE TABLE dbo.Customers (
    CustomerID INT IDENTITY(1,1) CONSTRAINT PK_Customers PRIMARY KEY,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(256) NULL,
    Phone NVARCHAR(25) NULL,
    Address NVARCHAR(300) NULL,
    NationalId NVARCHAR(50) NULL CONSTRAINT UQ_Customers_NationalId UNIQUE,
    DateOfBirth DATE NULL,
    CreatedAt DATETIME2(0) NOT NULL CONSTRAINT DF_Customers_CreatedAt DEFAULT SYSUTCDATETIME(),
    UpdateAt DATETIME2(0) NOT NULL CONSTRAINT DF_Customers_UpdatedAt DEFAULT SYSUTCDATETIME(),
    RowVersion ROWVERSION
);
GO

IF OBJECT_ID('dbo.Accounts', 'U') IS NOT NULL DROP TABLE dbo.Accounts;
GO
CREATE TABLE dbo.Accounts (
    AccountID INT IDENTITY(1,1) CONSTRAINT PK_Accounts PRIMARY KEY,
    AccountNumber NVARCHAR(20) NOT NULL CONSTRAINT DF_Accounts_AccountNumber DEFAULT
        (RIGHT('0000000000' + CAST(NEXT VALUE FOR dbo.AccountNumberSeq AS NVARCHAR(20)), 10)),
    CustomerID INT NOT NULL,
    AccountType NVARCHAR(30) NOT NULL CHECK (AccountType IN ('Savings', 'Checking', 'Loan', 'CreditCard')),
    CurrencyCode CHAR(3) NOT NULL CONSTRAINT DF_Accounts_Currency DEFAULT('DOP'),
    Balance DECIMAL(19, 4) NOT NULL CONSTRAINT DF_Accounts_Balance DEFAULT(0.0000),
    Status NVARCHAR(20) NOT NULL CONSTRAINT DF_Accounts_Status DEFAULT('Active')
                        CHECK (Status IN ('Active', 'Closed', 'Frozen')),
    OpenedAt DATETIME2(0) NOT NULL CONSTRAINT DF_Accounts_OpenedAt DEFAULT SYSUTCDATETIME(),
    ClosedAt DATETIME2(0) NULL,
    CONSTRAINT UQ_Accounts_AccountNumber UNIQUE (AccountNumber),
    CONSTRAINT FK_Accounts_Customers FOREIGN KEY (CustomerID) REFERENCES dbo.Customers(CustomerID)
);
GO
CREATE INDEX IX_Accounts_CustomerID ON dbo.Accounts(CustomerID);
GO

IF OBJECT_ID('dbo.InterestRates', 'U') IS NOT NULL DROP TABLE dbo.InterestRates;
GO
CREATE TABLE dbo.InterestRates (
    RateID INT IDENTITY(1,1) CONSTRAINT PK_InterestRates PRIMARY KEY,
    ProductType NVARCHAR(30) NOT NULL CHECK (ProductType IN ('Savings', 'Checking', 'Loan-Personal', 'Loan-Auto', 'Loan-Mortgage', 'CreditCard', 'Loan-SME')),
    Rate DECIMAL(9,6) NOT NULL CHECK (Rate >= 0),
    Compounding NVARCHAR(20) NOT NULL CHECK (Compounding IN ('Daily', 'Monthly', 'Quarterly', 'Annually', 'None')),
    EffectiveDate DATE NOT NULL,
    IsActive BIT NOT NULL CONSTRAINT DF_InterestRates_IsActive DEFAULT(1),
    CONSTRAINT UQ_InterestRates_Product_EffDate UNIQUE (ProductType, EffectiveDate)
);
GO
CREATE INDEX IX_InterestRates_Product_EffDate ON dbo.InterestRates(ProductType, EffectiveDate DESC);
GO