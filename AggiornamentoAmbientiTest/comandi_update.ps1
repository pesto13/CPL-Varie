ast -> ASTBC21
vergas -> BC210_2

# hanno dato errore
casirate -> CASIRATEBC21
soresina -> SORESINATESTING


New-NAVServerUser -FullName 'Francesco Bellodi' -ServerInstance 'bc210'-WindowsAccount 'CPGNET\bellodifrancesco'-LicenseType 'Full' -State 'Disabled'
New-NAVServerUserPermissionSet -ServerInstance 'bc210' -PermissionSetId 'SUPER' -WindowsAccount 'CPGNET\bellodifrancesco'


New-NAVServerUser -FullName 'Francesco Bellodi' -ServerInstance 'bc210'-WindowsAccount 'CPGNET\bellodif'-LicenseType 'Full' -State 'Disabled'
New-NAVServerUserPermissionSet -ServerInstance 'bc210' -PermissionSetId 'SUPER' -WindowsAccount 'CPGNET\bellodif'

# ti devi attivare

Restart-NAVServerInstance 'bc210'
.\InvokeCodeUnit_VERGAS.ps1