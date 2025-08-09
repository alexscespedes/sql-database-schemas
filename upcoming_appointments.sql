USE ClinicManagementSqlDb;

SELECT 
    d.FirstName + ' ' + d.LastName AS DoctorName,
    a.AppointmentDate,
    p.FirstName + ' ' + p.LastName AS PatientName,
    a.Status
FROM Appointments a
JOIN Doctors d ON a.DoctorID = d.DoctorID
JOIN Patients p ON a.PatientID = p.PatientID
WHERE a.AppointmentDate >= GETDATE()
ORDER BY d.LastName, a.AppointmentDate;