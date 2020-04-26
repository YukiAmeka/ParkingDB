CREATE PROCEDURE STP_GNR_ParkingLots
AS
BEGIN

INSERT INTO Parking.Lots
 ( LotName, CityId, Address,  PhoneNumber,Email)
Values ('L-1','1','Great Portland St.', '+44-7871234567','jbu3@parkinglot.com'),
       ('L-2','1','Bolsover St.', '+44-7256234567','hol3@parkinglot.com'),
	   ('L-3','1','Gower St.', '+44-5597234567','pink3@parkinglot.com'),
	   ('L-4','1','Fitzroy St.', '+44-5598644567','lonk3@parkinglot.com'),
	   ('L-5','1','Conway St. ', '+44-5598555567','JOP3@parkinglot.com'),
	   ('L-6','1','Bloomsbury St.', '+44-5598547567','jo3@parkinglot.com'),
	   ('L-7','1','Brooke St.', '+44-5533447567','rov3@parkinglot.com'),
	   ('L-8','1',' Pear Tree St.', '+44-3253447567','joc3@parkinglot.com'),
	   ('B-1','11',' Unity St.', '+44-3356447567','py3@parkinglot.com'),
	   ('B-2','11',' Upper Easton St.', '+44-3984447567','ily3@parkinglot.com'),
	   ('B-3','11',' Horton St.', '+44-3989847567','tiu3@parkinglot.com'),
	   ('C-1','21',' Cathays St.', '+44-3989841167','lke2@parkinglot.com'),
	   ('C-2','21',' Burnaby St. ', '+44-5897841167','mca4@parkinglot.com'),
	   ('C-3','21',' Newtown St. ', '+44-5893771167','dbu1@parkinglot.com'),
	   ('S-1','31',' Suffolk St.', '+44-6981771167','cta3@parkinglot.com'),
	   ('S-2','31',' Cavendish St.', '+44-6981789167','pcu4@parkinglot.com'),
	   ('Brig-1','41',' Shirley St.', '+44-6985469167','jfu6@parkinglot.com'),
	   ('Brig-2','41',' Elrington St.', '+44-9785469167','pcu4@parkinglot.com'),
	   ('P-1','51',' Goodwin Cres St.', '+44-9785461237','mca4@parkinglot.com'),
	   ('P-2','51','  Browning St.', '+44-9564461237','jo3@parkinglot.com'),
	   ('Ox-1','61','National Cycle St.', '+44-9512461237','tiu3@parkinglot.com'),
	   ('Cam-1','71',' Clare St. ', '+44-9532651237','mca4@parkinglot.com')

END