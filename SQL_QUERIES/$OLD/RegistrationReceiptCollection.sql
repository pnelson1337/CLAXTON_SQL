SELECT
		-- Selecting Data --
           adv.[SourceID]
		  ,adv.[AccountNumber] AS 'Account Number'
		  ,adv.[Name] AS 'Name'
          ,CONVERT(varchar(10),adv.[ServiceDateTime],23) AS 'Service Date'
		  ,adv.[Status] AS 'Registration Status' 
          ,bv.[PrimaryInsuranceID] AS 'Primary Insurance'
          ,bv.[OutpatientLocationID] AS 'Location'
		  ,u.[Name] AS 'Registered By'
		  ,diu.[Name] AS 'Collection By'
		  ,bcr.[NumberID] AS 'Receipt Number'
          ,bcr.[Amount]
          ,bcr.[ProcedureID] AS 'Type'
          ,bcr.[Comment]
		  ,'Unpaid' AS STATIC_FIELD  

	   -- Start of Joins --
		  FROM [Livedb].[dbo].[AdmVisits] adv
		  JOIN [Livedb].[dbo].[BarVisits] bv ON adv.[AccountNumber]=bv.[AccountNumber]
		  FULL JOIN [Livedb].[dbo].[BarCashReceipts] bcr ON bcr.[Number]=adv.[AccountNumber]
		  JOIN AdmVisitEvents ave ON bv.[VisitID]=ave.[VisitID]
		  JOIN DMisUsers u ON ave.[EventUserID]=u.[UserID]
		  FULL JOIN DMisUsers diu ON bcr.[UserID]=diu.[UserID]

	   -- Start of Where --  
		  WHERE CONVERT(varchar(10),adv.[ServiceDateTime],23) BETWEEN '2017-08-01' AND '2017-08-31' and adv.[Status] NOT IN ('ADM IN','DIS IN','DIS RCR','REG SDC') 
		  AND (ave.[EventSeqID] = 1)
	      AND (ave.[Code] LIKE 'ENREG%')
		  --AND (bcr.[Amount] IS NOT NULL)
		  ORDER BY adv.[ServiceDateTime]
		  
