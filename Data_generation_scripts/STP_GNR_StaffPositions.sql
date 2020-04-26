CREATE PROCEDURE STP_GNR_StaffPositions
AS

BEGIN

INSERT INTO Staff.Positions (Title)
	VALUES 
	('Parking attendant'),
	('Parking manager'),
	('Chief manager'),
	('Accountant'),
	('Chief accountant'),
	('Human Resources'),
	('Lawyer');

END