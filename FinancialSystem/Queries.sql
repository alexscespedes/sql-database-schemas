USE FinancialSystemDb;

-- 1. List All Active Loans

SELECT 
    L.LoanID,
    C.FirstName + ' ' + C.LastName AS ClientName,
    L.PrincipalAmount,
    L.InterestRate,
    L.TermMonths,
    L.StartDate,
    L.Status 
FROM Loans L
JOIN Clients C ON L.ClientID = C.ClientID
WHERE L.Status = 'Active';

-- 2. Find Overdue Loans

SELECT 
    L.LoanID,
    C.FirstName + ' ' + C.LastName AS ClientName,
    L.PrincipalAmount,
    L.InterestRate,
    L.TermMonths,
    L.StartDate,
    L.Status 
FROM Loans L
JOIN Clients C ON L.ClientID = C.ClientID
WHERE L.Status = 'Overdue';

-- 3. Show Payment History for a Client

SELECT
    P.PaymentID,
    P.PaymentDate,
    P.Amount,
    U.Username AS RecordedBy
FROM Payments P
JOIN Loans L ON P.LoanID = L.LoanID
JOIN Clients C ON L.ClientID = C.ClientID
JOIN Users U ON P.RecordedBy = U.UserID
WHERE C.ClientID = 1
ORDER BY P.PaymentDate DESC;

-- 4. Remaining Balance on Active Loans

SELECT
    L.LoanID,
    C.FirstName + ' ' + C.LastName AS ClientName,
    L.PrincipalAmount + (L.PrincipalAmount * L.InterestRate / 100) AS TotalDue,
    ISNULL(SUM(P.Amount), 0) AS TotalPaid,
    (L.PrincipalAmount + (L.PrincipalAmount * L.InterestRate / 100)) - ISNULL(SUM(P.Amount), 0) AS RemainingBalance
FROM Loans L
JOIN Clients C ON L.ClientID = C.ClientID
LEFT JOIN Payments P ON L.LoanID = P.LoanID
WHERE L.Status = 'Active'
GROUP BY L.LoanID, C.FirstName, C.LastName, L.PrincipalAmount, L.InterestRate;

-- 5. Clients with No Payments Yet

SELECT 
    L.LoanID,
    C.FirstName + ' ' + C.LastName AS ClientName,
    L.PrincipalAmount,
    L.StartDate
FROM Loans L
JOIN Clients C ON L.ClientID = C.ClientID
LEFT JOIN Payments P ON L.LoanID = P.LoanID
WHERE P.PaymentID IS NULL AND L.Status = 'Active';