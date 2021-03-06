DECLARE @VENDOR VARCHAR, @STATUS VARCHAR, @BAL MONEY
--SET @VENDOR = '61650'
SET @STATUS = 'OPEN'
SET @BAL = '0'
/* WRITTEN BY PATRICK NELSON (CLAXTON-HEPBURN MEDICAL CENTER) 12/17/18 
FOR JACKSON SHATRAW -- ALL OPEN INVOICES IN AP */

SELECT 

VEND.Name
,APINV.VendorID
,APINV.InvoiceNumber
,APINV.AmountNet				
,CONVERT(VARCHAR(10),APINV.DateTime,101)						AS 'InvDate'
,ISNULL(CONVERT(VARCHAR(10),APINV.ReceivedDateTime,101),'')		AS 'RecDate'
,ISNULL(CONVERT(VARCHAR(10),APINV.LastPaymentDateTime,101),'')	AS 'LastPay'
,APINV.Discount												
,APINV.Payment
,APINV.Status
--,ISNULL(MMPO.Number,'')											AS 'PONumber'	

--,MMPO.Number
  FROM		[Livedb].[dbo].[ApInvoices]					AS APINV
  --LEFT JOIN	[Livedb].[dbo].[MmInvoices]					AS MMINV		ON APINV.InvoiceID=MMINV.InvoiceID AND MMINV.SourceID='ABH'
  --LEFT JOIN	[Livedb].[dbo].[MmPurchaseOrders]			AS MMPO			ON MMINV.PurchaseOrderID=MMPO.PurchaseOrderID AND MMPO.SourceID='ABH'
  LEFT JOIN [Livedb].[dbo].[DMisVendors]				AS VEND			ON APINV.VendorID=VEND.VendorID AND VEND.Active='Y'
 
/*
WHERE Status IN (@STATUS)
--AND APINV.VendorID IN (@VENDOR)
AND Balance > @BAL
*/


WHERE APINV.Status IN ('OPEN')
--AND APINV.VendorID IN (@VENDOR)
AND Balance > 0



ORDER BY DateTime