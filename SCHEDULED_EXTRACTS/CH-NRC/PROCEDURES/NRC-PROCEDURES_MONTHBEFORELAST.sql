Set NOCOUNT ON;
SELECT
		  'Claxton-Hepburn Medical Center' AS FacilityName
		  ,'330211' AS CCN  
		  ,'HOPD' AS FacilityType  
	      ,adv.[LocationID] AS 'LocationID'
		  ,(SELECT dloc.[Name] FROM Livedb.dbo.DMisLocation dloc 
		      WHERE (dloc.LocationID = adv.LocationID)) AS 'LocationName'

		  ,(SELECT COUNT(adv.AccountNumber) 
			  FROM Livedb.dbo.AdmVisits adv
			  WHERE adv.ServiceDateTime>= DATEADD(mm,DATEDIFF(mm,0,GETDATE())-2,0) AND adv.ServiceDateTime < DATEADD(mm,DATEDIFF(mm,0,GETDATE())-1,0)
			  AND bv.[InpatientOrOutpatient]='O'
			  AND adv.[Status] IN ('DEP SDC', 'REG SDC')
			  ) AS 'NumPatServed'

			  

-- START OF NAME SPLIT--
		 --Start of First_Name--
  		  ,SUBSTRING(bv.Name,CHARINDEX(',',bv.Name)+1,(CASE WHEN CHARINDEX(' ',bv.Name,CHARINDEX(',',bv.Name)+1)=0 THEN LEN(bv.Name)
		   ELSE CHARINDEX(' ',bv.Name,CHARINDEX(',',bv.Name)+1)-CHARINDEX(',',bv.Name) END)) AS FName

		 --Start of Middle Name-- 
		  ,CASE WHEN CHARINDEX(' ',bv.Name,CHARINDEX(',',bv.Name)+1) = 0 THEN ' 'ELSE SUBSTRING(bv.Name,CHARINDEX(' ',bv.Name,CHARINDEX(',',bv.Name)+1)+1,1) 
		   END AS Middle

		  --Start of Last Name--
	      ,CASE WHEN bv.Name NOT LIKE '%,%' THEN bv.Name ELSE LEFT(bv.Name, CHARINDEX(',',bv.Name)- 1)
		   END AS 'LName'
-- END OF NAME SPLIT--       


		  ,bv.[Address1] AS 'Addr'
		  ,ISNULL (bv.[Address2],'') AS 'Addr2' 
		  ,bv.[City] AS 'City'
		  ,bv.[StateProvince] AS 'ST'
		  ,bv.[PostalCode] AS Zip5
-- START OF STRIPNonNumerics Function - Wrap Area Code and Phone in StripNonNumerics Function (Removing all NON-NUMERICS from the return)
		  ,[CH_MTLIVE].[dbo].[StripNonNumerics](                     LEFT(bv.HomePhone,CHARINDEX(')',bv.HomePhone))                         ) AS 'AreaCode'    
		  ,[CH_MTLIVE].[dbo].[StripNonNumerics]( CASE WHEN bv.HomePhone NOT LIKE '(___)%' THEN bv.HomePhone ELSE SUBSTRING(bv.HomePhone,6,(LEN(bv.HomePhone)-5)) END) AS 'Phone'
-- END StripNonNumerics Function
		  ,bv.[UnitNumber] AS 'MRN'
		  ,CONVERT(varchar(10),bv.[BirthDateTime],101) AS 'DOB'
		  ,bv.[Sex] AS 'Sex'
		  ,CASE 
			WHEN (SELECT avq.Response
			FROM Livedb.dbo.AdmVisitQueries avq 
			WHERE (avq.QueryID = 'ADM.LANG') AND (avq.VisitID = bv.VisitID)) = 'S' THEN '19' ELSE '1' 
			END AS 'LangID'
		  ,bv.[AccountNumber] AS 'VisitNum'
		  ,CONVERT(varchar(10),bv.[ServiceDateTime],101) AS 'Service Date'

-- START CPT CODE SELECTIONS --
		  ,ISNULL((SELECT bcpt.Code FROM Livedb.dbo.BarCptCodes bcpt WHERE (bcpt.CptSeqID = '1') AND (bcpt.Code NOT LIKE '%[A-Z,a-z]%') AND
		          (bv.VisitID = bcpt.VisitID)),'') AS 'CPT4'
		  ,ISNULL((SELECT bcpt.Code FROM Livedb.dbo.BarCptCodes bcpt WHERE (bcpt.CptSeqID = '2') AND (bcpt.Code NOT LIKE '%[A-Z,a-z]%') AND
		          (bv.VisitID = bcpt.VisitID)),'') AS 'CPT4_2'
		  ,ISNULL((SELECT bcpt.Code FROM Livedb.dbo.BarCptCodes bcpt WHERE (bcpt.CptSeqID = '3') AND (bcpt.Code NOT LIKE '%[A-Z,a-z]%') AND
                  (bv.VisitID = bcpt.VisitID)),'') AS 'CPT4_3'
