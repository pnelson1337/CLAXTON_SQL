Declare @StartDate DateTime,@EndDate DateTime
/** Set Globals **/
Set @StartDate='2017-01-01'
Set @EndDate='2017-12-31'

SELECT * FROM (

SELECT
 BV.AccountNumber																			AS 'AccountNumber'
 ,COALESCE(CONVERT(VARCHAR(10),BV.ServiceDateTime,101), '') 
 + '' + 
 COALESCE(CONVERT(VARCHAR(10),BV.AdmitDateTime,101), '')									AS 'Service/Admit Date'
 ,(0 + CONVERT(Char(8),GETDATE(),112) - CONVERT(Char(8),BV.BirthDateTime,112)) / 10000		AS 'Age'
 ,BV.PrimaryInsuranceID
 --,MHEVENTS.[HC_PROVIDER_ID]																	AS 'Provider'
 --,MHORDCONSULT.[PROVIDER_NAME]																AS 'ConsultingProv'



FROM		[Livedb].[dbo].[BarVisits]																		AS BV
INNER JOIN	[MEDHOST-DB2].[DATA_NY_Ogdensburg_ClaxtonHeburn_MedicalCenter].[dbo].[MHRPT_EN]					AS MHENC			ON BV.AccountNumber COLLATE SQL_Latin1_General_CP1_CS_AS = MHENC.[HISVisit_Ident] COLLATE SQL_Latin1_General_CP1_CS_AS 
INNER JOIN	[MEDHOST-DB2].[DATA_NY_Ogdensburg_ClaxtonHeburn_MedicalCenter].[dbo].[MHOE_PS_ORDERS]			AS MHORD			ON MHENC.[Encounter_ID] = MHORD.[ENCOUNTER_ID] AND MHORD.NAME = 'Mental Health Evaluation'



/*
LEFT JOIN	(SELECT MHEVNT.[ENCOUNTER_ID],MHEVNT.HC_PROVIDER_ID, MAX(MHEVNT.ID)								AS MAXID
			FROM [MEDHOST-DB2].[DATA_NY_Ogdensburg_ClaxtonHeburn_MedicalCenter].[dbo].[MHED_EN_EVENTS]		AS MHEVNT
			WHERE MHEVNT.HC_PROVIDER_ID IN  ('2287','2289','2292','2535','2658','2720','2769','3046','3155','3706','4359','5799','7518','8478','8489')
			GROUP BY MHEVNT.[ENCOUNTER_ID],MHEVNT.HC_PROVIDER_ID)												AS MHEVENTS			ON MHENC.[Encounter_ID]=MHEVENTS.[ENCOUNTER_ID]
*/



WHERE((CONVERT(VarChar(10), BV.ServiceDateTime, 23) BETWEEN @StartDate AND @EndDate) 
       OR (CONVERT(varchar(10),BV.AdmitDateTime,23) BETWEEN @StartDate AND @EndDate))


) AS X

WHERE X.Age < 18



--AND X.ConsultingProv IN ('Psychosocial, Assessor (.PSA)','Psychosocial assessor')
--AND X.Provider IS NOT NULL
--AND X.Provider IN ('2287','2289','2292','2535','2658','2720','2769','3046','3155','3706','4359','5799','7518','8478','8489')

ORDER BY X.[Service/Admit Date]






