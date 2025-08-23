USE ClinicManagementSqlDb;

DECLARE @DoctorID INT = 1;
DECLARE @Today DATE = GETDATE();
DECLARE @WeekLater DATE = DATEADD(DAY, 7, @Today);

SELECT 
    a.AppointmentID,
    p.FirstName + ' ' + p.LastName AS PatientName,
    a.AppointmentDate,
    a.Status,
    a.Reason
FROM Appointments a
JOIN Patients p ON a.PatientID = p.PatientID
WHERE a.DoctorID = @DoctorID
  AND a.AppointmentDate BETWEEN @Today AND @WeekLater
ORDER BY a.AppointmentDate;
