/* Generate random Card Number & random Card Tariff within set parameters.
Populate Membership.AllCards with the total of 10,000 records of MemberCardNumber & TariffID */

CREATE PROC STP_GenerationTariffId
(
    @HigherId  AS int
    ,@LowerId AS int
    ,@LineCounter AS int
)
AS
BEGIN
    WHILE @LineCounter > 0
        BEGIN
            INSERT INTO Membership.AllCards (MemberCardNumber,TariffID)
            VALUES (FLOOR(RAND()*(9999999-1000000+1)+1000000),FLOOR(RAND()*(@HigherId-@LowerId+1)+@LowerId))
            SET @LineCounter -= 1
        END
END


EXEC STP_GenerationTariffId @HigherId = 34,  @LowerId =1,  @LineCounter = 450
EXEC STP_GenerationTariffId @HigherId = 68,  @LowerId =35,  @LineCounter = 300
EXEC STP_GenerationTariffId @HigherId = 102,  @LowerId =69,  @LineCounter = 200
EXEC STP_GenerationTariffId @HigherId = 103,  @LowerId =103,  @LineCounter = 50

SELECT * FROM Membership.AllCards