USE ClinicManagementSqlDb;

INSERT INTO Departments (Name, Location) 
VALUES 
('Cardiology', 'Building A - Floor 2'),
('Dermatology', 'Building B - Floor 1'),
('Pediatrices', 'Building C - Floor 3');

SELECT * FROM Departments;

INSERT INTO Specialties (Name) 
VALUES 
('Cardiologist'),
('Dermatologist'),
('Pediatrician');

SELECT * FROM Specialties;

INSERT INTO Doctors (FirstName, LastName, Email, SpecialtyID, DepartmentID)
VALUES
('John', 'Smith', 'john.smith@clinic.com', 1, 1),
('Emely', 'Brown', 'emely.brown@clinic.com', 2, 2),
('Michael', 'Lee', 'michael.lee@clinic.com', 3, 3);

SELECT * FROM Doctors;

INSERT INTO Patients (FirstName, LastName, DateOfBirth, PhoneNumber, Email)
VALUES
('Ana', 'Martinez', '1990-04-12', '555-1234', 'ana.martinezh@email.com'),
('David', 'Wilson', '1985-11-03', '555-5678', 'david.wilson@email.com'),
('Sophia', 'Garcia', '2015-06-22', '555-8765', 'sophia.garcia@email.com');

SELECT * FROM Patients;

INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, Reason, Status)
VALUES
(1, 1, '2025-08-19 09:30', 'Chest pain', 'Scheduled'),
(2, 2, '2025-08-11 14:00', 'Skin rash', 'Scheduled'),
(3, 3, '2025-08-12 10:00', 'Routine check-up', 'Scheduled');

SELECT * FROM Appointments;

INSERT INTO Medicines (Name, Description, UnitPrice) 
VALUES 
('Aspirin', 'Pain reliever', 5.50),
('Hydrocortisone Cream', 'Topical anti-inflammatory', 12.75),
('Amoxicilin', 'Antibiotic', 8.00);

SELECT * FROM Medicines;

INSERT INTO Prescriptions (AppointmentID, MedicineID, Dosage, Duration) 
VALUES 
(1, 1, '1 tablet every 8 hours', '7 days'),
(2, 2, 'Apply twice daily', '10 days'),
(3, 3, '500mg every 12 hours', '5 days');

SELECT * FROM Prescriptions;
