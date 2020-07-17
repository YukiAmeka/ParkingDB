
ALTER TABLE [Membership].[DimClients]
 ADD Country VARCHAR(10), County VARCHAR(30)

UPDATE [Membership].[DimClients] SET Country = 'UK'

--0

UPDATE [Membership].[DimClients]
    SET County = 'London'
    WHERE CityName = 'London'
    OR CityName = 'Enfield'

UPDATE [Membership].[DimClients]
    SET County = 'Kent'
    WHERE CityName = 'Rochester'
    OR CityName = 'Dartford'

UPDATE [Membership].[DimClients]
    SET County = 'Berkshire'
    WHERE CityName = 'Maidenhead'
    OR CityName = 'Slough'
    OR CityName = 'Reading'

UPDATE [Membership].[DimClients]
    SET County = 'Surrey'
    WHERE CityName = 'Epsom'
    OR CityName = 'Woking'
    OR CityName = 'Leatherhead'

--1

UPDATE [Membership].[DimClients]
    SET County = 'Somerset'
    WHERE CityName = 'Nailsea'
    OR CityName = 'Weston-super-Mare'
    OR CityName = 'Portishead'
    OR CityName = 'Keynsham'
    OR CityName = 'Bath'

UPDATE [Membership].[DimClients]
    SET County = 'Bristol'
    WHERE CityName = 'Bristol'

UPDATE [Membership].[DimClients]
    SET County = 'Gloucestershire'
    WHERE CityName = 'Yate'
    OR CityName = 'Thornbury'
    OR CityName = 'Patchway'
    OR CityName = 'Filton'

--2

UPDATE [Membership].[DimClients]
    SET County = 'Glamorgan'
    WHERE CityName = 'Cardiff'
    OR CityName = 'Penarth'
    OR CityName = 'Barry'
    OR CityName = 'Pontypridd'
    OR CityName = 'Cowbridge'
    OR CityName = 'Talbot Green'

UPDATE [Membership].[DimClients]
    SET County = 'Gwent'
    WHERE CityName = 'Newport'
    OR CityName = 'Caerphilly'
    OR CityName = 'Risca'
    OR CityName = 'Ystrad Mynach'

--3

UPDATE [Membership].[DimClients]
    SET County = 'Hampshire'
    WHERE CityName = 'Eastleigh'
    OR CityName = 'Ringwood'
    OR CityName = 'Romsey'
    OR CityName = 'Southampton'
    OR CityName = 'Winchester'
    OR CityName = 'New Milton'
    OR CityName = 'Fareham'
    OR CityName = 'Portsmouth'

UPDATE [Membership].[DimClients]
    SET County = 'Wiltshire'
    WHERE CityName = 'Salisbury'

UPDATE [Membership].[DimClients]
    SET County = 'Dorset'
    WHERE CityName = 'Christchurch'

--4

UPDATE [Membership].[DimClients]
    SET County = 'East Sussex'
    WHERE CityName = 'Lewes'
    OR CityName = 'Eastbourne'
    OR CityName = 'Uckfield'
    OR CityName = 'Brighton'
    OR CityName = 'Polegate'
    OR CityName = 'Seaford'

UPDATE [Membership].[DimClients]
    SET County = 'West Sussex'
    WHERE CityName = 'Worthing'
    OR CityName = 'Crawley'
    OR CityName = 'Shoreham-by-Sea'
    OR CityName = 'Haywards Heath'
    OR CityName = 'Burgess Hill'

--5

UPDATE [Membership].[DimClients]
    SET County = 'Devon'
    WHERE CityName = 'Ivybridge'
    OR CityName = 'Okehampton'
    OR CityName = 'Newton Abbot'
    OR CityName = 'Plymouth'
    OR CityName = 'Paignton'
    OR CityName = 'Torquay'
    OR CityName = 'Dartmouth'
    OR CityName = 'Tavistock'

UPDATE [Membership].[DimClients]
    SET County = 'Cornwall'
    WHERE CityName = 'Saltash'
    OR CityName = 'Liskeard'

--6

UPDATE [Membership].[DimClients]
    SET County = 'Oxfordshire'
    WHERE CityName = 'Oxford'
    OR CityName = 'Abingdon'
    OR CityName = 'Bicester'
    OR CityName = 'Woodstock'
    OR CityName = 'Witney'
    OR CityName = 'Faringdon'
    OR CityName = 'Burford'

UPDATE [Membership].[DimClients]
    SET County = 'Buckinghamshire'
    WHERE CityName = 'Aylesbury'
    OR CityName = 'Buckingham'

--7

UPDATE [Membership].[DimClients]
    SET County = 'Cambridgeshire'
    WHERE CityName = 'Cambridge'
    OR CityName = 'Cambourne'
    OR CityName = 'Ely'

UPDATE [Membership].[DimClients]
    SET County = 'Hertfordshire'
    WHERE CityName = 'Stevenage'
    OR CityName = 'Hitchin'
    OR CityName = 'Bishop''s Stortford'

UPDATE [Membership].[DimClients]
    SET County = 'Essex'
    WHERE CityName = 'Braintree'

UPDATE [Membership].[DimClients]
    SET County = 'Suffolk'
    WHERE CityName = 'Bury St Edmunds'
    OR CityName = 'Mildenhall'

UPDATE [Membership].[DimClients]
    SET County = 'Bedfordshire'
    WHERE CityName = 'Bedford'