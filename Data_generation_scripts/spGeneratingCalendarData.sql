CREATE PROCEDURE [dbo].[spGeneratingCalendarData] @StartDate date, @Years int
--2015-01-01
AS

 BEGIN

DECLARE @CutoffDate date = DATEADD(DAY, -1, DATEADD(YEAR, 20, @StartDate));

;WITH seq(n) AS
(
  SELECT 0 UNION ALL SELECT n + 1 FROM seq
  WHERE n < DATEDIFF(DAY, @StartDate, @CutoffDate)
),
d(d) AS
(
  SELECT DATEADD(DAY, n, @StartDate) FROM seq
),
src AS
(
  SELECT
    TheDate         = CONVERT(date, d),
    TheDay          = DATEPART(DAY,       d),
    TheDayName      = DATENAME(WEEKDAY,   d),
    TheWeek         = DATEPART(WEEK,      d),
    TheISOWeek      = DATEPART(ISO_WEEK,  d),
    TheDayOfWeek    = DATEPART(WEEKDAY,   d),
    TheMonth        = DATEPART(MONTH,     d),
    TheMonthName    = DATENAME(MONTH,     d),
    TheQuarter      = DATEPART(Quarter,   d),
    TheYear         = DATEPART(YEAR,      d),
    TheFirstOfMonth = DATEFROMPARTS(YEAR(d), MONTH(d), 1),
    TheLastOfYear   = DATEFROMPARTS(YEAR(d), 12, 31),
    TheDayOfYear    = DATEPART(DAYOFYEAR, d)
  FROM d
)

INSERT INTO Services.CalendarDates(
[TheDate],
[TheDay],
[TheDayName],
[TheWeek],
[TheISOWeek],
[TheDayOfWeek],
[TheMonth] ,
[TheMonthName],
[TheQuarter],
[TheYear],
[TheFirstOfMonth] ,
[TheLastOfYear] ,
[TheDayOfYear] 
)
SELECT * FROM src
OPTION (MAXRECURSION 15000
       );
END

EXECUTE [dbo].[spGeneratingCalendarData] @StartDate = '2015-01-01', @Years = 20