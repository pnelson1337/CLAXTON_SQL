SET NOCOUNT ON;

SELECT

ProcedureID
,Description
,Type

FROM [Livedb].[dbo].[DBarProcedures]

WHERE Active='Y'