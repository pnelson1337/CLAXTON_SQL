SET NOCOUNT ON

SELECT 
[EmployerID]
,[Name]
  FROM [CH_MTLIVE].[dbo].[DMisEmployer]
  WHERE Active='Y'