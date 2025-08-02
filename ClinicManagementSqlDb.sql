CREATE DATABASE ClinicManagementSqlDb;

USE ClinicManagementSqlDb;

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(100) NOT NULL,
    Location NVARCHAR(200)
);

CREATE TABLE Specialties (
    SpecialtyID INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(100) NOT NULL
);

CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY IDENTITY,
    FirstName NVARCHAR(100),
    LastName NVARCHAR(100),
    Email NVARCHAR(150) UNIQUE,
    SpecialtyID INT,
    DepartmentID INT,
    FOREIGN KEY (SpecialtyID) REFERENCES Specialties(SpecialtyID),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Patients (
    PatientID INT PRIMARY KEY IDENTITY,
    FirstName NVARCHAR(100),
    LastName NVARCHAR(100),
    DateOfBirth DATE,
    PhoneNumber NVARCHAR(20),
    Email NVARCHAR(150) UNIQUE,
);


CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY IDENTITY,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    AppointmentDate DATETIME NOT NULL,
    Reason NVARCHAR(250),
    Status NVARCHAR(50) CHECK (Status IN ('Scheduled', 'Completed', 'Cancelled')),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

CREATE TABLE Medicines (
    MedicineID INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(250),
    UnitPrice DECIMAL(10,2)
);

CREATE TABLE Prescriptions (
    PrescriptionID INT PRIMARY KEY IDENTITY,
    AppointmentID INT NOT NULL,
    MedicineID INT NOT NULL,
    Dosage NVARCHAR(100),
    Duration NVARCHAR(100),
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID),
    FOREIGN KEY (MedicineID) REFERENCES Medicines(MedicineID)
);
