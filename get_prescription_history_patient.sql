USE ClinicManagementSqlDb;

DECLARE @PatientID INT = 1;

SELECT
    pr.PrescriptionID,
    m.Name AS MedicineID,
    pr.Dosage,
    pr.Duration,
    a.AppointmentDate,
    d.FirstName + ' ' + d.LastName AS PrescribedBy
FROM Prescriptions pr
JOIN Medicines m ON pr.MedicineID = m.MedicineID
JOIN Appointments a ON pr.AppointmentID = a.AppointmentID
JOIN Doctors d ON a.DoctorID = d.DoctorID
WHERE a.PatientID = @PatientID
ORDER BY a.AppointmentDate DESC;