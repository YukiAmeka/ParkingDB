

USE Lv_501_Parking_04_05
SELECT * FROM VW_STG_StaffDimEmployees
SELECT * FROM VW_STG_StaffDimLots


USE Lv_501_Parking_Staging
SELECT * FROM Staff.DimEmployees
SELECT * FROM Staff.DimLots
SELECT * FROM Staff.FactsEmployeesHistory

USE Lv_501_Parking_Services
SELECT * FROM VW_FullProcessInformation