USE ClinicManagementSqlDb;

SELECT
    m.Name AS MedicineName,
    COUNT(pr.PrescriptionID) AS TimesPrescribed,
    m.UnitPrice,
    SUM(m.UnitPrice) AS EstimatedRevenue
FROM Prescriptions pr
JOIN Medicines m ON pr.MedicineID = m.MedicineID
GROUP BY m.Name, m.UnitPrice
ORDER BY EstimatedRevenue DESC;