/*
SELECT *
FROM
(
    SELECT [PolNumber],
           [PolType],
           [Effective Date],
           [DocName],
           [Submitted]
    FROM [dbo].[InsuranceClaims]
) AS SourceTable PIVOT(AVG([Submitted]) FOR [DocName] IN([Doc A],
                                                         [Doc B],
                                                         [Doc C],
                                                         [Doc D],
                                                         [Doc E])) AS PivotTable;

*/


DECLARE @cols NVARCHAR(MAX), @query NVARCHAR(MAX);
SET @cols = STUFF(
                 (
                     SELECT DISTINCT
                            ','+QUOTENAME(c.InsuranceID)
                     FROM [Livedb].[dbo].[BarInsuranceLedger] c FOR XML PATH(''), TYPE
                 ).value('.', 'nvarchar(max)'), 1, 1, '');
SET @query = 'SELECT [VisitID], '+@cols+'from (SELECT [VisitID],
           [Balance] AS [amount],
           [InsuranceID] AS [category]
    FROM [Livedb].[dbo].[BarInsuranceLedger]
    )x pivot (max(amount) for category in ('+@cols+')) p';
EXECUTE (@query);