Import-Module 'C:\Program Files\Microsoft Dynamics 365 Business central\210\Service\NavAdminTool.ps1' 
Import-Module 'C:\Program Files\Microsoft Dynamics 365 Business Central\210\Web Client\Modules\NAVWebClientManagement\NAVWebClientManagement.psm1' 

$PORTEMD = 'porte.md'
$DEFULT_SLOT_PORT = 'defaultSlotPort.json'

function Get-NextDNT{
    #TODO attenzione che con 10 slot non funziona piu
    param(
        [Parameter(Mandatory=$true)]
        [String]$latestDNT
    )

    $dntNumber = [int][string]$latestDNT[-1]
    return "DNT" + ((([int]$dntNumber) % 7) + 1)
}

function Get-AutomaticNextSlot {
    # leggo da file porte e leggo ultimo DNT
    $latestDNT = (Get-Content $PORTEMD | Select-Object -Last 1) -split "`t" | Select-Object -first 1
    return Get-NextDNT($latestDNT)
}

function Get-AutomaticNextFirstPort {
    param (
        [Parameter(Mandatory=$true)]
        [string]$SlotX
    )
    $jsonData = Get-Content -Path $DEFULT_SLOT_PORT -Raw | ConvertFrom-Json -AsHashtable
    return $jsonData[$SlotX]
}


do {
    $ServerTestInstance = Read-Host "Inserisci il nome dell'istanza del server di test (Nel formato TESTNOMEAZIENDA)"
    $ServerTestInstance = $ServerTestInstance.ToUpper()

    $SlotNumber = Read-Host "Inserisci lo slot nel quale inserire il DB (solo il numero)"
    $SlotX = "DNT"+$SlotNumber
    $porta1 = [int]$porta1 = Read-Host "Inserisci la porta1"
    $porta2 = $porta1 + 1
    $porta3 = $porta2 + 1
    $porta4 = $porta3 + 1
    $porta5 = $porta4 + 1

    # Richiedi conferma all'utente
    $risposta = Read-Host "Ti creo $ServerTestInstance con le porte da $porta1 a $porta5, usando lo SLOT DB $SlotX confermi? (S (Si) / N (No))" -ErrorAction Stop
} while ($risposta -ne "S")


$ServiceAccountCredential = Get-Credential
New-NAVServerInstance -ManagementServicesPort $porta1 -ServerInstance $ServerTestInstance -ClientServicesCredentialType UserName -ClientServicesPort $porta2 -DatabaseName $SlotX -DatabaseServer sv-dbbc-test.cpgnet.local -DeveloperServicesPort $porta3 -ODataServicesPort $porta4 -ServiceAccount User -ServiceAccountCredential $ServiceAccountCredential -SOAPServicesPort $porta5

Set-NAVServerConfiguration -KeyName DatabaseInstance -ServerInstance $ServerTestInstance 
Set-NAVServerConfiguration -KeyName DefaultLanguage -ServerInstance $ServerTestInstance -KeyValue it-IT
Set-NAVServerConfiguration -KeyName ServicesLanguage -ServerInstance $ServerTestInstance -KeyValue it-IT
Set-NAVServerConfiguration -KeyName ServicesDefaultTimeZone -ServerInstance $ServerTestInstance -KeyValue "Server Time Zone"
Set-NAVServerConfiguration -KeyName ClientServicesMaxUploadSize -ServerInstance $ServerTestInstance -KeyValue 1024
Set-NAVServerConfiguration -KeyName TaskSchedulerSystemTaskStartTime -ServerInstance $ServerTestInstance -KeyValue 18:45:00
Set-NAVServerConfiguration -KeyName TaskSchedulerSystemTaskEndTime -ServerInstance $ServerTestInstance -KeyValue 08:00:00 
Set-NAVServerConfiguration -KeyName EnableTaskScheduler -ServerInstance $ServerTestInstance -KeyValue false 

# attualmente esiste 1 sola macchina quindi testdnt2 non esiste
New-NAVWebServerInstance -Server sv-srv-testdnt.cpgnet.local -ServerInstance $ServerTestInstance -WebServerInstance $ServerTestInstance -ClientServicesCredentialType UserName -ClientServicesPort $porta2 -ContainerSiteName "Microsoft Dynamics 365 Business Central Web Client" -PublishFolder "C:\Program Files\Microsoft Dynamics 365 Business Central\210\Web Client\WebPublish" -SiteDeploymentType SubSite 
Set-NAVWebServerInstanceConfiguration -WebServerInstance $ServerTestInstance -KeyName Designer -KeyValue false

# documento sul file
$informazioni = "$SlotX`t$ServerTestInstance`t$porta1-$porta5"
Add-Content -Path $PORTEMD -Value $informazioni