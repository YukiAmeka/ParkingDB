CREATE VIEW VW_STG_StaffDimEmployees

AS

SELECT e.EmployeeID, e.FirstName, e.Surname, e.Gender, e.DateOfBirth, e.PhoneNumber, e.Email, c.CityName, e.HomeAddress
FROM Staff.Employees AS e
JOIN Location.Cities AS c
ON c.CityID = e.CityID