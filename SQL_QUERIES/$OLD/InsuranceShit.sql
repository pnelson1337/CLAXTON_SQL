/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
BV.AccountNumber
,BV.VisitID
,PRIMARYINS.InsuranceID
,PRIMARYINS.PolicyNumber

,SECONDARYINS.InsuranceID
,SECONDARYINS.PolicyNumber

,TERTIARYINS.InsuranceID
,TERTIARYINS.PolicyNumber

,QUATERNARYINS.InsuranceID
,QUATERNARYINS.PolicyNumber

FROM [Livedb].[dbo].[BarVisits]				 AS BV

LEFT JOIN (SELECT BD.VisitID,BD.InsuranceID, BIO.PolicyNumber
			FROM [Livedb].[dbo].[BarInsuranceOrder]		AS BD
			LEFT JOIN [Livedb].[dbo].[BarInsuredData]	AS BIO	ON BD.VisitID=BIO.VisitID AND BD.InsuranceID=BIO.InsuranceID
			WHERE BD.InsuranceOrderID='1'
			)											AS PRIMARYINS	ON BV.VisitID=PRIMARYINS.VisitID
LEFT JOIN (SELECT BD.VisitID,BD.InsuranceID, BIO.PolicyNumber
			FROM [Livedb].[dbo].[BarInsuranceOrder]		AS BD
			LEFT JOIN [Livedb].[dbo].[BarInsuredData]	AS BIO	ON BD.VisitID=BIO.VisitID AND BD.InsuranceID=BIO.InsuranceID
			WHERE BD.InsuranceOrderID='2'
			)											AS SECONDARYINS	ON BV.VisitID=SECONDARYINS.VisitID
LEFT JOIN (SELECT BD.VisitID,BD.InsuranceID, BIO.PolicyNumber
			FROM [Livedb].[dbo].[BarInsuranceOrder]		AS BD
			LEFT JOIN [Livedb].[dbo].[BarInsuredData]	AS BIO	ON BD.VisitID=BIO.VisitID AND BD.InsuranceID=BIO.InsuranceID
			WHERE BD.InsuranceOrderID='3'
			)											AS TERTIARYINS	ON BV.VisitID=TERTIARYINS.VisitID
LEFT JOIN (SELECT BD.VisitID,BD.InsuranceID, BIO.PolicyNumber
			FROM [Livedb].[dbo].[BarInsuranceOrder]		AS BD
			LEFT JOIN [Livedb].[dbo].[BarInsuredData]	AS BIO	ON BD.VisitID=BIO.VisitID AND BD.InsuranceID=BIO.InsuranceID
			WHERE BD.InsuranceOrderID='4'
			)											AS QUATERNARYINS	ON BV.VisitID=QUATERNARYINS.VisitID


--WHERE AccountNumber='24804742'

WHERE BV.ServiceDateTime BETWEEN '2018-01-01' AND '2018-12-31'