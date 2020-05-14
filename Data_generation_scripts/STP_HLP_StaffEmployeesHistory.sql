CREATE PROCEDURE STP_HLP_StaffEmployeesHistory

AS

BEGIN


IF (OBJECT_ID('Staff.EmployeesHistory') IS NOT NULL) DROP TABLE Staff.EmployeesHistory

CREATE TABLE Staff.EmployeesHistory (
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

END