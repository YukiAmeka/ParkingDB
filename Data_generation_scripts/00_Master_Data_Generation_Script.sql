/* Helper procedures */
/* CREATE FIRST. DO NOT EXECUTE */

-- STP_HLP_OldOperationTariffs
-- STP_HLP_GenerateRandomTime - Generate random time within given limits
-- STP_HLP_FindEmployeeOnShift - Find the Employee who is/was on shift at a given Parking Lot at a given date & time
-- STP_HLP_OldMembershipTariffs
-- STP_HLP_PurchaseDateForActiveCard - Generate random purchase date & calculate expiry date for a card that is active at a given date
-- STP_HLP_AddMembershipPurchase - Insert 1 record about a membership card purchase
-- STP_HLP_ClientsExpiredMembership - Generate historical log of membership cards' purchases for 1 client
-- STP_HLP_DateTime - Generate random date and time for operation orders  --Volodymyr




/*
-- STP_HLP_BulkCarsInsert	- Add folder path to git csv file !!!     -- Volodymyr
*/

/* Data generation procedures. Create next */
/* EXECUTE IN THIS ORDER */


EXEC STP_GNR_CalendarData; -- Stas
EXEC STP_GNR_LocationCities; 
EXEC STP_GNR_ParkingLots; 
EXEC STP_GNR_StaffPositions;
EXEC STP_GNR_EmployeesReserve   --Марія
EXEC STP_GNR_CurrentEmployees   -- Марія
EXEC STP_GNR_FiredAttendants    -- Марія
EXEC STP_GNR_PositionChanges    -- Sergiy
EXEC STP_GNR_StaffShifts '2020-04-30' -- Марія
EXEC STP_GNR_SalaryChanges		-- Sergiy
EXEC STP_GNR_ParkingSlotSizes;  
EXEC STP_GNR_ParkingZoneTypes;  
EXEC STP_GNR_ParkingZones;  
EXEC STP_GNR_ParkingSlots;          -- Volodymyr
EXEC STP_GNR_OperationTariffNames
EXEC STP_GNR_OperationTariffs       --Volodymyr
EXEC STP_GNR_MembershipPeriods;
EXEC STP_GNR_MembershipTariffs;
EXEC STP_GNR_ClienteleClients; 						     
EXEC STP_GNR_ClienteleCars;   -- Volodymyr
EXEC STP_GNR_MembershipAllCards;
EXEC STP_GNR_MembershipOrders;  -- Аnna
EXEC STP_GNR_MembershipActiveCards  --
EXEC STP_GNR_OperationOrdersUnregularClients  --  Stas
EXEC STP_GNR_OperationOrdersUnregularRestClients  -- Stas
EXEC STP_GNR_OperationOrdersMembers -- Sergiy\Anna



















