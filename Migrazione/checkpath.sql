-- Questo file viene utilizzato per migrazione del percorso da cliente 21 a 21.
-- Serve solo per aggiornare i percorsi mettendo DATI

-- up AU
select distinct 
	[Changes File Path], 
	[SII Reading Sending Path] 
from [COMPANYNAME].[dbo].[COMPANYNAME$NDMDistr-Gas setup$e895c92b-9469-4077-90be-6e4be122c7a0]

-- up servizi
select distinct 
	[V_D Sending Path], 
	[Server V_D Reception Path], 
	[Readings Path], 
	[PercorsoFileLog], 
	[PercorsoBonusGas], 
	[Path Invio SII], 
	[Percorso File a portale], 
	[Percorso Stampe Documenti], 
	[DefaultPath], 
    [PercorsoFTPPraticheLegali], 
    [PercorsoPraticheLegali], 
    [URLDocumentiPortale]
from [COMPANYNAME].[dbo].[COMPANYNAME$NDMServices Quality setup$e895c92b-9469-4077-90be-6e4be122c7a0]

-- venditori
select distinct 
    [Path_Cart_Doc]
from [COMPANYNAME].[dbo].[COMPANYNAME$NDMGas Vendor$80210a5a-2b85-4c29-95f9-64117945258f]

-- Fatturazione Elettronica
select distinct 
    [XML Path], 
	[XML Test Path], 
	[Archive XML Path], 
	[PDF Path], 
	[Alternative PDF Path] 
from [COMPANYNAME].[dbo].[COMPANYNAME$NDMDocument Sending setup$73a7b05d-98d4-4dc6-bad2-8341e12da117]

select distinct 
    [Detailed PDF Path], 
	[PDF Path Paper Purchases], 
	[Reminder Attachments Path], 
	[PEC XML Backup Path]
from [COMPANYNAME].[dbo].[COMPANYNAME$NDMDocument Sending setup 2$73a7b05d-98d4-4dc6-bad2-8341e12da117]

select distinct 
	[FileName], 
	[File Path]
from [COMPANYNAME].[dbo].[COMPANYNAME$NDMLog File Export$e895c92b-9469-4077-90be-6e4be122c7a0]
