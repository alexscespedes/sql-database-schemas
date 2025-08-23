CREATE DATABASE FinancialSystemDb;

-- USE FinancialSystemDb;

-- 1. Clients (borrowers)

CREATE TABLE Clients (
    ClientID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    DateOfBirth DATE,
    Phone NVARCHAR(20),
    Address NVARCHAR(200),
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- 2. Users (borrowers + admin)

CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(50) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(200) NOT NULL,
    Role NVARCHAR(20) CHECK (Role IN ('Admin', 'Secretary')) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- 3. Loans

CREATE TABLE Loans (
    LoanID INT PRIMARY KEY IDENTITY(1,1),
    ClientID INT NOT NULL,
    PrincipalAmount DECIMAL(12,2) NOT NULL,
    InterestRate DECIMAL(5,2) NOT NULL,
    TermsMonths INT NOT NULL,
    StartDate DATE NOT NULL,
    Status NVARCHAR(20) CHECK (Status IN ('Active', 'Closed', 'Overdue')) DEFAULT 'Active',
    CreatedBy INT NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);

-- 4. Payments

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    LoanID INT NOT NULL,
    Amount DECIMAL(12,2) NOT NULL,
    PaymentDate DATE NOT NULL DEFAULT GETDATE(),
    RecordedBy INT NOT NULL,
    FOREIGN KEY (LoanID) REFERENCES Loans(LoanID),
    FOREIGN KEY (RecordedBy) REFERENCES Users(UserID)
);


-- 5. AuditLogs (tracks key operations)

CREATE TABLE AuditLogs (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    Action NVARCHAR(100) NOT NULL,
    Entity NVARCHAR(50),
    EntityID INT,
    Timestamp DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
