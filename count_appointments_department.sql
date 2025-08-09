USE ClinicManagementSqlDb;

SELECT
    dep.Name AS Department,
    COUNT(a.AppointmentID) AS TotalAppoinments
FROM Appointments a
JOIN Doctors doc ON a.DoctorID = doc.DoctorID
JOIN Departments dep ON doc.DepartmentID = dep.DepartmentID
GROUP BY dep.Name
ORDER BY TotalAppoinments DESC;


-- SELECT * FROM Doctors;