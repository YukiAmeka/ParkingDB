
CREATE SCHEMA Operation
GO

CREATE TABLE Operation.DimClientsCars(
	CarID INT PRIMARY KEY NOT NULL,
	ClientID INT NULL,
	FirstName VARCHAR(100) NULL,
	Surname VARCHAR(100) NULL,
	Gender CHAR(1) NULL,
	Telephone CHAR(15) NULL,
	Email VARCHAR(100) NULL,
	CityName VARCHAR(50) NULL,
	HomeAddress VARCHAR(200) NULL,
	IsRegular BIT NULL,
	Plate CHAR(7) NULL,
	Brand VARCHAR(50) NULL,
	Model VARCHAR(50) NULL	
)

CREATE TABLE Operation.DimTariffs(
	TariffID INT PRIMARY KEY NOT NULL,
	Tariff VARCHAR(50) NULL,
	City VARCHAR(50) NULL,
	ParkingName VARCHAR(50) NULL,
	SlotType VARCHAR(50) NULL,
	Price DECIMAL(10, 2) NULL,
	TariffStartDate DATE NULL,
	TariffEndDate DATE NULL
)

CREATE TABLE Operation.DimZones(
	ZoneID INT PRIMARY KEY NOT NULL,
	CityName VARCHAR(50) NULL,
	LotName VARCHAR(50) NULL,
	Capacity INT NULL,
	SlotDescription VARCHAR(50) NULL,
	Adress VARCHAR(50) NULL,
	PhoneNumber VARCHAR(30) NULL,
	Email VARCHAR(50) NULL
)
CREATE TABLE Operation.FactsOrders(
	OrderID INT PRIMARY KEY NOT NULL,
	ZoneID INT NULL,
	CarID INT NULL,
	IsRegular BIT NULL,
	TariffID INT NULL,
	DateTimeEntry DATETIME NULL,
	DateTimeExit DATETIME NULL,
	HourTimeDifference INT NULL,
	TotalCost DECIMAL(10, 2) NULL
)

ALTER TABLE Operation.FactsOrders
ADD FOREIGN KEY (ZoneID) REFERENCES Operation.DimZones(ZoneID);

ALTER TABLE Operation.FactsOrders
ADD FOREIGN KEY (CarID) REFERENCES Operation.DimClientsCars(CarID);

ALTER TABLE Operation.FactsOrders
ADD FOREIGN KEY (TariffID) REFERENCES Operation.DimTariffs(TariffID);