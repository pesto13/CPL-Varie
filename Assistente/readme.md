# Utente Servizio

## active directory
crealo con i suoi valori e mettilo nei 3 gruppi
- okta1
- okta2
- user del cliente

## okta
Successivamente mettergli anche okta  
https://cplconcordia-admin.okta.com/admin/app/active_directory/instance/0oa4t31dm9tyZYAtl696#tab-import

## ambiente
New-NAVServerUser -FullName 'Alessandra Corna' -ServerInstance 'condottenord'-WindowsAccount 'CPGNET\cornaa'-LicenseType 'Full'
New-NAVServerUserPermissionSet -ServerInstance 'condottenord' -PermissionSetId 'SUPER' -WindowsAccount 'CPGNET\cornaa'



ricordati che gli utenti devono essere inseriti anche sul loro ambiente, tramite powershell

# Creazione Cliente

quando creo un nuovo cliente devo inserigli okta su questo link  
https://cplconcordia-admin.okta.com/admin/apps/active   



## Disabilitazione utente

Da active directory (mgt) metterlo disabled, e poi metterlo nella directory dei disabled.  
Poi va disattivato anche su powershell, credo con il -state disabled  
```Set-NAVServerUser -WindowsAccount '' -ServerInstance '' -State 'Disabled'```


----


# JIRA

## Aggiungi persone

https://cpl4utilities.atlassian.net/jira/servicedesk/projects/CPL/customers