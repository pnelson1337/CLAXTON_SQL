Set NOCOUNT ON;
DECLARE	@StartDate DATE, @EndDate DATE
SET @StartDate= '2017-01-01'
SET @EndDate= '2017-12-31'



SELECT 
       [InvoiceID]
	  ,CONVERT(VARCHAR(10),[DateTime],101)	AS 'PaidDate'
      ,[InvoiceNumber]
      ,[Description]
      ,[Payment]
      ,[RemitName]
      ,[Status]
      ,[VendorID]
  FROM [Livedb].[dbo].[ApInvoices]


  WHERE VendorID = '20346'
	AND DateTime BETWEEN @StartDate AND @EndDate
	AND Status != 'CANCEL'


  ORDER BY DateTime, Payment