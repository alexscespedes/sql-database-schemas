-- USE FinancialSystemDb;

INSERT INTO Clients (FirstName, LastName, DateOfBirth, Phone, Address)
VALUES
    ('Pedro', 'Lopez', '1982-01-15', '809-111-2222', '969 Cox Rd Gastonia, NC 28054-3455 USA'),
    ('Luisa', 'Martinez', '1975-04-30', '809-222-3333', '132 Maple St # B Frostburg, MD 21532-1826 USA'),
    ('Jose', 'Almonte', '1998-09-12', '809-333-4444', 'PO Box 2931 Hartford CT 06104-2931 USA'),
    ('Elena', 'Reyes', '1965-06-20', '809-444-5555', '1476 Sandhill Rd Orem, UT 84058-7310 USA '),
    ('Roberto', 'Santos', '1989-11-03', '809-555-6666', 'Cecelia Havens 456 White Finch St. North Augusta');


INSERT INTO Loans (ClientID, PrincipalAmount, InterestRate, TermMonths, StartDate, Status, CreatedBy)
VALUES
    (5, 15000, 7.5, 8, '2025-02-01', 'Active', 1),
    (5, 12000, 6.5, 6, '2024-01-01', 'Closed', 1),

    (6, 25000, 9.5, 12, '2024-08-01', 'Overdue', 1),

    (7, 5000, 5.0, 4, '2025-07-01', 'Active', 1),

    (8, 40000, 10.0, 18, '2024-03-01', 'Restructured', 1),

    (9, 8000, 6.0, 5, '2024-05-01', 'Closed', 1);

INSERT INTO Payments (LoanID, Amount, PaymentDate, RecordedBy)
VALUES
    (5, 2500, '2025-03-01', 2),
    (5, 2000, '2025-04-15', 2),

    (6, 3000, '2024-09-01', 2),
    (6, 2000, '2024-10-01', 2),

    (8, 3500, '2024-04-01', 2),
    (8, 3500, '2024-05-01', 2),
    (8, 2000, '2025-06-01', 2),

    (9, 4000, '2024-06-01', 2),
    (9, 5000, '2024-07-01', 2);


INSERT INTO AuditLogs (UserID, Action, Entity, EntityID, Details)
VALUES
    (2, 'CREATE', 'Loan', 5, 'Created loan of 15,000 for Pedro Lopez'),
    (2, 'CREATE', 'Payment', 15, 'Recorded payment of 2,500 for Pedro'),
    (2, 'INSERT', 'Payment', 16, 'Recorded payment of 2,000 for Pedro'),
    (2, 'CREATE', 'Loan', 9, 'Created loan of 8,000 for Roberto (later overpaid)');

SELECT * FROM Loans;