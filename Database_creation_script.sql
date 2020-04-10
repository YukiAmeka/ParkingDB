CREATE DATABASE Lv_501_Parking_TEST1;
GO
USE Lv_501_Parking_TEST1
GO
CREATE SCHEMA Parking;
GO
CREATE SCHEMA Location;
GO
CREATE SCHEMA Staff;
GO
CREATE SCHEMA Operation;
GO
CREATE SCHEMA Clientele;
GO
CREATE SCHEMA Membership;
GO
CREATE SCHEMA Services
GO

CREATE TABLE Parking.Lots (
    LotID int NOT NULL PRIMARY KEY IDENTITY,
    LotName varchar (50)  NULL,
    PriceIndex decimal (4,2) CONSTRAINT DEF_ParkingLots_PriceIndex DEFAULT 1.0,
    CityID int NULL,
    Address varchar(50),
    ManagerId int  NULL,
    PhoneNumber varchar (30) NULL,
    Email varchar (50) NULL
);

CREATE TABLE Parking.Slots (
  SlotID int NOT NULL PRIMARY KEY IDENTITY,
  IsOccupied bit CONSTRAINT DEF_ParkingSlots_IsOccupied DEFAULT 'FALSE',
  SlotNumber int NULL,
  ZoneID int NOT NULL
);

CREATE TABLE Parking.Zones (
  ZoneID int NOT NULL PRIMARY KEY IDENTITY,
  Capacity int NULL,
  LotID int NOT NULL,
  ZoneTypeID int NOT NULL
);

CREATE TABLE Parking.ZoneTypes(
    ZoneTypeID int NOT NULL PRIMARY KEY IDENTITY,
    ZoneTypeName varchar(50) NULL,
    SlotSizeID int NOT NULL
);

CREATE TABLE Parking.SlotSizes (
    SlotSizeID int NOT NULL PRIMARY KEY IDENTITY,
    SlotDescription VARCHAR(20)
)


CREATE TABLE Location.Cities (
    CityID int NOT NULL PRIMARY KEY IDENTITY,
    CityName varchar(50) NOT NULL
	);

	CREATE TABLE Staff.Employees (
   EmployeeID int NOT NULL PRIMARY KEY IDENTITY,
   FirstName varchar(50) NOT NULL,
   Surname varchar(50) NOT NULL,
   PatronymicName varchar(50),
   Gender varchar(1),
   DateOfBirth date,
   PhoneNumber varchar(15),
   Email varchar(30),
   CityID int,
   HomeAddress varchar(200),
   LotID int,
   DateHired int,
   PositionID int,
   Salary decimal(8,2),
   ManagerID int,
   DateFired int
)

CREATE TABLE Staff.Shifts (
    ShiftID int NOT NULL PRIMARY KEY IDENTITY,
    EmployeeID int NULL,
    DateStart int NULL,
    TimeStart time(7) NULL,
    DateEnd int NULL,
    TimeEnd time(7) NULL
);

CREATE TABLE Staff.Positions (
   PositionID int NOT NULL PRIMARY KEY IDENTITY,
   Title varchar(50) NOT NULL
)

CREATE TABLE Staff.PositionChanges (
    PositionChangeID int NOT NULL PRIMARY KEY IDENTITY,
    EmployeeID int NOT NULL,
    PositionID int NULL,
    PositionStartDateID int NULL,
    PositionEndDateID int NULL
);

CREATE TABLE Staff.SalaryChanges (
   SalaryChangeID int NOT NULL PRIMARY KEY IDENTITY,
   EmployeeID int,
   Salary decimal(8,2),
   SalaryStartDateID int,
   SalaryEndDateID int,
   ChangeRatio decimal(5,2)
)

CREATE TABLE Clientele.Clients (
ClientID int NOT NULL PRIMARY KEY IDENTITY,
FirstName varchar(20) NOT NULL,
Surname varchar(20) NOT NULL,
Telephone varchar(20),
Email varchar(50),
HomeAddress varchar(50),
CityID int,
ClientTypeID int,
);



CREATE TABLE Clientele.CarModels(
CarModelID int not null PRIMARY KEY IDENTITY,
Model varchar(30),
Brand varchar (30)
);

