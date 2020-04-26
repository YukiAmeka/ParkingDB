CREATE PROCEDURE STP_HLP_BulkCarsInsert	AS   BEGINBULK INSERT CARMODELSFROM 'C:\ParkingGit\ParkingDB\CarBrand.csv'WITH (FIRSTROW = 2,    FIELDTERMINATOR = ';',	ROWTERMINATOR='\n' );	CREATE TABLE CarPlates(
	PlateId int,
	Plate char(7)
	)BULK INSERT CarPlatesFROM 'C:\ParkingGit\ParkingDB\CarPlates.csv'WITH (FIRSTROW = 2,    FIELDTERMINATOR = ';',	ROWTERMINATOR='\n' );

	END



	



