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


