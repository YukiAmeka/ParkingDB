/* Helper procedures */
/* CREATE FIRST. DO NOT EXECUTE */

-- STP_HLP_GenerateRandomTime - Generate random time within given limits
-- STP_HLP_FindEmployeeOnShift - Find the Employee who is/was on shift at a given Parking Lot at a given date & time
-- STP_HLP_OldMembershipTariffs
-- STP_HLP_PurchaseDateForActiveCard - Generate random purchase date & calculate expiry date for a card that is active at a given date
-- STP_HLP_AddMembershipPurchase - Insert 1 record about a membership card purchase
-- STP_HLP_ClientsExpiredMembership - Generate historical log of membership cards' purchases for 1 client


/* Data generation procedures. Create next */
/* EXECUTE IN THIS ORDER */
EXEC STP_GNR_LocationCities;
EXEC STP_GNR_ClienteleClients;
--Parking.SlotSizes.sql
--Parking.ZoneTypes.sql
--Parking.Lots.sql
--Parking.Zones.sql
--spGeneratingCalendarData.sql
EXEC STP_GNR_MembershipPeriods;
EXEC STP_GNR_MembershipTariffs;
EXEC STP_GNR_MembershipAllCards;
EXEC STP_GNR_MembershipOrders;
