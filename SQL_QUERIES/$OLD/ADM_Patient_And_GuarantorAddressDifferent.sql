/*
Set NOCOUNT ON;
DECLARE	@StartDate DATE, @EndDate DATE
SET @StartDate= DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()),-56)
SET @EndDate=   DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), -55)
*/
SELECT 

       --AV.[VisitID]
	   AV.AccountNumber
	  ,CONVERT(varchar(10),AV.[ServiceDateTime],23) AS 'Service Date'
	  ,AV.[Name]
      ,ISNULL(AV.[Address1],'') AS 'Patient Address 1'
	  ,ISNULL(AG.[Address1],'') AS 'Guarantor Address 1'
	  ,ISNULL(AV.[Address2],'') AS 'Patient Address 2'
	  ,ISNULL(AG.[Address2],'') AS 'Guarantor Address 2'
	  ,UPPER(u.[Name]) AS 'Registered By'

  FROM [Livedb].[dbo].[AdmGuarantors] AG
  JOIN [Livedb].[dbo].[AdmVisits] AV ON AG.VisitID=AV.VisitID
  JOIN [Livedb].[dbo].AdmVisitEvents ave ON AV.[VisitID]=ave.[VisitID]
  JOIN [Livedb].[dbo].DMisUsers u ON ave.[EventUserID]=u.[UserID]
 

  WHERE AV.ServiceDateTime BETWEEN @StartDate AND @EndDate
    AND (ave.[EventSeqID] = 1)
	AND (ave.[Code] LIKE 'ENREG%')
    AND CASE WHEN AV.Address1=AG.Address1 THEN 'TRUE' ELSE 'FALSE' END = 'FALSE' 

	ORDER BY AV.ServiceDateTime