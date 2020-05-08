CREATE SCHEMA Operation
GO

CREATE TABLE Operation.DimClientsCars(
	ClientID NVARCHAR(255),
	FirstName NVARCHAR(255),
	Surname NVARCHAR(255),
	Gender NVARCHAR(255),
	Telephone NVARCHAR(255),
	Email NVARCHAR(255),
	CityName NVARCHAR(255),
	HomeAddress NVARCHAR(255),
	IsCurrent NVARCHAR(255),
	Plate NVARCHAR(255),
	Brand NVARCHAR(255),
	Model NVARCHAR(255),
	CarID NVARCHAR(255)
);

CREATE TABLE Operation.DimTariffs(
	TariffID NVARCHAR(255),
	Tariff NVARCHAR(255),
	City NVARCHAR(255),
	ParkingName NVARCHAR(255),
	ZoneType NVARCHAR(255),
	SlotType NVARCHAR(255),
	Price NVARCHAR(255),
	TariffStartDate NVARCHAR(255),
	TariffEndDate NVARCHAR(255)
);

CREATE TABLE Operation.DimZones(
	ZoneID NVARCHAR(255),
	CityName NVARCHAR(255),
	LotName NVARCHAR(255),
	ZoneTypeName NVARCHAR(255),
	Capacity NVARCHAR(255),
	SlotDescription NVARCHAR(255),
	Adress NVARCHAR(255),
	PhoneNumber NVARCHAR(255),
	Email NVARCHAR(255)
);

CREATE TABLE Operation.FactsOrders(
	OrderID NVARCHAR(255),
	ZoneID NVARCHAR(255),
	CarID NVARCHAR(255),
	IsRegular NVARCHAR(255),
	TariffID NVARCHAR(255),
	DateTimeEntry NVARCHAR(255),
	DateTimeExit NVARCHAR(255),
	HourTimeDifference NVARCHAR(255),
	TotalCost NVARCHAR(255)
)