/* Helper procedures */
/* CREATE FIRST. DO NOT EXECUTE */

-- STP_HLP_GenerateRandomTime - Generate random time within given limits
-- STP_HLP_FindEmployeeOnShift - Find the Employee who is/was on shift at a given Parking Lot at a given date & time
-- STP_HLP_OldMembershipTariffs



/* Data generation procedures */
/* EXECUTE IN THIS ORDER */
EXEC STP_GNR_LocationCities;
EXEC STP_GNR_ClienteleClients;
EXEC STP_GNR_MembershipPeriods;
EXEC STP_GNR_MembershipTariffs;
EXEC STP_GNR_MembershipAllCards @TotalNumber = 50000;
