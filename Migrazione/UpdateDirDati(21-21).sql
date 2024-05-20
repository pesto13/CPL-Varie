-- Questo file viene utilizzato per migrazione del percorso da cliente 21 a 21.
-- Serve solo per aggiornare i percorsi mettendo DATI

-- setup AU
update [COMPANYNAME].[dbo].[COMPANYNAME$NDMDistr-Gas Setup$e895c92b-9469-4077-90be-6e4be122c7a0]
set [Changes File Path] = replace([Changes File Path], 'fatture$\COMPANYNAME\', 'fatture$\COMPANYNAME\DATI\'),
	[SII Reading Sending Path] = replace([SII Reading Sending Path], 'fatture$\COMPANYNAME\', 'fatture$\COMPANYNAME\DATI\')


-- setup servizi
update [COMPANYNAME].[dbo].[COMPANYNAME$NDMServices Quality Setup$e895c92b-9469-4077-90be-6e4be122c7a0]
set [V_D Sending Path] = replace([V_D Sending Path], 'fatture$\COMPANYNAME\', 'fatture$\COMPANYNAME\DATI\'),
	[Server V_D Reception Path] = replace([Server V_D Reception Path], 'fatture$\COMPANYNAME\', 'fatture$\COMPANYNAME\DATI\'),
	[Readings Path] = replace([Readings Path], 'fatture$\COMPANYNAME\', 'fatture$\COMPANYNAME\DATI\'),
	[PercorsoFileLog] = replace([PercorsoFileLog], 'fatture$\COMPANYNAME\', 'fatture$\COMPANYNAME\DATI\'),
	[PercorsoBonusGas] = replace([PercorsoBonusGas], 'fatture$\COMPANYNAME\', 'fatture$\COMPANYNAME\DATI\'),
	[Path Invio SII] = replace([Path Invio SII], 'fatture$\COMPANYNAME\', 'fatture$\COMPANYNAME\DATI\'),
	[Percorso File a portale] = replace([Percorso File a portale], 'fatture$\COMPANYNAME\', 'fatture$\COMPANYNAME\DATI\'),
	[Percorso Stampe Documenti] = replace([Percorso Stampe Documenti], 'fatture$\COMPANYNAME\', 'fatture$\COMPANYNAME\DATI\'),
	[DefaultPath] = replace([DefaultPath], 'fatture$\COMPANYNAME\', 'fatture$\COMPANYNAME\DATI\'),
    [PercorsoFTPPraticheLegali] = replace([PercorsoFTPPraticheLegali], 'fatture$\COMPANYNAME\', 'fatture$\COMPANYNAME\DATI\'),
    [PercorsoPraticheLegali] = replace([PercorsoPraticheLegali], 'fatture$\COMPANYNAME\', 'fatture$\COMPANYNAME\DATI\'),
    [URLDocumentiPortale] = replace([URLDocumentiPortale], 'fatture$\COMPANYNAME\', 'fatture$\COMPANYNAME\DATI\')


-- venditori
update [COMPANYNAME].[dbo].[COMPANYNAME$NDMGas Vendor$80210a5a-2b85-4c29-95f9-64117945258f]
set [Path_Cart_Doc] = replace([Path_Cart_Doc], 'fatture$\COMPANYNAME\', 'fatture$\COMPANYNAME\DATI\') where Tipo = '1'


-- Fatturazione Elettronica
update [COMPANYNAME].[dbo].[COMPANYNAME$NDMDocument Sending Setup$73a7b05d-98d4-4dc6-bad2-8341e12da117]
set [XML Path] = replace([XML Path], 'fatture$\COMPANYNAME\', 'fatture$\COMPANYNAME\DATI\'),
	[XML Test Path] = replace([XML Test Path], 'fatture$\COMPANYNAME\', 'fatture$\COMPANYNAME\DATI\'),
	[Archive XML Path] = replace([Archive XML Path], 'fatture$\COMPANYNAME\', 'fatture$\COMPANYNAME\DATI\'),
	[PDF Path] = replace([PDF Path], 'fatture$\COMPANYNAME\', 'fatture$\COMPANYNAME\DATI\'),
	[Alternative PDF Path] = replace([Alternative PDF Path], 'fatture$\COMPANYNAME\', 'fatture$\COMPANYNAME\DATI\')


update [COMPANYNAME].[dbo].[COMPANYNAME$NDMDocument Sending Setup 2$73a7b05d-98d4-4dc6-bad2-8341e12da117]
set [Detailed PDF Path] = replace([Detailed PDF Path], 'fatture$\COMPANYNAME\', 'fatture$\COMPANYNAME\DATI\'),
	[PDF Path Paper Purchases] = replace([PDF Path Paper Purchases], 'fatture$\COMPANYNAME\', 'fatture$\COMPANYNAME\DATI\'),
	[Reminder Attachments Path] = replace([Reminder Attachments Path], 'fatture$\COMPANYNAME\', 'fatture$\COMPANYNAME\DATI\'),
	[PEC XML Backup Path] = replace([PEC XML Backup Path], 'fatture$\COMPANYNAME\', 'fatture$\COMPANYNAME\DATI\')


update [COMPANYNAME].[dbo].[COMPANYNAME$NDMLog File Export$e895c92b-9469-4077-90be-6e4be122c7a0]
set [FileName] = replace([FileName], 'fatture$\COMPANYNAME\', 'fatture$\COMPANYNAME\DATI\'),
	[File Path] = replace([File Path], 'fatture$\COMPANYNAME\', 'fatture$\COMPANYNAME\DATI\')