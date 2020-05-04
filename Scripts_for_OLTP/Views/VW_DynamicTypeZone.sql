DECLARE 
    @columns NVARCHAR(MAX) = '', 
    @sql     NVARCHAR(MAX) = '';

-- select the category names
SELECT 
    @columns+=QUOTENAME(ZoneTypeName) + ','
FROM [Parking].[ZoneTypes]
ORDER BY ZoneTypeName;

-- remove the last comma
SET @columns = LEFT(@columns, LEN(@columns) - 1);

-- construct dynamic SQL
SET @sql ='
SELECT * FROM (
	SELECT T.ZoneTypeName, SUM(Z.Capacity) AS Capacity
	FROM [Parking].[Zones] AS Z
	INNER JOIN [Parking].[ZoneTypes] AS T
	ON Z.ZoneTypeID = T.ZoneTypeID
	GROUP BY T.ZoneTypeName
) AS PivotTable 
 PIVOT
(
     SUM(Capacity)
     FOR ZoneTypeName IN('+ @columns +')
) AS PivotTable';
-- (A, B, C, D) 
-- execute the dynamic SQL
EXECUTE sp_executesql @sql;