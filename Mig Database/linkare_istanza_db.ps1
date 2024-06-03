
# BC14 MIGMUBI14
# BC21 MIG_MUBI

# DataBase14 db14
# DataBase21 db21


# collego istanza al db 14
Set-NAVServerConfiguration MIGMUBI14 -KeyName DatabaseName -KeyValue 'db14'
Restart-NAVServerInstance MIGMUBI14

Get-NavCompany -ServerInstance MIGMUBI14

# collego istanza al db 21
Set-NAVServerConfiguration MIG_MUBI -KeyName DatabaseName -KeyValue 'db21'
Restart-NAVServerInstance MIG_MUBI

New-NAVCompany -ServerInstance MIG_MUBI -CompanyName 'XXX' -CompanyDisplayName 'YYY'
Remove-NAVCompany -ServerInstance MIG_MUBI -CompanyName DBSTARTUPBC
