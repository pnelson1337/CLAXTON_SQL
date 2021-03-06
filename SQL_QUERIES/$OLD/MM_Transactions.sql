SELECT 
 DMMITEM.Number
,DMMITEM.Description

,MMSTOCKTRAN.[StockID]
,MMSTOCKTRAN.[TypeID]
,MMSTOCKTRAN.[DateTime]
,MMSTOCKTRAN.[Dept]
,MMSTOCKTRAN.[Quantity]
,MMSTOCKTRAN.[RequisitionNumber]
,MMSTOCKTRAN.[TransactionUser]
,MMSTOCKTRAN.[UnitOfMeasure]
,MMSTOCKTRAN.[UnitOfMeasureConversion]
,MMSTOCKTRAN.[TransferInventory]
,MMSTOCKTRAN.[TransferStockNumberStockID]


FROM [Livedb].[dbo].[MmStockTransactions]			AS MMSTOCKTRAN
LEFT JOIN	[Livedb].[dbo].[DMmStock]				AS DMMSTOCK				ON MMSTOCKTRAN.StockID=DMMSTOCK.StockID	AND DMMSTOCK.Active='Y' AND DMMSTOCK.SourceID='ABH'
LEFT JOIN	[Livedb].[dbo].[DMmItems]				AS DMMITEM				ON DMMSTOCK.ItemID=DMMITEM.ItemID		AND DMMITEM.Active='Y'	AND DMMITEM.SourceID='ABH'

  WHERE MMSTOCKTRAN.DateTime > '2018-04-01'

  AND MMSTOCKTRAN.SourceID='ABH'