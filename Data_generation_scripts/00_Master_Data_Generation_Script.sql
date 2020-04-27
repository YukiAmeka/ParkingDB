/* Helper procedures */
/* CREATE FIRST. DO NOT EXECUTE */

-- STP_HLP_OldOperationTariffs
-- STP_HLP_GenerateRandomTime - Ігор - Generate random time within given limits
-- STP_HLP_FindEmployeeOnShift - Аня - Find the Employee who is/was on shift at a given Parking Lot at a given date & time
-- STP_HLP_OldMembershipTariffs - Ігор
-- STP_HLP_PurchaseDateForActiveCard - Ваня - Generate random purchase date & calculate expiry date for a card that is active at a given date
-- STP_HLP_AddMembershipPurchase -  Аня  - Insert 1 record about a membership card purchase
-- STP_HLP_ClientsExpiredMembership -  Аня  - Generate historical log of membership cards' purchases for 1 client
-- STP_HLP_DateTime - Generate random date and time for operation orders



/*
-- STP_HLP_BulkCarsInsert	- Add folder path to git csv file !!!           BUG
*/

/* Data generation procedures. Create next */
/* EXECUTE IN THIS ORDER */

EXEC STP_GNR_CalendarData;
EXEC STP_GNR_LocationCities; -- прост
EXEC STP_GNR_ParkingLots;
EXEC STP_GNR_StaffPositions;
EXEC STP_GNR_EmployeesReserve
EXEC STP_GNR_CurrentEmployees
EXEC STP_GNR_FiredAttendants
EXEC STP_GNR_PositionChanges
EXEC STP_GNR_StaffShifts '2020-04-30'
EXEC STP_GNR_SalaryChanges
EXEC STP_GNR_ParkingSlotSizes;
EXEC STP_GNR_ParkingZoneTypes;
EXEC STP_GNR_ParkingZones;
EXEC STP_GNR_ParkingSlots;
EXEC STP_GNR_OperationTariffNames
EXEC STP_GNR_OperationTariffs
EXEC STP_GNR_MembershipPeriods; -- прост
EXEC STP_GNR_MembershipTariffs; -- Ігор
EXEC STP_GNR_ClienteleClients; -- Аня
EXEC STP_GNR_ClienteleCars;
EXEC STP_GNR_MembershipAllCards; -- Ваня
EXEC STP_GNR_MembershipOrders; -- Аня
EXEC STP_GNR_MembershipActiveCards -- Ігор
EXEC STP_GNR_OperationOrdersUnregularClients
EXEC STP_GNR_OperationOrdersUnregularRestClients
EXEC STP_GNR_OperationOrdersMembers














