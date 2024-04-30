-- setup au
-- setup servizi
-- le schede dei venditori
-- il setup della fatturazione elettronica

-- setup AU
update [COMPANYNAME$NDMDistr-Gas Setup$e895c92b-9469-4077-90be-6e4be122c7a0]
set [Changes File Path] = replace([Changes File Path], 'fatture$\COMPANY_NAME\', 'fatture$\COMPANY_NAME\DATI\'),
	[SII Reading Sending Path] = replace([SII Reading Sending Path], 'fatture$\COMPANY_NAME\', 'fatture$\COMPANY_NAME\DATI\')


-- setup servizi
update [COMPANYNAME$NDMServices Quality Setup$e895c92b-9469-4077-90be-6e4be122c7a0]
set [V_D Sending Path] = replace([V_D Sending Path], 'fatture$\COMPANY_NAME\', 'fatture$\COMPANY_NAME\DATI\'),
	[Server V_D Reception Path] = replace([Server V_D Reception Path], 'fatture$\COMPANY_NAME\', 'fatture$\COMPANY_NAME\DATI\'),
	[Readings Path] = replace([Readings Path], 'fatture$\COMPANY_NAME\', 'fatture$\COMPANY_NAME\DATI\'),
	[PercorsoFileLog] = replace([PercorsoFileLog], 'fatture$\COMPANY_NAME\', 'fatture$\COMPANY_NAME\DATI\'),
	[PercorsoBonusGas] = replace([PercorsoBonusGas], 'fatture$\COMPANY_NAME\', 'fatture$\COMPANY_NAME\DATI\'),
	[Path Invio SII] = replace([Path Invio SII], 'fatture$\COMPANY_NAME\', 'fatture$\COMPANY_NAME\DATI\'),
	[Percorso File a portale] = replace([Percorso File a portale], 'fatture$\COMPANY_NAME\', 'fatture$\COMPANY_NAME\DATI\'),
	[Percorso Stampe Documenti] = replace([Percorso Stampe Documenti], 'fatture$\COMPANY_NAME\', 'fatture$\COMPANY_NAME\DATI\'),
	[DefaultPath] = replace([DefaultPath], 'fatture$\COMPANY_NAME\', 'fatture$\COMPANY_NAME\DATI\'),
    [PercorsoFTPPraticheLegali] = replace([PercorsoFTPPraticheLegali], 'fatture$\COMPANY_NAME\', 'fatture$\COMPANY_NAME\DATI\'),
    [PercorsoPraticheLegali] = replace([PercorsoPraticheLegali], 'fatture$\COMPANY_NAME\', 'fatture$\COMPANY_NAME\DATI\'),
    [URLDocumentiPortale] = replace([URLDocumentiPortale], 'fatture$\COMPANY_NAME\', 'fatture$\COMPANY_NAME\DATI\'),


-- venditori
update [COMPANYNAME$NDMGas Vendor$80210a5a-2b85-4c29-95f9-64117945258f]
set [Path_Cart_Doc] = replace([Path_Cart_Doc], 'fatture$\COMPANY_NAME\', 'fatture$\COMPANY_NAME\DATI\')


-- Fatturazione Elettronica
update [COMPANYNAME$NDMDocument Sending Setup$73a7b05d-98d4-4dc6-bad2-8341e12da117]
set [XML Path] = replace([XML Path], 'fatture$\COMPANY_NAME\', 'fatture$\COMPANY_NAME\DATI\'),
	[XML Test Path] = replace([XML Test Path], 'fatture$\COMPANY_NAME\', 'fatture$\COMPANY_NAME\DATI\'),
	[Archive XML Path] = replace([Archive XML Path], 'fatture$\COMPANY_NAME\', 'fatture$\COMPANY_NAME\DATI\'),
	[PDF Path] = replace([PDF Path], 'fatture$\COMPANY_NAME\', 'fatture$\COMPANY_NAME\DATI\'),
	[Alternative PDF Path] = replace([Alternative PDF Path], 'fatture$\COMPANY_NAME\', 'fatture$\COMPANY_NAME\DATI\')


update [COMPANYNAME$NDMDocument Sending Setup 2$73a7b05d-98d4-4dc6-bad2-8341e12da117]
set [Detailed PDF Path] = replace([Detailed PDF Path], 'fatture$\COMPANY_NAME\', 'fatture$\COMPANY_NAME\DATI\'),
	[PDF Path Paper Purchases] = replace([PDF Path Paper Purchases], 'fatture$\COMPANY_NAME\', 'fatture$\COMPANY_NAME\DATI\'),
	[Reminder Attachments Path] = replace([Reminder Attachments Path], 'fatture$\COMPANY_NAME\', 'fatture$\COMPANY_NAME\DATI\'),
	[PEC XML Backup Path] = replace([PEC XML Backup Path], 'fatture$\COMPANY_NAME\', 'fatture$\COMPANY_NAME\DATI\')
