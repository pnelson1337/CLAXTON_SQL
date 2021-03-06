/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
 DMMITEM.Number
,DMMITEM.Description 
--VENDOR--

,MMDEPTGL.[PeriodEndDateTime]
,MMDEPTGL.[InventoryID]
,MMDEPTGL.[GlDeptID]
,MMDEPTGL.[GlAccountID]
,MMDEPTGL.[StockID]
,DMMITEM.Number
,DMMITEM.Name
,MMDEPTGL.[Adjustment]
,MMDEPTGL.[Issue]
,MMDEPTGL.[PatientIssue]
,MMDEPTGL.[ReturnValue]
,MMDEPTGL.[Taxes]
,MMDEPTGL.[Total]
,MMDEPTGL.[XferIn]
,MMDEPTGL.[XferOut]
,MMDEPTGL.[RowUpdateDateTime]
FROM		[Livedb].[dbo].[MmStatsDeptGlStocks]	AS MMDEPTGL				
LEFT JOIN	[Livedb].[dbo].[DMmStock]				AS DMMSTOCK				ON MMDEPTGL.StockID=DMMSTOCK.StockID	AND DMMSTOCK.Active='Y' AND DMMSTOCK.SourceID='ABH'
LEFT JOIN	[Livedb].[dbo].[DMmItems]				AS DMMITEM				ON DMMSTOCK.ItemID=DMMITEM.ItemID		AND DMMITEM.Active='Y'	AND DMMITEM.SourceID='ABH'

WHERE PeriodEndDateTime > '2018-03-01'
AND MMDEPTGL.SourceID='ABH'