CREATE TABLE Clientele.Cars(
CarID int not null PRIMARY KEY IDENTITY,
Plate varchar(20),
ClientID int,
CarModelID int
);

CREATE TABLE Membership.Cards (
    CardID INT NOT NULL PRIMARY KEY IDENTITY,
    ClientID INT NOT NULL,
    MemberCardNumber INT NOT NULL,
    TariffID INT NOT NULL,
    StartDate INT NOT NULL,
    ExpiryDate INT NOT NULL
)

CREATE TABLE Membership.Tariffs (
    TariffID INT NOT NULL PRIMARY KEY IDENTITY,
    ZoneID INT NOT NULL,
    DayTimeID INT NOT NULL,
    PeriodID INT NOT NULL,
    IsVip bit NOT NULL DEFAULT 0,
    Price decimal(6,2) NOT NULL
)

CREATE TABLE Membership.Periods (
    PeriodID INT NOT NULL PRIMARY KEY IDENTITY,
    PeriodName varchar (10) NOT NULL
)

CREATE TABLE Membership.DayTimes (
    DayTimeID INT NOT NULL PRIMARY KEY IDENTITY,
    TypeName varchar (10) NOT NULL
);

CREATE TABLE Membership.Orders (
   OrderID int NOT NULL PRIMARY KEY IDENTITY,
   LotID int NOT NULL,
   EmployeeID int NOT NULL,
   CardID int NOT NULL,
   ClientID int NOT NULL,
   PurchaseDate int NOT NULL,
   PurchaseTime time(7) NOT NULL,
   TariffID int NOT NULL,
   Discount decimal(5, 2) NOT NULL DEFAULT 0,
   TotalCost decimal(6, 2) NOT NULL
);

CREATE TABLE Operation.Orders(
    OrderID int NOT NULL PRIMARY KEY IDENTITY,
       ZoneID int NOT NULL,
    CarID int NOT NULL,
     EmployeeOnEntry int,
     EmployeeOnExit int,
DateEntry int NOT NULL,
    DateExit int NOT NULL,
    TotalCost decimal(6, 2) NOT NULL,
    CardID int NULL );

CREATE TABLE Operation.Tariffs (
    TariffID INT PRIMARY KEY IDENTITY NOT NULL,
    TariffNameID INT NOT NULL,
    IsWeekend bit,
    TariffStartDate INT NOT NULL,
    TariffEndDate INT NOT NULL,
    Price decimal(10,2) NOT NULL,
    ZoneID INT NOT NULL);



CREATE TABLE Operation.TariffNames (
    TariffNameID INT PRIMARY KEY IDENTITY NOT NULL,
    Name VARCHAR( 30) NOT NULL,
    [Description] VARCHAR(50) NULL);


	DECLARE @StartDate  date = '20100101';

DECLARE @CutoffDate date = DATEADD(DAY, -1, DATEADD(YEAR, 20, @StartDate));

;WITH seq(n) AS
(
  SELECT 0 UNION ALL SELECT n + 1 FROM seq
  WHERE n < DATEDIFF(DAY, @StartDate, @CutoffDate)
),
d(d) AS
(
  SELECT DATEADD(DAY, n, @StartDate) FROM seq
),
src AS
(
  SELECT
    TheDate         = CONVERT(date, d),
    TheDay          = DATEPART(DAY,       d),
    TheDayName      = DATENAME(WEEKDAY,   d),
    TheWeek         = DATEPART(WEEK,      d),
    TheISOWeek      = DATEPART(ISO_WEEK,  d),
    TheDayOfWeek    = DATEPART(WEEKDAY,   d),
    TheMonth        = DATEPART(MONTH,     d),
    TheMonthName    = DATENAME(MONTH,     d),
    TheQuarter      = DATEPART(Quarter,   d),
    TheYear         = DATEPART(YEAR,      d),
    TheFirstOfMonth = DATEFROMPARTS(YEAR(d), MONTH(d), 1),
    TheLastOfYear   = DATEFROMPARTS(YEAR(d), 12, 31),
    TheDayOfYear    = DATEPART(DAYOFYEAR, d)
  FROM d
)
SELECT * INTO Services.CalendarDates
FROM src
OPTION (MAXRECURSION 8000);


ALTER TABLE Services.CalendarDates
ADD  DateID int not null PRIMARY KEY IDENTITY

