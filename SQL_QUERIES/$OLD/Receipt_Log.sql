SELECT 
	   bcr.[SourceID]
      ,bcr.[NumberID] AS 'Receipt Number'
	  ,CONVERT(varchar(10),bcr.[ReceiptDateTime],23) AS 'Receipt Date'
	  ,bcr.[UserID]
      ,bcr.[Number] AS 'Account Number'
	  ,bcr.[Name] AS 'Patient Name'
	  ,bv.[PrimaryInsuranceID] AS 'Primary Insurance'
	  ,bv.[OutpatientLocationID] AS 'Location'
      ,bcr.[Amount]
      ,bcr.[ProcedureID] AS 'Type'
	  ,bcr.[Comment]
  FROM [Livedb].[dbo].[BarCashReceipts] bcr
  	    JOIN [Livedb].[dbo].[BarVisits] bv ON bcr.[Number]=bv.[AccountNumber]

  WHERE CONVERT(varchar(10),bcr.[ReceiptDateTime],23) BETWEEN '2017-09-01' AND '2017-09-05'