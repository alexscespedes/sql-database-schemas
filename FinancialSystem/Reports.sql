USE FinancialSystemDb;

-- 1. Loan Portfolio Summary
-- (overall view of loans grouped by status)

SELECT
    Status,
    COUNT(*) AS TotalLoans,
    SUM(PrincipalAmount) AS TotalPrincipal,
    SUM(PrincipalAmount + (PrincipalAmount * InterestRate / 100)) AS TotalWithInterest
FROM Loans
GROUP BY Status;

-- 2. Total Outstanding Balance (Across All Active Loans)
-- (how much money is still expected to be collected)

SELECT
    SUM(L.PrincipalAmount + (L.PrincipalAmount * L.InterestRate / 100)) - ISNULL(SUM(P.Amount), 0) AS TotalOutstanding
FROM Loans L
LEFT JOIN Payments P ON L.LoanID = P.LoanID
WHERE L.Status = 'Active';

-- 3. Top Paying Clients (by Amount Paid)
-- (which clients have contributed the most in payments)

SELECT
    C.FirstName + ' ' + C.LastName AS ClientName,
    SUM(P.Amount) AS TotalPaid
FROM Clients C
JOIN Loans L ON C.ClientID = L.ClientID
JOIN Payments P ON L.LoanID = P.LoanID
GROUP BY C.FirstName, C.LastName
ORDER BY TotalPaid DESC;

-- 4. Loan Performance Report (Average Loan Size, Interest, Term)
SELECT 
    AVG(PrincipalAmount) AS AvgLoanAmount,
    AVG(InterestRate) AS AvgInterestRate,
    AVG(TermMonths) AS AvgLoanTerm
FROM Loans;

-- 5. Clients With Multiple Loans
-- (check if some clients borrow repeatedly - risk analysis)

SELECT
    C.FirstName + ' ' + C.LastName AS ClientName,
    COUNT(L.LoanID) AS LoanCount,
    SUM(L.PrincipalAmount) AS TotalBorrowed
FROM Clients C
JOIN Loans L ON C.ClientID = L.ClientID
GROUP BY C.FirstName, C.LastName 
HAVING COUNT(L.LoanID) > 1;

-- 6. Payments Collected by Month (Cash Flow Report)
SELECT
    FORMAT(P.PaymentDate, 'yyyy-MM') AS Month,
    SUM(P.Amount) AS TotalCollected
FROM Payments P
GROUP BY FORMAT(P.PaymentDate, 'yyyy-MM')
ORDER BY Month ASC;