ALTER TABLE Staff.Employees
ADD FOREIGN KEY (DateHired) REFERENCES Services.CalendarDates(DateID)

ALTER TABLE Staff.Employees
ADD FOREIGN KEY (DateFired) REFERENCES Services.CalendarDates(DateID)

ALTER TABLE Staff.Employees
ADD FOREIGN KEY (PositionID) REFERENCES Staff.Positions(PositionID)

ALTER TABLE Staff.PositionChanges
ADD FOREIGN KEY (PositionID) REFERENCES Staff.Positions(PositionID)

--(reference PositionChanges --> Employees)
ALTER TABLE Staff.PositionChanges
ADD FOREIGN KEY (EmployeeID) REFERENCES Staff.Employees(EmployeeID)


--(reference PositionChanges --> CalendarDates)
ALTER TABLE Staff.PositionChanges
ADD FOREIGN KEY (PositionStartDateID) REFERENCES Services.CalendarDates(DateID)

--(reference PositionChanges --> CalendarDates)
ALTER TABLE Staff.PositionChanges
ADD FOREIGN KEY (PositionEndDateID) REFERENCES Services.CalendarDates(DateID)


ALTER TABLE Staff.Employees
ADD FOREIGN KEY (LotID) REFERENCES Parking.Lots(LotID)

ALTER TABLE Staff.Employees
ADD FOREIGN KEY (CityID) REFERENCES Location.Cities(CityID)








ALTER TABLE Staff.Shifts
ADD FOREIGN KEY (EmployeeID) REFERENCES Staff.Employees(EmployeeID)

--(reference Employee --> SalaryChanges)
ALTER TABLE Staff.SalaryChanges
ADD FOREIGN KEY (EmployeeID) REFERENCES Staff.Employees(EmployeeID)

--(reference CalendarDate --> Shifts)
ALTER TABLE Staff.Shifts
ADD FOREIGN KEY (DateStart) REFERENCES Services.CalendarDates(DateID)

--(reference CalendarDate --> Shifts)
ALTER TABLE Staff.Shifts
ADD FOREIGN KEY (DateEnd) REFERENCES Services.CalendarDates(DateID)




ALTER TABLE Clientele.Cars
ADD FOREIGN KEY (CarModelID) REFERENCES Clientele.CarModels(CarModelID)


ALTER TABLE Clientele.Cars
ADD FOREIGN KEY (ClientID) REFERENCES Clientele.Clients(ClientID)

ALTER TABLE Clientele.Clients
ADD FOREIGN KEY (CityID) REFERENCES Location.Cities(CityID)




ALTER TABLE Operation.Orders
ADD FOREIGN KEY (CardID) REFERENCES Membership.Cards(CardID)

ALTER TABLE Operation.Orders
ADD FOREIGN KEY (CarID) REFERENCES Clientele.Cars(CarID)




ALTER TABLE Operation.Orders
ADD FOREIGN KEY (EmployeeOnEntry) REFERENCES Staff.Employees(EmployeeID)





ALTER TABLE Operation.Orders
ADD FOREIGN KEY (EmployeeOnExit) REFERENCES Staff.Employees(EmployeeID)

ALTER TABLE Operation.Orders
ADD FOREIGN KEY (DateEntry) REFERENCES Services.CalendarDates(DateID)

ALTER TABLE Operation.Orders
ADD FOREIGN KEY (DateExit) REFERENCES Services.CalendarDates(DateID)

ALTER TABLE Clientele.Clients
ADD FOREIGN KEY (CityID) REFERENCES Location.Cities(CityID)





ALTER TABLE Operation.Orders
 ADD FOREIGN KEY (ZoneID) REFERENCES Parking.Zones(ZoneID);


ALTER TABLE Operation.Tariffs
 ADD FOREIGN KEY(ZoneID) REFERENCES Parking.Zones(ZoneID);



ALTER TABLE Operation.Tariffs
 ADD FOREIGN KEY (TariffNameID) REFERENCES Operation.TariffNames(TariffNameID);

 ALTER TABLE Operation.Orders
 ADD FOREIGN KEY (ZoneID) REFERENCES Parking.Zones(ZoneID);


