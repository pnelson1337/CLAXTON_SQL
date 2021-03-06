
SELECT 
       BChgT.[VisitID]
      ,BChgT.[TransactionID]
      ,BChgT.[Amount]
      ,BChgT.[BatchDateTime]
      ,BChgT.[ServiceDateTime]
      ,BChgT.[TransactionCount]
      ,BChgT.[TransactionProcedureID]
      ,BChgT.[Type]
	  --,COALESCE(, '') + '' + COALESCE(CONVERT(varchar(10),bv.AdmitDateTime,23), '')
      ,BChgT.[BillingID]
      ,BChgT.[ClassID]

  FROM [Livedb].[dbo].[BarChargeTransactions] BChgT
  --JOIN [Livedb].
 -- JOIN [Livedb].[dbo].[BarCollectionTransactions] BColT ON BChgT.VisitID=BColT.VisitID

 -- WHERE CONVERT(varchar(10),BChgT.ServiceDateTime,23) BETWEEN '2017-09-15' AND '2017-09-21'
  WHERE BChgT.TransactionProcedureID IN ('734210', '740327')
 /*
  OR
  EXISTS (SELECT Code
  FROM [Livedb].[dbo].[BarCptCodes]
  WHERE Code IN ('V2787','V2788'))
  */
  AND
  CONVERT(varchar(10),BChgT.ServiceDateTime,23) BETWEEN '2017-01-01' AND '2017-12-31'

   ORDER BY BChgT.ServiceDateTime