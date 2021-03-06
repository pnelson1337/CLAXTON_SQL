
SELECT

MMITEMS.Number
,MaxUnits.PackageSize														AS 'Name1'
,MaxUnits.ConversionFactor													AS 'Usage1'
 

 -- CAT NUMBER
 -- CS/2 BX/16 PKG/3 PK/2 EA
 -- CS 192
 -- BX 96
 -- PKG 6
 -- PK 2

FROM [Livedb].[dbo].[DMmItems]												AS MMITEMS



LEFT JOIN (SELECT * FROM(
SELECT
ROW_NUMBER() OVER (PARTITION BY IU.ItemID ORDER BY IU.PackingNumberID DESC)												AS OrderSeq
,IU.ItemID						
,IU.ConversionFactor
,IU.PackageSize
--,IU.PackingNumberID
FROM [Livedb].[dbo].[DMmItemUnits]																					AS IU
WHERE IU.SourceID='ABH'
--WHERE IU.ItemID='8576'

)																													AS X
WHERE X.OrderSeq='1')																								AS MaxUnits		ON MMITEMS.ItemID=MaxUnits.ItemID


WHERE MMITEMS.Active='Y' 
AND MMITEMS.SourceID='ABH'
AND MMITEMS.ItemID='35807'