-- END CPT CODE SELECTIONS --

-- START G CODE SELECTIONS --
		  ,ISNULL((SELECT bcpt.Code FROM Livedb.dbo.BarCptCodes bcpt WHERE (bcpt.CptSeqID = '1') AND (bcpt.Code LIKE 'G%') AND
                  (bv.VisitID = bcpt.VisitID)),'') AS 'G_Code_1'
		  ,ISNULL((SELECT bcpt.Code FROM Livedb.dbo.BarCptCodes bcpt WHERE (bcpt.CptSeqID = '2') AND (bcpt.Code LIKE 'G%') AND
                  (bv.VisitID = bcpt.VisitID)),'') AS 'G_Code_2'
		  ,ISNULL((SELECT bcpt.Code FROM Livedb.dbo.BarCptCodes bcpt WHERE (bcpt.CptSeqID = '3') AND (bcpt.Code LIKE 'G%') AND
                  (bv.VisitID = bcpt.VisitID)),'') AS 'G_Code_3'
-- END G CODE SELECTIONS --




		  FROM				[CH_MTLIVE].[dbo].[AdmVisits]							AS adv
		  JOIN				[CH_MTLIVE].[dbo].[BarVisits]							AS bv			ON adv.[AccountNumber]=bv.[AccountNumber]
		  JOIN				[CH_MTLIVE].[dbo].[AdmVisitQueries]					AS avq			ON avq.VisitID = bv.VisitID AND avq.QueryID = 'INST'


		 -- WHERE CONVERT(varchar(10),bv.ServiceDateTime,23) BETWEEN @StartDate AND @EndDate
			  WHERE adv.ServiceDateTime>= DATEADD(mm,DATEDIFF(mm,0,GETDATE())-2,0) AND adv.ServiceDateTime < DATEADD(mm,DATEDIFF(mm,0,GETDATE())-1,0)
			 AND bv.PrimaryInsuranceID!='WEXFORD'
			 AND bv.[InpatientOrOutpatient]='O'
			 AND DATEDIFF (year, bv.BirthDateTime, GETDATE()) > 18
			 AND avq.Response IN ('WALSH','WADD','WNICF2','UHIRARIVR','UHIRAMCIN','UHIRAKEND','UHIRACENT','UHICF7','UHICF6','UHICF5','UHICF4','UHICF3','UHICF1','UHACT','SLPC','NONE','SUNYCAN','MMH','MATCC','IVYRIDGE','HEUV','HAMMOND','CPH','NULL')
			 AND adv.LocationID NOT IN('CAN','CANOPS','CHHC','CHHCOPS','HAMM','HAMMOPS','MAD','MADOPS','WADD','WADDOPS','LIS','LISOPS','HEUV','HEUVOPS','ER','CARD','WHS','WELL','MOB','LAB','LAB-PNP','LIFELINE','LAB-RIVER','SLEEPLAB','SP','OT','OPT','OB','OBO','NPREVRCR','NPREV','HHC')
			 
			  AND adv.[Status] IN ('DEP SDC','REG SDC') 
								
							OR EXISTS( SELECT BCT.TransactionProcedureID
									FROM [CH_MTLIVE].[dbo].[BarChargeTransactions] BCT 
									WHERE (BCT.TransactionProcedureID LIKE '410%' OR BCT.TransactionProcedureID LIKE '416%' OR BCT.TransactionProcedureID LIKE '417%')
										AND   bv.VisitID=BCT.VisitID
										AND adv.ServiceDateTime>= DATEADD(mm,DATEDIFF(mm,0,GETDATE())-2,0) AND adv.ServiceDateTime < DATEADD(mm,DATEDIFF(mm,0,GETDATE())-1,0)
										AND bv.PrimaryInsuranceID!='WEXFORD'
										AND bv.[InpatientOrOutpatient]='O'
										AND DATEDIFF (year, bv.BirthDateTime, GETDATE()) > 18
										AND avq.Response IN ('WALSH','WADD','WNICF2','UHIRARIVR','UHIRAMCIN','UHIRAKEND','UHIRACENT','UHICF7','UHICF6','UHICF5','UHICF4','UHICF3','UHICF1','UHACT','SLPC','NONE','SUNYCAN','MMH','MATCC','IVYRIDGE','HEUV','HAMMOND','CPH','NULL')
									    AND adv.LocationID NOT IN('CAN','CANOPS','CHHC','CHHCOPS','HAMM','HAMMOPS','MAD','MADOPS','WADD','WADDOPS','LIS','LISOPS','HEUV','HEUVOPS','ER','CARD','WHS','WELL','MOB','LAB','LAB-PNP','LIFELINE','LAB-RIVER','SLEEPLAB','SP','OT','OPT','OB','OBO','NPREVRCR','NPREV','HHC')
		
										)	
										
								

							OR EXISTS (SELECT bcpt.Code
									FROM [CH_MTLIVE].[dbo].[BarCptCodes] bcpt
									WHERE bcpt.Code BETWEEN '10021' AND '69990'
										AND bcpt.Code NOT IN('11042','11045','16020','16025','16030','29000','29010','29015','29020','29025','29035','29040','29044','29046','29049','29055','29058','29065','29075','29085','29086','29105','29125','29126','29200','29240','29260','29280',
										'29305','29325','29345','29355','29358','29365','29405','29425','29435','29440','29445','29450','29505','29515','29520','29530','29540','29550','29580','29581',
										'29582','36400','36405','36406','36415','36416','36420','36425','36440','36450','36455','36460','36468','36469','36470','36471','36600','36620','36625','36660',
										'51701','51702','59020','59025','36591','36592','29130','29131','29583','29584','29700','29705','29710','29715','29720','29730','29740','29750','29799','36430')
										AND   bv.VisitID=bcpt.VisitID
										AND adv.ServiceDateTime>= DATEADD(mm,DATEDIFF(mm,0,GETDATE())-2,0) AND adv.ServiceDateTime < DATEADD(mm,DATEDIFF(mm,0,GETDATE())-1,0)
										AND bv.PrimaryInsuranceID!='WEXFORD'
										AND bv.[InpatientOrOutpatient]='O'
										AND DATEDIFF (year, bv.BirthDateTime, GETDATE()) > 18
										AND avq.Response IN ('WALSH','WADD','WNICF2','UHIRARIVR','UHIRAMCIN','UHIRAKEND','UHIRACENT','UHICF7','UHICF6','UHICF5','UHICF4','UHICF3','UHICF1','UHACT','SLPC','NONE','SUNYCAN','MMH','MATCC','IVYRIDGE','HEUV','HAMMOND','CPH','NULL')
									    AND adv.LocationID NOT IN('CAN','CANOPS','CHHC','CHHCOPS','HAMM','HAMMOPS','MAD','MADOPS','WADD','WADDOPS','LIS','LISOPS','HEUV','HEUVOPS','ER','CARD','WHS','WELL','MOB','LAB','LAB-PNP','LIFELINE','LAB-RIVER','SLEEPLAB','SP','OT','OPT','OB','OBO','NPREVRCR','NPREV','HHC')
							)
							
								OR EXISTS (SELECT AOO.Cpt
									FROM [CH_MTLIVE].[dbo].[AbsOvOperativeEpisodes] AOO
									WHERE AOO.Cpt BETWEEN '10021' AND '69990'
										AND AOO.Cpt NOT IN('11042','11045','16020','16025','16030','29000','29010','29015','29020','29025','29035','29040','29044','29046','29049','29055','29058','29065','29075','29085','29086','29105','29125','29126','29200','29240','29260','29280',
										'29305','29325','29345','29355','29358','29365','29405','29425','29435','29440','29445','29450','29505','29515','29520','29530','29540','29550','29580','29581',
										'29582','36400','36405','36406','36415','36416','36420','36425','36440','36450','36455','36460','36468','36469','36470','36471','36600','36620','36625','36660',
										'51701','51702','59020','59025','36591','36592','29130','29131','29583','29584','29700','29705','29710','29715','29720','29730','29740','29750','29799','36430')
										AND   bv.VisitID=AOO.VisitID
										--AND	  CONVERT(varchar(10),adv.ServiceDateTime,23) BETWEEN @StartDate AND @EndDate
										AND adv.ServiceDateTime>= DATEADD(mm,DATEDIFF(mm,0,GETDATE())-2,0) AND adv.ServiceDateTime < DATEADD(mm,DATEDIFF(mm,0,GETDATE())-1,0)
										AND bv.PrimaryInsuranceID!='WEXFORD'
										AND bv.[InpatientOrOutpatient]='O'
										AND DATEDIFF (year, bv.BirthDateTime, GETDATE()) > 18
										AND avq.Response IN ('WALSH','WADD','WNICF2','UHIRARIVR','UHIRAMCIN','UHIRAKEND','UHIRACENT','UHICF7','UHICF6','UHICF5','UHICF4','UHICF3','UHICF1','UHACT','SLPC','NONE','SUNYCAN','MMH','MATCC','IVYRIDGE','HEUV','HAMMOND','CPH','NULL')
									    AND adv.LocationID NOT IN('CAN','CANOPS','CHHC','CHHCOPS','HAMM','HAMMOPS','MAD','MADOPS','WADD','WADDOPS','LIS','LISOPS','HEUV','HEUVOPS','ER','CARD','WHS','WELL','MOB','LAB','LAB-PNP','LIFELINE','LAB-RIVER','SLEEPLAB','SP','OT','OPT','OB','OBO','NPREVRCR','NPREV','HHC')
							
								)
								

		  ORDER BY bv.ServiceDateTime
							   
		  					 