﻿USE [master]
GO
/****** Object:  Database [Lv_501_Parking_DataMart]    Script Date: 5/6/2020 11:34:12 AM ******/
CREATE DATABASE [Lv_501_Parking_DataMart]
GO
USE [Lv_501_Parking_DataMart]
GO
/****** Object:  Schema [Membership]    Script Date: 5/6/2020 11:34:12 AM ******/
CREATE SCHEMA [Membership]
GO
/****** Object:  Schema [Operation]    Script Date: 5/6/2020 11:34:12 AM ******/
CREATE SCHEMA [Operation]
GO
/****** Object:  Schema [Staff]    Script Date: 5/6/2020 11:34:12 AM ******/
CREATE SCHEMA [Staff]
GO
/****** Object:  Table [dbo].[DimCalendarDates]    Script Date: 5/6/2020 11:34:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimCalendarDates](
	[DateID] [int] IDENTITY(1,1) NOT NULL,
	[TheDate] [date] NULL,
	[TheDay] [int] NULL,
	[TheDayName] [nvarchar](30) NULL,
	[TheWeek] [int] NULL,
	[TheISOWeek] [int] NULL,
	[TheDayOfWeek] [int] NULL,
	[TheMonth] [int] NULL,
	[TheMonthName] [nvarchar](30) NULL,
	[TheQuarter] [int] NULL,
	[TheYear] [int] NULL,
	[TheFirstOfMonth] [date] NULL,
	[TheLastOfYear] [date] NULL,
	[TheDayOfYear] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[DateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Membership].[DimCards]    Script Date: 5/6/2020 11:34:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Membership].[DimCards](
	[AllCardID] [int] IDENTITY(1,1) NOT NULL,
	[MemberCardNumber] [int] NULL,
	[ExpiryDate] [date] NULL,
	[PeriodName] [varchar](20) NULL,
	[ZoneTypeName] [varchar](50) NULL,
	[SlotDescription] [varchar](100) NULL,
	[LotName] [varchar](50) NULL,
	[CityName] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[AllCardID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Membership].[DimCars]    Script Date: 5/6/2020 11:34:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Membership].[DimCars](
	[CarID] [int] IDENTITY(1,1) NOT NULL,
	[Plate] [char](7) NULL,
	[Brand] [varchar](50) NULL,
	[Model] [varchar](50) NULL,
	[ClientID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CarID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Membership].[DimClients]    Script Date: 5/6/2020 11:34:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Membership].[DimClients](
	[ClientID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](100) NULL,
	[Surname] [varchar](100) NULL,
	[Gender] [char](1) NULL,
	[Telephone] [char](15) NULL,
	[Email] [varchar](100) NULL,
	[HomeAddress] [varchar](200) NULL,
	[CityName] [varchar](50) NULL,
	[FirstPurchaseDate] [date] NULL,
	[LatestExpiryDate] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[ClientID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Membership].[DimTariffs]    Script Date: 5/6/2020 11:34:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Membership].[DimTariffs](
	[TariffID] [int] IDENTITY(1,1) NOT NULL,
	[ZoneTypeName] [varchar](50) NULL,
	[SlotDescription] [varchar](100) NULL,
	[LotName] [varchar](50) NULL,
	[CityName] [varchar](50) NULL,
	[PeriodName] [varchar](20) NULL,
	[Price] [decimal](6, 2) NULL,
	[TariffStartDate] [date] NULL,
	[TariffEndDate] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[TariffID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Membership].[DimZones]    Script Date: 5/6/2020 11:34:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Membership].[DimZones](
	[ZoneID] [int] IDENTITY(1,1) NOT NULL,
	[LotName] [varchar](50) NULL,
	[ZoneTypeName] [varchar](50) NULL,
	[Capacity] [int] NULL,
	[SlotDescription] [varchar](100) NULL,
	[CityName] [varchar](50) NULL,
	[Address] [varchar](50) NULL,
	[PhoneNumber] [char](15) NULL,
	[Email] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[ZoneID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Membership].[FactOrders]    Script Date: 5/6/2020 11:34:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Membership].[FactOrders](
	[OrderID] [int] IDENTITY(1,1) NOT NULL,
	[ZoneID] [int] NULL,
	[TariffID] [int] NULL,
	[AllCardID] [int] NULL,
	[ClientID] [int] NULL,
	[PurchaseDate] [date] NULL,
	[PurchaseTime] [time](7) NULL,
	[TotalCost] [decimal](6, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Operation].[DimClientsCars]    Script Date: 5/6/2020 11:34:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Operation].[DimClientsCars](
	[ClientID] [int] NULL,
	[FirstName] [varchar](100) NULL,
	[Surname] [varchar](100) NULL,
	[Gender] [char](1) NULL,
	[Telephone] [char](15) NULL,
	[Email] [varchar](100) NULL,
	[CityName] [varchar](50) NULL,
	[HomeAddress] [varchar](200) NULL,
	[CurrentMember] [bit] NULL,
	[Plate] [char](7) NULL,
	[Brand] [varchar](50) NULL,
	[Model] [varchar](50) NULL,
	[CarID] [int] IDENTITY(1,1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CarID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Operation].[DimTariffs]    Script Date: 5/6/2020 11:34:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Operation].[DimTariffs](
	[TariffID] [int] IDENTITY(1,1) NOT NULL,
	[Tariff] [varchar](50) NULL,
	[Citi] [varchar](50) NULL,
	[ParkingName] [varchar](50) NULL,
	[SlotType] [varchar](50) NULL,
	[Price] [decimal](10, 2) NULL,
	[TariffStartDate] [date] NULL,
	[TariffEndDate] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[TariffID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Operation].[DimZones]    Script Date: 5/6/2020 11:34:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Operation].[DimZones](
	[ZoneID] [int] IDENTITY(1,1) NOT NULL,
	[CityName] [varchar](50) NULL,
	[LotName] [varchar](50) NULL,
	[Capacity] [int] NULL,
	[SlotDescription] [varchar](50) NULL,
	[Adress] [varchar](50) NULL,
	[PhoneNumber] [varchar](30) NULL,
	[Email] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[ZoneID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Operation].[FactsOrders]    Script Date: 5/6/2020 11:34:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Operation].[FactsOrders](
	[OrderID] [int] IDENTITY(1,1) NOT NULL,
	[ZoneID] [int] NULL,
	[CarID] [int] NULL,
	[IsCurrent] [bit] NULL,
	[TariffID] [int] NULL,
	[DateTimeEntry] [datetime] NULL,
	[DateTimeExit] [datetime] NULL,
	[HourTimeDifference] [int] NULL,
	[TotalCost] [decimal](10, 2) NULL,
 CONSTRAINT [PK__Facts_Op__C3905BAFEE7287E3] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Staff].[DimEmployees]    Script Date: 5/6/2020 11:34:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staff].[DimEmployees](
	[EmployeeID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](50) NULL,
	[Surname] [varchar](50) NULL,
	[Gender] [char](1) NULL,
	[DateOfBirth] [date] NULL,
	[PhoneNumber] [varchar](50) NULL,
	[Email] [varchar](100) NULL,
	[CityName] [varchar](30) NULL,
	[HomeAddress] [varchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Staff].[DimLots]    Script Date: 5/6/2020 11:34:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staff].[DimLots](
	[LotID] [int] IDENTITY(1,1) NOT NULL,
	[LotName] [varchar](50) NULL,
	[CityName] [varchar](30) NULL,
	[Address] [varchar](50) NULL,
	[PhoneNumber] [varchar](30) NULL,
	[Email] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[LotID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Staff].[FactsEmployeesHistory]    Script Date: 5/6/2020 11:34:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staff].[FactsEmployeesHistory](
	[EmployeesHistoryID] [int] IDENTITY(1,1) NOT NULL,
	[BusinessID] [int] NULL,
	[Salary] [decimal](8, 2) NULL,
	[SalaryStartDate] [date] NULL,
	[SalaryEndDate] [date] NULL,
	[Position] [varchar](30) NULL,
	[PositionStartDate] [date] NULL,
	[PositionEndDate] [date] NULL,
	[DateHired] [date] NULL,
	[DateFired] [date] NULL,
	[LotID] [int] NULL,
	[ManagerID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[EmployeesHistoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [Membership].[DimCars]  WITH CHECK ADD FOREIGN KEY([ClientID])
REFERENCES [Membership].[DimClients] ([ClientID])
GO
ALTER TABLE [Membership].[FactOrders]  WITH CHECK ADD FOREIGN KEY([AllCardID])
REFERENCES [Membership].[DimCards] ([AllCardID])
GO
ALTER TABLE [Membership].[FactOrders]  WITH CHECK ADD FOREIGN KEY([ClientID])
REFERENCES [Membership].[DimClients] ([ClientID])
GO
ALTER TABLE [Membership].[FactOrders]  WITH CHECK ADD FOREIGN KEY([TariffID])
REFERENCES [Membership].[DimTariffs] ([TariffID])
GO
ALTER TABLE [Membership].[FactOrders]  WITH CHECK ADD FOREIGN KEY([ZoneID])
REFERENCES [Membership].[DimZones] ([ZoneID])
GO
ALTER TABLE [Operation].[FactsOrders]  WITH CHECK ADD  CONSTRAINT [FK_Facts_OperationOrders_Dim_OpeationTariffs] FOREIGN KEY([TariffID])
REFERENCES [Operation].[DimTariffs] ([TariffID])
GO
ALTER TABLE [Operation].[FactsOrders] CHECK CONSTRAINT [FK_Facts_OperationOrders_Dim_OpeationTariffs]
GO
ALTER TABLE [Operation].[FactsOrders]  WITH CHECK ADD  CONSTRAINT [FK_Facts_OperationOrders_Dim_Zones] FOREIGN KEY([ZoneID])
REFERENCES [Operation].[DimZones] ([ZoneID])
GO
ALTER TABLE [Operation].[FactsOrders] CHECK CONSTRAINT [FK_Facts_OperationOrders_Dim_Zones]
GO
ALTER TABLE [Staff].[FactsEmployeesHistory]  WITH CHECK ADD FOREIGN KEY([BusinessID])
REFERENCES [Staff].[DimEmployees] ([EmployeeID])
GO
ALTER TABLE [Staff].[FactsEmployeesHistory]  WITH CHECK ADD FOREIGN KEY([LotID])
REFERENCES [Staff].[DimLots] ([LotID])
GO
ALTER TABLE [Staff].[FactsEmployeesHistory]  WITH CHECK ADD FOREIGN KEY([ManagerID])
REFERENCES [Staff].[DimEmployees] ([EmployeeID])

