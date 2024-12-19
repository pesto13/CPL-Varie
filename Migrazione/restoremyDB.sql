-- Questo file viene utilizzato per migrazione del percorso da cliente 21 a 21.
-- Serve solo per aggiornare i percorsi mettendo DATI

-- setup AU
update [casirate].[dbo].[casirate$NDMDistr-Gas Setup$e895c92b-9469-4077-90be-6e4be122c7a0]
set [Changes File Path] = 'C:\businessCentralRobe\casirate\',
	[SII Reading Sending Path] = 'C:\businessCentralRobe\casirate\'


-- setup servizi
update [casirate].[dbo].[casirate$NDMServices Quality Setup$e895c92b-9469-4077-90be-6e4be122c7a0]
set [V_D Sending Path] = 'C:\businessCentralRobe\casirate\',
	[Server V_D Reception Path] = 'C:\businessCentralRobe\casirate\',
	[Readings Path] = 'C:\businessCentralRobe\casirate\',
	[PercorsoFileLog] = 'C:\businessCentralRobe\casirate\',
	[PercorsoBonusGas] = 'C:\businessCentralRobe\casirate\',
	[Path Invio SII] = 'C:\businessCentralRobe\casirate\',
	[Percorso File a portale] = 'C:\businessCentralRobe\casirate\',
	[Percorso Stampe Documenti] = 'C:\businessCentralRobe\casirate\',
	[DefaultPath] = 'C:\businessCentralRobe\casirate\',
    [PercorsoFTPPraticheLegali] = 'C:\businessCentralRobe\casirate\',
    [PercorsoPraticheLegali] = 'C:\businessCentralRobe\casirate\',
    [URLDocumentiPortale] = 'C:\businessCentralRobe\casirate\'


-- venditori
update [casirate].[dbo].[casirate$NDMGas Vendor$80210a5a-2b85-4c29-95f9-64117945258f]
set [Path_Cart_Doc] = 'C:\businessCentralRobe\casirate\' where Tipo = '1'


-- Fatturazione Elettronica
update [casirate].[dbo].[casirate$NDMDocument Sending Setup$73a7b05d-98d4-4dc6-bad2-8341e12da117]
set [XML Path] = 'C:\businessCentralRobe\casirate\',
	[XML Test Path] = 'C:\businessCentralRobe\casirate\',
	[Archive XML Path] = 'C:\businessCentralRobe\casirate\',
	[PDF Path] = 'C:\businessCentralRobe\casirate\',
	[Alternative PDF Path] = 'C:\businessCentralRobe\casirate\'


update [casirate].[dbo].[casirate$NDMDocument Sending Setup 2$73a7b05d-98d4-4dc6-bad2-8341e12da117]
set [Detailed PDF Path] = 'C:\businessCentralRobe\casirate\',
	[PDF Path Paper Purchases] = 'C:\businessCentralRobe\casirate\',
	[Reminder Attachments Path] = 'C:\businessCentralRobe\casirate\',
	[PEC XML Backup Path] = 'C:\businessCentralRobe\casirate\'


update [casirate].[dbo].[casirate$NDMLog File Export$e895c92b-9469-4077-90be-6e4be122c7a0]
set [FileName] = 'C:\businessCentralRobe\casirate\',
	[File Path] = 'C:\businessCentralRobe\casirate\'