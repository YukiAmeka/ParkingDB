CREATE DATABASE Lv_501_Anna_DWH_03
GO

USE Lv_501_Anna_DWH_03
GO

CREATE SCHEMA Membership
GO

CREATE TABLE Membership.FactOrders
(
    OrderID INT NOT NULL IDENTITY PRIMARY KEY
    , ZoneID INT -- Where?
    , TariffID INT -- How?
    , AllCardID INT -- What?
    , ClientID INT -- Who?
    , PurchaseDate DATE -- When?
	, PurchaseTime TIME -- When?
    , TotalCost DECIMAL(6,2) -- How much? (Fact)
)

CREATE TABLE Membership.DimZones
(
    ZoneID INT NOT NULL IDENTITY PRIMARY KEY
    , LotName VARCHAR(50)
    , ZoneTypeName VARCHAR(50)
    , Capacity INT
    , SlotDescription VARCHAR(100)
    , CityName VARCHAR(50)
    , Address VARCHAR(50)
    , PhoneNumber CHAR(15)
    , Email VARCHAR(50)
)

CREATE TABLE Membership.DimTariffs
(
    TariffID INT NOT NULL IDENTITY PRIMARY KEY
	, ZoneTypeName VARCHAR(50)
	, SlotDescription VARCHAR(100)
	, LotName VARCHAR(50)
	, CityName VARCHAR(50)
    , PeriodName VARCHAR(20)
    , Price DECIMAL(6,2)
    , TariffStartDate DATE
	, TariffEndDate DATE
)

CREATE TABLE Membership.DimCards
(
    AllCardID INT NOT NULL IDENTITY PRIMARY KEY
    , MemberCardNumber INT
	, ExpiryDate DATE
	, PeriodName VARCHAR(20)
	, ZoneTypeName VARCHAR(50)
	, SlotDescription VARCHAR(100)
	, LotName VARCHAR(50)
	, CityName VARCHAR(50)
)

CREATE TABLE Membership.DimClients
(
    ClientID INT NOT NULL IDENTITY PRIMARY KEY
	, FirstName VARCHAR(100)
	, Surname VARCHAR(100)
	, Gender CHAR(1)
	, Telephone CHAR(15)
	, Email VARCHAR(100)
	, HomeAddress VARCHAR(200)
    , CityName VARCHAR(50)
	, FirstPurchaseDate DATE
	, LatestExpiryDate DATE
)

CREATE TABLE Membership.DimCars
(
    CarID INT NOT NULL IDENTITY PRIMARY KEY
    , Plate CHAR(7)
    , Brand VARCHAR(50)
	, Model VARCHAR(50)
    , ClientID INT
)

CREATE TABLE DimCalendarDates
(
	DateID int PRIMARY KEY IDENTITY(1,1) NOT NULL
	, TheDate date NULL
	, TheDay int NULL
	, TheDayName nvarchar(30) NULL
	, TheWeek int NULL
	, TheISOWeek int NULL
	, TheDayOfWeek int NULL
	, TheMonth int NULL
	, TheMonthName nvarchar(30) NULL
	, TheQuarter int NULL
	, TheYear int NULL
	, TheFirstOfMonth date NULL
	, TheLastOfYear date NULL
	, TheDayOfYear int NULL
)

ALTER TABLE Membership.FactOrders
ADD FOREIGN KEY (ZoneID) REFERENCES Membership.DimZones(ZoneID);

ALTER TABLE Membership.FactOrders
ADD FOREIGN KEY (TariffID) REFERENCES Membership.DimTariffs(TariffID);

ALTER TABLE Membership.FactOrders
ADD FOREIGN KEY (AllCardID) REFERENCES Membership.DimCards(AllCardID);

ALTER TABLE Membership.FactOrders
ADD FOREIGN KEY (ClientID) REFERENCES Membership.DimClients(ClientID);

ALTER TABLE Membership.DimCars
ADD FOREIGN KEY (ClientID) REFERENCES Membership.DimClients(ClientID);