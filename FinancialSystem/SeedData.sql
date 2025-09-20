USE FinancialSystemDb;

INSERT INTO Users (Username, PasswordHash, Role)
VALUES
    ('admin01', 'hashed_password_admin', 'Admin'),
    ('secretary01', 'hashed_password_secretary', 'Secretary');

INSERT INTO Clients (FirstName, LastName, DateOfBirth, Phone, Address)
VALUES
    ('Juan', 'Perez', '1985-03-10', '809-555-1234', 'Av. 27 de Febrero #13, Santo Domingo'),
    ('Maria', 'Gonzalez', '1990-07-22', '809-555-5678', 'Calle El Conde #45, Santo Domingo'),
    ('Carlos', 'Ramirez', '1978-12-01', '809-555-9999', 'Calle Duarte #89, Santiago'),
    ('Ana', 'Torres', '1995-05-14', '809-555-4321', 'Av. Venezuela #11, Santo Domingo Este');

INSERT INTO Loans (ClientID, PrincipalAmount, InterestRate, TermMonths, StartDate, Status, CreatedBy)
VALUES
    (1, 50000, 10.5, 12, '2025-01-01', 'Active', 1),
    (2, 20000, 8.0, 6, '2025-05-01', 'Active', 2),
    (3, 30000, 12.0, 10, '2024-09-01', 'Overdue', 1),
    (4, 10000, 10.5, 12, '2025-01-01', 'Closed', 1);

INSERT INTO Payments (LoanID, Amount, PaymentDate, RecordedBy)
VALUES
    (1, 4500, '2025-02-01', 2),
    (1, 4500, '2025-03-01', 2),
    (2, 3500, '2025-06-01', 2);
    -- (3, 6000, '2024-10-01', 2),
    -- (3, 6000, '2024-11-01', 2);
    -- (4, 5000, '2024-02-01', 2),
    -- (4, 5000, '2024-03-01', 2);

INSERT INTO AuditLogs (UserID, Action, Entity, EntityID, Details)
VALUES
    (1, 'CREATE', 'Client', 1, 'Added client Juan Perez'),
    (2, 'CREATE', 'Loan', 1, 'Created loan of 50,000 for Juan Perez'),
    (2, 'INSERT', 'Payment', 1, 'Recorded payment of 4,500'),
    (2, 'INSERT', 'Payment', 2, 'Recorded payment of 4,500');


SELECT * FROM Clients;