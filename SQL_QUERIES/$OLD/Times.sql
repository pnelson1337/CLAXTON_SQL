/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
/*
CASE WHEN (SELECT [AdmVisitEvents].Status
			FROM [Livedb].[dbo].[AdmVisitEvents]
			WHERE ([AdmVisitEvents].Code='ENADMIN') AND ([AdmVisitEvents].Status='ADM IN')
			) = 'ADM IN'
			THEN (SELECT [AdmVisitEvents].EffectiveDateTime 
			FROM [Livedb].[dbo].[AdmVisitEvents]
			WHERE ([AdmVisitEvents].Code='ENADMIN') AND ([AdmVisitEvents].Status='ADM IN'))  
			
			ELSE''
			END
			*/

			



(SELECT [AdmVisitEvents].EffectiveDateTime 
		FROM [Livedb].[dbo].[AdmVisitEvents] 
			WHERE --([AdmVisitEvents].Code='ENADMIN') 
			AND (AdmVisits.Status='ADM IN') 
			AND AdmVisits.VisitID=AdmVisitEvents.VisitID
			) AS 'ADMIT TIME'
,(SELECT [AdmVisitEvents].EffectiveDateTime 
		FROM [Livedb].[dbo].[AdmVisitEvents] 
			WHERE ([AdmVisitEvents].Code='ENDISIN') 
			AND (AdmVisitEvents.Status='DIS IN') 
			AND AdmVisits.VisitID=AdmVisitEvents.VisitID
			) AS 'DISCHARGE TIME'
,(SELECT [AdmVisitEvents].EffectiveDateTime 
		FROM [Livedb].[dbo].[AdmVisitEvents] 
			WHERE ([AdmVisitEvents].Code='ENREGER') 
			AND (AdmVisitEvents.Status='REG ER') 
			AND AdmVisits.VisitID=AdmVisitEvents.VisitID
			)
,(SELECT [AdmVisitEvents].EffectiveDateTime 
		FROM [Livedb].[dbo].[AdmVisitEvents] 
			WHERE ([AdmVisitEvents].Code='ENADMIN') 
			AND (AdmVisitEvents.Status='ADM IN') 
			AND AdmVisits.VisitID=AdmVisitEvents.VisitID
			)
,(SELECT [AdmVisitEvents].EffectiveDateTime 
		FROM [Livedb].[dbo].[AdmVisitEvents] 
			WHERE ([AdmVisitEvents].Code='ENADMIN') 
			AND (AdmVisitEvents.Status='ADM IN') 
			AND AdmVisits.VisitID=AdmVisitEvents.VisitID
			)




  FROM [Livedb].[dbo].[AdmVisits]
  WHERE [AdmVisits].VisitID='6011976603'