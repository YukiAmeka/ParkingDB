CREATE DATABASE Lv_501_Parking_DataMart_Emp
GO

USE Lv_501_Parking_DataMart_Emp
GO

CREATE SCHEMA Staff
GO 

CREATE TABLE Staff.DimLots (
    LotID int NOT NULL PRIMARY KEY IDENTITY,
    LotName varchar (50)  NULL,
    CityName VARCHAR(30) NULL,
    Address varchar(50) NULL,
    PhoneNumber varchar (30) NULL,
    Email varchar (50) NULL
);

CREATE TABLE Staff.DimEmployees (
   EmployeeID int NOT NULL PRIMARY KEY IDENTITY,
   FirstName varchar(50) NULL,
   Surname varchar(50) NULL,
   Gender char(1) NULL,
   DateOfBirth date NULL,
   PhoneNumber varchar(50) NULL,
   Email varchar(100) NULL,
   CityName VARCHAR (30) NULL,
   HomeAddress varchar(200) NULL
);
 

 CREATE TABLE Staff.FactsEmployeesHistory (
   EmployeesHistoryID int NOT NULL PRIMARY KEY IDENTITY,
   BusinessID INT NULL,
   Salary decimal(8,2) NULL,
   SalaryStartDate DATE NULL,
   SalaryEndDate DATE NULL,
   Position VARCHAR(30) NULL,
   PositionStartDate DATE NULL,
   PositionEndDate DATE NULL,
   DateHired DATE NULL,
   DateFired DATE NULL,
   LotID int NULL,
   ManagerID int NULL
);


ALTER TABLE Staff.FactsEmployeesHistory
ADD FOREIGN KEY (ManagerID) REFERENCES Staff.DimEmployees(EmployeeID);

ALTER TABLE Staff.FactsEmployeesHistory
ADD FOREIGN KEY (BusinessID) REFERENCES Staff.DimEmployees(EmployeeID);

ALTER TABLE Staff.FactsEmployeesHistory
ADD FOREIGN KEY (LotID) REFERENCES Staff.DimLots(LotID);

