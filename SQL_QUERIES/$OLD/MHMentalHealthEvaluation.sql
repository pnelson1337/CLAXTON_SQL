/****** Script for SelectTopNRows command from SSMS  ******/

SELECT * FROM (
SELECT 
PAT.[Encounter_ID]
,PAT.Patient_ID	

,(SELECT TOP 1 PINS.INS_PLAN_ID
	FROM [DATA_NY_Ogdensburg_ClaxtonHeburn_MedicalCenter].[dbo].[MHED_PAT_INSURANCE]		AS PINS
	WHERE PINS.IS_PRIMARY ='1' AND PINS.PATIENT_ID=PAT.Patient_ID)							AS 'PrimaryInsurance'
,(0 + CONVERT(Char(8),GETDATE(),112) - CONVERT(Char(8),PAT.BirthLocal_Date,112)) / 10000	AS 'Age'




FROM		[DATA_NY_Ogdensburg_ClaxtonHeburn_MedicalCenter].[dbo].[MHRPT_EN_PAT]			AS PAT
INNER JOIN	[DATA_NY_Ogdensburg_ClaxtonHeburn_MedicalCenter].[dbo].[MHOE_PS_ORDERS]			AS ORD		ON PAT.Encounter_ID=ORD.ENCOUNTER_ID AND ORD.NAME='Mental Health Evaluation'
INNER JOIN	[DATA_NY_Ogdensburg_ClaxtonHeburn_MedicalCenter].[dbo].[MHED_PAT]				AS MHDATE	ON PAT.Patient_ID=MHDATE.ID

WHERE MHDATE.CREATED_TS BETWEEN '2017-01-01' AND '2017-12-31'

) AS X

WHERE X.Age < 18
