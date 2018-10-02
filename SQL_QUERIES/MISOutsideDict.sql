/****** Script for SelectTopNRows command from SSMS  ******/
SELECT

OL.OutsideLocationID
,OL.Name
,OLT.TypeID


FROM [Livedb].[dbo].[DMisOutLocations]				AS OL
LEFT JOIN	[Livedb].[dbo].[DMisOutLocationTypes]		AS OLT		ON OL.OutsideLocationID=OLT.OutsideLocationID

  WHERE TypeID='Comm Rsrc'


  ORDER BY Name
