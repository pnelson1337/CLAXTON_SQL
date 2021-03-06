SELECT 
       [UserID]
      ,[Active]
      ,[Name]
      ,[ProviderID]
      ,[ConfidentialPatients]
      ,[Monogram]
      ,[RestrictedUserPage6]
      ,[EmailId]
      ,[ElectronicSignatureEnabled]
  FROM [Livedb].[dbo].[DMisUsers]

WHERE UPPER(Name) like UPPER('%@Name%')
Order by Name, Active