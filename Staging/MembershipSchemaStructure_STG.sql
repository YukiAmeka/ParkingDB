
CREATE SCHEMA Membership
GO

CREATE TABLE Membership.FactsOrders
(
    OrderID NVARCHAR(255)
    , ZoneID NVARCHAR(255)
    , TariffID NVARCHAR(255)
    , AllCardID NVARCHAR(255)
    , ClientID NVARCHAR(255)
    , PurchaseDate NVARCHAR(255)
	, PurchaseTime NVARCHAR(255)
    , TotalCost NVARCHAR(255)
)

CREATE TABLE Membership.DimZones
(
    ZoneID NVARCHAR(255)
    , LotName NVARCHAR(255)
    , ZoneTypeName NVARCHAR(255)
    , Capacity NVARCHAR(255)
    , SlotDescription NVARCHAR(255)
    , CityName NVARCHAR(255)
    , Address NVARCHAR(255)
    , PhoneNumber NVARCHAR(255)
    , Email NVARCHAR(255)
)

CREATE TABLE Membership.DimTariffs
(
    TariffID NVARCHAR(255)
	, ZoneTypeName NVARCHAR(255)
	, SlotDescription NVARCHAR(255)
	, LotName NVARCHAR(255)
	, CityName NVARCHAR(255)
    , PeriodName NVARCHAR(255)
    , Price NVARCHAR(255)
    , TariffStartDate NVARCHAR(255)
	, TariffEndDate NVARCHAR(255)
)

CREATE TABLE Membership.DimCards
(
    AllCardID NVARCHAR(255)
    , MemberCardNumber NVARCHAR(255)
	, ExpiryDate NVARCHAR(255)
	, PeriodName NVARCHAR(255)
	, ZoneTypeName NVARCHAR(255)
	, SlotDescription NVARCHAR(255)
	, LotName NVARCHAR(255)
	, CityName NVARCHAR(255)
)

CREATE TABLE Membership.DimClients
(
    ClientID NVARCHAR(255)
	, FirstName NVARCHAR(255)
	, Surname NVARCHAR(255)
	, Gender NVARCHAR(255)
	, Telephone NVARCHAR(255)
	, Email NVARCHAR(255)
	, HomeAddress NVARCHAR(255)
    , CityName NVARCHAR(255)
	, FirstPurchaseDate NVARCHAR(255)
	, LatestExpiryDate NVARCHAR(255)
)

CREATE TABLE Membership.DimCars
(
    CarID NVARCHAR(255)
    , Plate NVARCHAR(255)
    , Brand NVARCHAR(255)
	, Model NVARCHAR(255)
    , ClientID NVARCHAR(255)
)
