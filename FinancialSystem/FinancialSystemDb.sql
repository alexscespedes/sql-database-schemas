CREATE DATABASE FinancialSystemDb;

-- DROP TABLE Clients

USE FinancialSystemDb;

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
    TermMonths INT NOT NULL,
    StartDate DATE NOT NULL,
    Status NVARCHAR(20) CHECK (Status IN ('Active', 'Closed', 'Overdue', 'Restructured')) DEFAULT 'Active',
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
    Details NVARCHAR(500) NULL,
    Timestamp DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

--- PHASE 2: RELATIONSHIPS & CONSTRAINTS

-- 1.
ALTER TABLE Clients
ADD CONSTRAINT UQ_Client UNIQUE (FirstName, LastName, DateOfBirth);

-- 2.
ALTER TABLE Users
ADD UNIQUE (Username); 

-- 3.

ALTER TABLE Loans
ADD CONSTRAINT CK_Loans_Principal CHECK (PrincipalAmount > 0);

ALTER TABLE Loans
ADD CONSTRAINT CK_Loans_Interest CHECK (InterestRate >= 0);

ALTER TABLE Loans
ADD CONSTRAINT CK_Loans_Term CHECK (TermMonths >= 1);

EXEC sp_rename 'dbo.Loans.TermsMonths', 'TermMonths', 'COLUMN';


ALTER TABLE Loans
ADD CONSTRAINT CK_Loans_Status CHECK (Status IN ('Active', 'Overdue', 'Closed', 'Restructured'));

-- 4.

ALTER TABLE Payments
ADD CONSTRAINT CK_Payments_Amount CHECK (Amount > 0);
GO

--- TRIGGER ---

CREATE TRIGGER TR_ValidatePayment
ON Payments
INSTEAD OF INSERT
AS
BEGIN
    -- Check for payments on closed/overdue loans
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Loans l ON i.LoanID = l.LoanID
        WHERE l.Status <> 'Active'
    )
    BEGIN
        RAISERROR('Cannot add payment to a closed or overdue loan.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    -- Check for overpayments
     IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Loans l ON i.LoanID = l.LoanID
        CROSS APPLY (
            SELECT ISNULL(SUM(p.Amount),0) AS TotalPaid
            FROM Payments p
            WHERE p.LoanID = l.LoanID
        ) t
        WHERE (t.TotalPaid + i.Amount) >
              (l.PrincipalAmount + (l.PrincipalAmount * l.InterestRate/100))
    )
    BEGIN
        RAISERROR('Payment exceeds remaining balance.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    INSERT INTO Payments (LoanID, Amount, PaymentDate, RecordedBy)
    SELECT LoanID, Amount, PaymentDate, RecordedBy
    FROM inserted;
END;
GO