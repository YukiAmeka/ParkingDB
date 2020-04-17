USE [Lv_501_Parking_TEST5]
GO
/****** Object:  StoredProcedure [dbo].[STP_InsertDataSlots]    Script Date: 4/17/2020 4:35:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[STP_InsertDataSlots]
AS

DECLARE @cap INT --capacity of each zone
DECLARE @SLOT INT --slot number of each slot
DECLARE @ZONE INT --zoneID
SET @ZONE = (SELECT TOP 1 ZONEID FROM Parking.Zones) 
SET @SLOT = 1
SET @cap = (SELECT capacity FROM parking.zones WHERE ZONEID = @ZONE)

WHILE @zONE<(SELECT IDENT_CURRENT('parking.zones'))+1 --last inserted ZoneID + 1
IF @CAP = 0
	BEGIN
	SET @ZONE = @ZONE + 1
	SET @CAP = (SELECT capacity FROM parking.zones WHERE ZONEID = @ZONE)
	SET @SLOT = 1
	END
ELSE WHILE @cap>0
	BEGIN
	INSERT INTO Parking.SLOTS (SlotNumber,ZoneID) VALUES
		(@SLOT, @ZONE)
	SET @CAP = @CAP - 1
	SET @SLOT = @SLOT + 1
	END