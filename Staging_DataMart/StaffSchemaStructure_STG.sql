CREATE DATABASE Lv_501_Parking_DataMart_Emp
GO

USE Lv_501_Parking_DataMart_Emp
GO

CREATE SCHEMA Staff
GO 

CREATE TABLE Staff.DimLots (
    LotID NVARCHAR (255) NULL,
    LotName NVARCHAR (255)  NULL,
    CityName NVARCHAR (255) NULL,
    Address NVARCHAR (255) NULL,
    PhoneNumber NVARCHAR (255) NULL,
    Email NVARCHAR (255) NULL
);

CREATE TABLE Staff.DimEmployees (
   EmployeeID NVARCHAR (255) NULL,
   FirstName NVARCHAR (255) NULL,
   Surname NVARCHAR (255) NULL,
   Gender NVARCHAR (255) NULL,
   DateOfBirth NVARCHAR (255) NULL,
   PhoneNumber NVARCHAR (255) NULL,
   Email NVARCHAR (255) NULL,
   CityName NVARCHAR (255) NULL,
   HomeAddress NVARCHAR (255) NULL
);
 

 CREATE TABLE Staff.FactsEmployeesHistory (
   EmployeesHistoryID NVARCHAR (255) NULL,
   BusinessID NVARCHAR (255) NULL,
   Salary NVARCHAR (255) NULL,
   SalaryStartDate NVARCHAR (255) NULL,
   SalaryEndDate NVARCHAR (255) NULL,
   Position NVARCHAR (255) NULL,
   PositionStartDate NVARCHAR (255) NULL,
   PositionEndDate NVARCHAR (255) NULL,
   DateHired NVARCHAR (255) NULL,
   DateFired NVARCHAR (255) NULL,
   LotID NVARCHAR (255) NULL,
   ManagerID NVARCHAR (255) NULL
);


ALTER TABLE Staff.FactsEmployeesHistory
ADD FOREIGN KEY (ManagerID) REFERENCES Staff.DimEmployees(EmployeeID);

ALTER TABLE Staff.FactsEmployeesHistory
ADD FOREIGN KEY (BusinessID) REFERENCES Staff.DimEmployees(EmployeeID);

ALTER TABLE Staff.FactsEmployeesHistory
ADD FOREIGN KEY (LotID) REFERENCES Staff.DimLots(LotID);

