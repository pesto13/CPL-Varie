-- truncate table [PROTOS$NDMRate Version$da897d7a-9bd9-4b9b-bc17-408c6a527edf]
-- truncate table [PROTOS$NDMRate Threshold$da897d7a-9bd9-4b9b-bc17-408c6a527edf]

select *
from [SADORI].[dbo].[SADORI$NDMRate Version$da897d7a-9bd9-4b9b-bc17-408c6a527edf]
where [Cod_ Tariffa] <> 'COL C'

INSERT INTO [PROTOS].[dbo].[PROTOS$NDMRate Version$da897d7a-9bd9-4b9b-bc17-408c6a527edf]
    ([Cod_ Tariffa]
    ,[Cod_ Variante]
    ,[Data Inizio Validita]
    ,[Numeratore]
    ,[Descrizione Versione]
    ,[Errata]
    )
SELECT 
    [Cod_ Tariffa]
    ,[Cod_ Variante]
    ,[Data Inizio Validita]
    ,[Numeratore]
    ,[Descrizione Versione]
    ,[Errata] 
FROM [SADORI].[dbo].[SADORI$NDMRate Version$da897d7a-9bd9-4b9b-bc17-408c6a527edf]
WHERE [Cod_ Tariffa] <> 'COL C'
    and [Data Inizio Validita] >= '20230101'


-----------------


INSERT INTO [PROTOS].[dbo].[PROTOS$NDMRate Threshold$da897d7a-9bd9-4b9b-bc17-408c6a527edf]
    ([Cod_ Tariffa]
    ,[Cod_ Variante]
    ,[Data Inizio Validita]
    ,[Inizio Soglia]
    ,[Numeratore]
    ,[Importo Unitario]
    ,[Descrizione Soglia]
    )
SELECT 
    [Cod_ Tariffa]
    ,[Cod_ Variante]
    ,[Data Inizio Validita]
    ,[Inizio Soglia]
    ,[Numeratore]
    ,[Importo Unitario]
    ,[Descrizione Soglia]
FROM [SADORI].[dbo].[SADORI$NDMRate Threshold$da897d7a-9bd9-4b9b-bc17-408c6a527edf]
where [Data Inizio Validita] >= '20230101'

------------------------

-- truncate table [PROTOS].[dbo].[PROTOS$NDMBonus Amount$d9d81130-aa13-4a6d-b5b4-be484f77f07e]

INSERT INTO [PROTOS].[dbo].[PROTOS$NDMBonus Amount$d9d81130-aa13-4a6d-b5b4-be484f77f07e]
    ([Large Family]
    ,[Purpose Type]
    ,[Climatic Zone]
    ,[Start Date]
    ,[Compensation Amount]
    ,[End Date]
    ,[Numerator]
    ,[Creation Date]
    ,[Creation User ID]
    ,[Modification Date]
    ,[Modifier User ID]
    ,[NDMCompensation Amount]
    ,[NDMCompensation Amount 1Q]
    ,[NDMCompensation Amount 2Q]
    ,[NDMCompensation Amount 3Q]
    ,[NDMCompensation Amount 4Q])
SELECT
    [Large Family]
    ,[Purpose Type]
    ,[Climatic Zone]
    ,[Start Date]
    ,[Compensation Amount]
    ,[End Date]
    ,[Numerator]
    ,[Creation Date]
    ,[Creation User ID]
    ,[Modification Date]
    ,[Modifier User ID]
    ,[NDMCompensation Amount]
    ,[NDMCompensation Amount 1Q]
    ,[NDMCompensation Amount 2Q]
    ,[NDMCompensation Amount 3Q]
    ,[NDMCompensation Amount 4Q]
FROM [SADORI].[dbo].[SADORI$NDMBonus Amount$d9d81130-aa13-4a6d-b5b4-be484f77f07e]
WHERE [Start Date] >= '20230101'


