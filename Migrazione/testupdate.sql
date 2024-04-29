-- setup au
-- setup servizi
-- le schede dei venditori
-- il setup della fatturazione elettronica

-- setup AU
update [AZZANESE$NDMDistr-Gas Setup$e895c92b-9469-4077-90be-6e4be122c7a0]
set [Changes File Path] = replace([Changes File Path], 'fatture$\sgds\', 'fatture$\sgds\DATI\'),
	[SII Reading Sending Path] = replace([SII Reading Sending Path], 'fatture$\sgds\', 'fatture$\sgds\DATI\')

-- setup servizi
update [AZZANESE$NDMServices Quality Setup$e895c92b-9469-4077-90be-6e4be122c7a0]
set [V_D Sending Path] = replace([V_D Sending Path], 'fatture$\sgds\', 'fatture$\sgds\DATI\'),
	[Server V_D Reception Path] = replace([Server V_D Reception Path], 'fatture$\sgds\', 'fatture$\sgds\DATI\'),
	[Readings Path] = replace([Readings Path], 'fatture$\sgds\', 'fatture$\sgds\DATI\'),
	[PercorsoFileLog] = replace([PercorsoFileLog], 'fatture$\sgds\', 'fatture$\sgds\DATI\'),
	[PercorsoBonusGas] = replace([PercorsoBonusGas], 'fatture$\sgds\', 'fatture$\sgds\DATI\'),
	[Path Invio SII] = replace([Path Invio SII], 'fatture$\sgds\', 'fatture$\sgds\DATI\'),
	[Percorso File a portale] = replace([Percorso File a portale], 'fatture$\sgds\', 'fatture$\sgds\DATI\'),
	[Percorso Stampe Documenti] = replace([Percorso Stampe Documenti], 'fatture$\sgds\', 'fatture$\sgds\DATI\'),
	[DefaultPath] = replace([DefaultPath], 'fatture$\sgds\', 'fatture$\sgds\DATI\'),
    [PercorsoFTPPraticheLegali] = replace([PercorsoFTPPraticheLegali], 'fatture$\sgds\', 'fatture$\sgds\DATI\'),
    [PercorsoPraticheLegali] = replace([PercorsoPraticheLegali], 'fatture$\sgds\', 'fatture$\sgds\DATI\'),
    [URLDocumentiPortale] = replace([URLDocumentiPortale], 'fatture$\sgds\', 'fatture$\sgds\DATI\'),

-- venditori
update [AZZANESE$NDMGas Vendor$80210a5a-2b85-4c29-95f9-64117945258f]
set [Path_Cart_Doc] = replace([Path_Cart_Doc], 'fatture$\sgds\', 'fatture$\sgds\DATI\')


-- Fatturazione Elettronica?
update [AZZANESE$NDMDocument Sending Setup$73a7b05d-98d4-4dc6-bad2-8341e12da117]
set [XML Path] = replace([XML Path], 'fatture$\sgds\', 'fatture$\sgds\DATI\'),
	[XML Test Path] = replace([XML Test Path], 'fatture$\sgds\', 'fatture$\sgds\DATI\'),
	[Archive XML Path] = replace([Archive XML Path], 'fatture$\sgds\', 'fatture$\sgds\DATI\'),
	[PDF Path] = replace([PDF Path], 'fatture$\sgds\', 'fatture$\sgds\DATI\'),
	[Alternative PDF Path] = replace([Alternative PDF Path], 'fatture$\sgds\', 'fatture$\sgds\DATI\')

update [AZZANESE$NDMDocument Sending Setup 2$73a7b05d-98d4-4dc6-bad2-8341e12da117]
set [Detailed PDF Path] = replace([Detailed PDF Path], 'fatture$\sgds\', 'fatture$\sgds\DATI\'),
	[PDF Path Paper Purchases] = replace([PDF Path Paper Purchases], 'fatture$\sgds\', 'fatture$\sgds\DATI\'),
	[Reminder Attachments Path] = replace([Reminder Attachments Path], 'fatture$\sgds\', 'fatture$\sgds\DATI\'),
	[PEC XML Backup Path] = replace([PEC XML Backup Path], 'fatture$\sgds\', 'fatture$\sgds\DATI\')
