SET NOCOUNT ON;

SELECT

ProcedureID
,Description
,Type

FROM [CH_MTLIVE].[dbo].[DBarProcedures]

WHERE Active='Y'