ALTER TABLE Operation.Tariffs
 ADD FOREIGN KEY(ZoneID) REFERENCES Parking.Zones(ZoneID);



ALTER TABLE Operation.Tariffs
 ADD FOREIGN KEY (TariffNameID) REFERENCES Operation.TariffNames(TariffNameID);


--(reference CalendarDate --> Operation.Tariffs)
ALTER TABLE Operation.Tariffs
ADD FOREIGN KEY (TariffStartDate) REFERENCES Services.CalendarDates(DateID)

--(reference CalendarDate --> Operation.HourlyTariffs)
ALTER TABLE Operation.Tariffs
ADD FOREIGN KEY (TariffEndDate) REFERENCES Services.CalendarDates(DateID)







ALTER TABLE Parking.Lots
ADD FOREIGN KEY (CityID) REFERENCES Location.Cities(CityID)

ALTER TABLE Parking.Lots
    ADD FOREIGN KEY (ManagerId) REFERENCES Staff.Employees(EmployeeID)


--(reference ParkingZones --> ParkingLots)
ALTER TABLE Parking.Zones
    ADD FOREIGN KEY (LotID) REFERENCES Parking.Lots (LotID)


--(reference ParkingZones --> ZoneTypes)
ALTER TABLE Parking.Zones
    ADD FOREIGN KEY (ZoneTypeID) REFERENCES Parking.ZoneTypes (ZoneTypeID)


--(reference Parking.Slots --> ParkingZones)
ALTER TABLE Parking.Slots
    ADD FOREIGN KEY (ZoneID) REFERENCES Parking.Zones (ZoneID)


--(reference ZoneTypes --> SlotSizes)
ALTER TABLE Parking.ZoneTypes
    ADD FOREIGN KEY (SlotSizeID) REFERENCES Parking.SlotSizes (SlotSizeID)














	--(link Clients --> Membership.Cards )
ALTER TABLE Membership.Cards
ADD FOREIGN KEY (ClientID) REFERENCES Clientele.Clients(ClientID);

--(link Membership.Tariffs --> Membership.Cards )
ALTER TABLE Membership.Cards
ADD FOREIGN KEY (TariffID) REFERENCES Membership.Tariffs(TariffID);

--(link Parking.Zones --> Membership.Tariffs)
ALTER TABLE Membership.Tariffs
ADD FOREIGN KEY (ZoneID) REFERENCES Parking.Zones(ZoneID);

--(link Membership.DayTimes --> Membership.Tariffs)
ALTER TABLE Membership.Tariffs
ADD FOREIGN KEY (DayTimeID) REFERENCES Membership.DayTimes(DayTimeID);

--(link Membership.Periods --> Membership.Tariffs )
ALTER TABLE Membership.Tariffs
ADD FOREIGN KEY (PeriodID) REFERENCES Membership.Periods(PeriodID);

--(link CALENDAR!!!!!!!!!!!)
--(link Services.CalendarDates --> Membership.Cards )
ALTER TABLE Membership.Cards
ADD FOREIGN KEY (StartDate) REFERENCES Services.CalendarDates(DateID)


--(link CALENDAR!!!!!!!!!!!)
--(link Services.CalendarDates --> Membership.Cards )
ALTER TABLE Membership.Cards
ADD FOREIGN KEY (ExpiryDate) REFERENCES Services.CalendarDates(DateID)



--(reference ParkingLot --> Membership.Orders)
ALTER TABLE Membership.Orders
ADD FOREIGN KEY (LotID) REFERENCES Parking.Lots(LotID)


--(reference Employee --> Membership.Orders)
ALTER TABLE Membership.Orders
ADD FOREIGN KEY (EmployeeID) REFERENCES Staff.Employees(EmployeeID)





--(reference MembershipCard --> Membership.Orders)
ALTER TABLE Membership.Orders
ADD FOREIGN KEY (CardID) REFERENCES Membership.Cards(CardID)



--(reference MembershipTariff --> Membership.Orders)
ALTER TABLE Membership.Orders
ADD FOREIGN KEY (TariffID) REFERENCES Membership.Tariffs(TariffID)

--(reference CalendarDate --> Membership.Orders)
ALTER TABLE Membership.Orders
ADD FOREIGN KEY (PurchaseDate) REFERENCES Services.CalendarDates(DateID)

