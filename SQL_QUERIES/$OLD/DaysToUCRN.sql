/****** Script for SelectTopNRows command from SSMS  ******/
SELECT

BV.AccountNumber
,ISNULL(BV.ServiceDateTime,BV.AdmitDateTime)																					AS 'Admit/Service Date'
,ISNULL(BV.DischargeDateTime,BV.ServiceDateTime)																				AS 'Discharge Date'
,AV.LocationID
,ISNULL(DATEDIFF(DAY,UCRN.[SubmitDateTime],BV.AdmitDateTime),DATEDIFF(DAY,UCRN.[SubmitDateTime],BV.ServiceDateTime))		AS 'Days to UCRN'


      ,[UcrnID]
      ,[InsuranceID]
      ,[BillNumberID]
      ,[ClaimID]
      ,[SubmitDateTime]
      ,[SubmitAmount]
      ,[RemitDateTime]
      ,[ReceiptAmount]
      ,[AdjustmentAmount]
      ,[NumberOfReceipts]

  FROM		[Livedb].[dbo].[BarUniqueClaimReferenceData]		AS UCRN
  LEFT JOIN [Livedb].[dbo].[BarVisits]							AS BV			ON UCRN.BillingID=BV.BillingID
  LEFT JOIN [Livedb].[dbo].[AdmVisits]							AS AV			ON UCRN.VisitID=AV.VisitID

  WHERE SubmitDateTime BETWEEN '2018-01-01' AND '2018-11-26'

  AND LocationID != 'LIFELINE'
  AND AV.AccountNumber='26308296'

  ORDER BY [Days to UCRN]

