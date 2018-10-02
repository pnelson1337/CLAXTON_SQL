SELECT 
 R.LocationID
,R.RoomID
,RB.BedID
,CAST(R.RoomID AS varchar)+'-'+CAST(RB.BedID AS varchar)
  FROM [Livedb].[dbo].[DMisRoom]R
  INNER JOIN [Livedb].[dbo].[DMisRoomBed]RB ON R.RoomID=RB.RoomID
  WHERE Active='Y'
  ORDER BY R.LocationID, RB.RoomID
  
