/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
DLT.PrintNumberID
,DCODES.CodeID
,DLT.NomenclatureID

FROM [Livedb].[dbo].[DLabTest]	AS DLT
LEFT JOIN DMisNmapCodes			AS DCODES	ON DLT.NomenclatureID=DCODES.NomenclatureID AND DCODES.CodeSetID='LOINC'

WHERE DLT.Active='Y'
AND DCODES.CodeID='IMO0001'
