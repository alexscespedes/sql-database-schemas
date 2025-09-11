USE FinancialSystemDb;

-- 1. Detect Overpaid Loans
-- (find loans where payments exceed total due)

SELECT 
    L.LoanID,
    C.FirstName + ' ' + C.LastName AS ClientName,
    L.PrincipalAmount,
    L.InterestRate,
    L.PrincipalAmount + (L.PrincipalAmount * L.InterestRate / 100) AS ExpectedTotal,
    SUM(P.Amount) AS TotalPaid,
    SUM(P.Amount) - (L.PrincipalAmount + (L.PrincipalAmount * L.INterestRate / 100)) AS OverpaidAmount
FROM Loans L
JOIN Clients C ON L.ClientID = C.ClientID
JOIN Payments P ON L.LoanID = P.LoanID
GROUP BY L.LoanID, C.FirstName, C.LastName, L.PrincipalAmount, L.InterestRate
HAVING SUM(P.Amount) > (L.PrincipalAmount + (L.PrincipalAmount * L.InterestRate / 100));

-- 2. Clients with Multiple Active Loans
-- (detect higher-risk clients who are juggling more than one active loan)

SELECT
    C.FirstName + ' ' + C.LastName AS ClientName,
    COUNT(L.LoanID) AS ActiveLoans,
    SUM(L.PrincipalAmount) AS TotalBorrowed
FROM Clients C
JOIN Loans L ON C.ClientID = L.ClientID
WHERE L.Status = 'Active'
GROUP BY C.FirstName, C.LastName
HAVING COUNT(L.LoanID) > 1;

-- 3. Loan Repayment Progress (as % Paid)
-- (show each active loan's repayment percentage)

SELECT
    L.LoanID,
    C.FirstName + ' ' + C.LastName AS ClientName,
    (ISNULL(SUM(P.Amount), 0) * 100.0) /
    (L.PrincipalAmount + (L.PrincipalAmount * L.InterestRate / 100)) AS PaymentProgressPct
FROM Loans L
JOIN Clients C ON L.ClientID = C.ClientID
LEFT JOIN Payments P ON L.LoanID = P.LoanID
WHERE L.Status = 'Active'
GROUP BY L.LoanID, C.FirstName, C.LastName, L.PrincipalAmount, L.InterestRate;

-- 4. Missed Payments Detection
-- (assume monthly installments; detect clients behind schedule)

WITH ExpectedPayments AS (
    SELECT
        L.LoanID,
        DATEDIFF(MONTH, L.StartDate, GETDATE()) + 1 AS ExpectedInstallments
    FROM Loans L
    WHERE L.Status = 'Active'
)

SELECT
    L.LoanID,
    C.FirstName + ' ' + C.LastName AS ClientName,
    E.ExpectedInstallments,
    COUNT(P.PaymentID) AS ActualPayments,
    (E.ExpectedInstallments - COUNT(P.PaymentID)) AS MissedPayments
FROM Loans L
JOIN Clients C ON L.ClientID = C.ClientID
JOIN ExpectedPayments E ON L.LoanID = E.LoanID
LEFT JOIN Payments P ON L.LoanID = P.LoanID
GROUP BY L.LoanID, C.FirstName, C.LastName, E.ExpectedInstallments
HAVING (E.ExpectedInstallments - COUNT(P.PaymentID)) > 0;

-- 5. Portfolio Risk Analysis
-- (what % of loans are overdue, active, closed, restructured)

SELECT
    Status,
    COUNT(*) AS LoanCount,
    ROUND( (COUNT(*) * 100.0) / (SELECT COUNT(*) FROM Loans), 2) AS PercentageOfPortfolio
FROM Loans
GROUP BY Status;

-- 6. Cash Flow Forecast
-- (expected collections for the next 3 months, assuming monthly installments)

SELECT 
    DATEADD(MONTH, v.number, L.StartDate) AS ExpectedPaymentDate,
    (L.PrincipalAmount + (L.PrincipalAmount * L.InterestRate / 100)) / L.TermMonths AS ExpectedInstallment,
    C.FirstName + ' ' + C.LastName AS ClientName
FROM Loans L
JOIN Clients C ON L.ClientID = C.ClientID
JOIN master.dbo.spt_values V ON v.type = 'P'
WHERE v.number BETWEEN 0 AND L.TermMonths -1
    AND L.Status = 'Active'
    AND DATEADD(MONTH, v.number, L.StartDate) BETWEEN GETDATE() AND DATEADD(MONTH, 3, GETDATE())
ORDER BY ExpectedPaymentDate, C