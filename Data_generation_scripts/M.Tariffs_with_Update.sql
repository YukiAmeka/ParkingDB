﻿INSERT INTO Membership.Tariffs (Price, ZoneID, PeriodID)
  VALUES 
('204', 1, 1), 
('252', 2, 1), 
('270', 5, 1), 
('336', 6, 1), 
('108', 10, 1),
('252', 14, 1),
('204', 17, 1),
('252', 18, 1),
('276', 21, 1), 
('342', 22, 1),
('270', 25, 1),
('336', 26, 1),
('120', 29, 1), 
('150', 30, 1), 
('72', 33, 1), 
('90', 34, 1),
('72', 37, 1),
('120', 41, 1),
('150', 45, 1),
('144', 49, 1), 
('180', 50, 1), 
('168', 53, 1), 
('48', 57, 1), 
('60', 58, 1),
('60', 65, 1),
('72', 66, 1),
('60', 69, 1),
('36', 73, 1), 
('45', 74, 1),
('36', 77, 1),
('210', 81, 1),
('252', 82, 1),
('126', 85, 1),
('150', 86, 1),
('490', 1, 2), 
('605', 2, 2), 
('648', 5, 2), 
('806', 6, 2), 
('259', 10, 2),
('605', 14, 2),
('490', 17, 2),
('605', 18, 2),
('662', 21, 2), 
('821', 22, 2),
('648', 25, 2),
('806', 26, 2),
('288', 29, 2), 
('360', 30, 2), 
('173', 33, 2), 
('216', 34, 2),
('173', 37, 2),
('288', 41, 2),
('360', 45, 2),
('346', 49, 2), 
('432', 50, 2), 
('403', 53, 2), 
('115', 57, 2), 
('144', 58, 2),
('144', 65, 2),
('173', 66, 2),
('144', 69, 2),
('86', 73, 2), 
('108', 74, 2),
('86', 77, 2),
('504', 81, 2),
('605', 82, 2),
('302', 85, 2),
('360', 86, 2),
('1958',1 ,3), 
('2419',2, 3), 
('2592', 5, 3), 
('3226', 6, 3), 
('1137', 10, 3),
('2419', 14, 3),
('1958',17 ,3),
('2419', 18, 3),
('2650', 21, 3), 
('3284', 22, 3),
('2592', 25, 3),
('3226', 26, 3),
('1152', 29, 3), 
('1440', 30, 3), 
('691', 33, 3), 
('864', 34, 3),
('691', 37, 3),
('1152', 41, 3),
('1440', 45, 3),
('1382', 49, 3),
('1728', 50, 3), 
('1613', 53, 3), 
('461', 57, 3), 
('576', 58, 3),
('576', 65, 3),
('691', 66, 3),
('576', 69, 3),
('346', 73, 3),
('432', 74, 3),
('346', 77, 3),
('2016', 81, 3),
('2419', 82, 3),
('1210', 85, 3),
('1440', 86, 3),
('5000', NULL, 4);

UPDATE [Membership].[Tariffs] SET [StartDate] = '2020-01-01', [EndDate] = '2020-12-31'

EXEC STP_GenerationOldMembershipTariffs @TariffStartDate = '2019-01-01', @TariffEndDate = '2019-12-31'
EXEC STP_GenerationOldMembershipTariffs @TariffStartDate = '2018-01-01', @TariffEndDate = '2018-12-31'
EXEC STP_GenerationOldMembershipTariffs @TariffStartDate = '2017-01-01', @TariffEndDate = '2017-12-31'
EXEC STP_GenerationOldMembershipTariffs @TariffStartDate = '2016-01-01', @TariffEndDate = '2016-12-31'
EXEC STP_GenerationOldMembershipTariffs @TariffStartDate = '2015-01-01', @TariffEndDate = '2015-12-31'

