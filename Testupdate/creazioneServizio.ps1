Import-Module 'C:\Program Files\Microsoft Dynamics 365 Business central\210\Service\NavAdminTool.ps1' 
Import-Module 'C:\Program Files\Microsoft Dynamics 365 Business Central\210\Web Client\Modules\NAVWebClientManagement\NAVWebClientManagement.psm1' 

$PORTEMD = 'porte.md'
$DEFULT_SLOT_PORT = 'defaultSlotPort.json'

function Get-NextDNT{
    #TODO attenzione che con 10 slot non funziona piu
    # Calcola il prossimo DNT libero
    param(
        [String]$latestDNT
    )

    $dntNumber = [int][string]$latestDNT[-1]
    return "DNT" + ((([int]$dntNumber) % 7) + 1)
}

function Get-AutomaticNextSlot {
    # Legge da file porte e leggo ultimo DNT, restituisce il prossimo DNT
    $latestDNT = (Get-Content $PORTEMD | Select-Object -Last 1) -split "`t" | Select-Object -first 1
    return Get-NextDNT($latestDNT)
}

function Get-AutomaticNextFirstPort {
    # Restuisce la porta di defualt associata allo slot specificato
    param (
        [string]$SlotX
    )
    $jsonData = Get-Content -Path $DEFULT_SLOT_PORT -Raw | ConvertFrom-Json -AsHashtable
    return [int]$jsonData[$SlotX]
}

function New-MyConfiguredNavInstance {
    param (
        [string]$ServerTestInstance,
        [string]$SlotX,
        [int[]]$porte
    )

    $ServiceAccountCredential = Get-Credential
    New-NAVServerInstance -ManagementServicesPort $porte[0] -ServerInstance $ServerTestInstance -ClientServicesCredentialType UserName -ClientServicesPort $porte[1] -DatabaseName $SlotX -DatabaseServer sv-dbbc-test.cpgnet.local -DeveloperServicesPort $porte[2] -ODataServicesPort $porte[3] -ServiceAccount User -ServiceAccountCredential $ServiceAccountCredential -SOAPServicesPort $porte[4]

    Set-NAVServerConfiguration -KeyName DatabaseInstance -ServerInstance $ServerTestInstance 
    Set-NAVServerConfiguration -KeyName DefaultLanguage -ServerInstance $ServerTestInstance -KeyValue it-IT
    Set-NAVServerConfiguration -KeyName ServicesLanguage -ServerInstance $ServerTestInstance -KeyValue it-IT
    Set-NAVServerConfiguration -KeyName ServicesDefaultTimeZone -ServerInstance $ServerTestInstance -KeyValue "Server Time Zone"
    Set-NAVServerConfiguration -KeyName ClientServicesMaxUploadSize -ServerInstance $ServerTestInstance -KeyValue 1024
    Set-NAVServerConfiguration -KeyName TaskSchedulerSystemTaskStartTime -ServerInstance $ServerTestInstance -KeyValue 18:45:00
    Set-NAVServerConfiguration -KeyName TaskSchedulerSystemTaskEndTime -ServerInstance $ServerTestInstance -KeyValue 08:00:00 
    Set-NAVServerConfiguration -KeyName EnableTaskScheduler -ServerInstance $ServerTestInstance -KeyValue false 

    # attualmente esiste 1 sola macchina quindi testdnt2 non esiste
    New-NAVWebServerInstance -Server sv-srv-testdnt.cpgnet.local -ServerInstance $ServerTestInstance -WebServerInstance $ServerTestInstance -ClientServicesCredentialType UserName -ClientServicesPort $porte[1] -ContainerSiteName "Microsoft Dynamics 365 Business Central Web Client" -PublishFolder "C:\Program Files\Microsoft Dynamics 365 Business Central\210\Web Client\WebPublish" -SiteDeploymentType SubSite 
    Set-NAVWebServerInstanceConfiguration -WebServerInstance $ServerTestInstance -KeyName Designer -KeyValue false
}

function Get-MyNavConfiguration{
    do {
        $ServerTestInstance = Read-Host "Inserisci il nome dell'istanza del server di test (Nel formato TESTNOMEAZIENDA)"
        $ServerTestInstance = $ServerTestInstance.ToUpper()
        $SlotNumber = Read-Host "Inserisci lo slot nel quale inserire il DB (solo il numero)"
        
        $automatic = $false
        if($SlotNumber -eq ''){
            $automatic = $true
        }
        
        $porte = @()

        if($automatic){
            $SlotX = Get-AutomaticNextSlot;
            $porte += Get-AutomaticNextFirstPort($SlotX);
        }else{
            $SlotX = "DNT"+$SlotNumber
            $porte += [int] (Read-Host "Inserisci la prima porta")
        }
        
        1..4 | ForEach-Object {
            $porte += $porte[0] + $_
        }
    
        # Richiedi conferma all'utente
        $primaPorta = $porte[0]
        $ultimaPorta = $porte[4]
        $risposta = Read-Host "Ti creo $ServerTestInstance con le porte da $primaPorta a $ultimaPorta, usando lo SLOT DB $SlotX confermi? (S (Si) / N (No))" -ErrorAction Stop
    } while ($risposta -ne "S")

    return $ServerTestInstance, $SlotX, $porte
}

function Write-FilePorte {
    param (
        [string]$ServerTestInstance,
        [string]$SlotX,
        [int[]]$porte
    )

    $informazioni = "$SlotX`t$($porte[0])-$($porte[4])`t$ServerTestInstance"
    Add-Content -Path $PORTEMD -Value $informazioni
}

# TODO check 
$val = Get-MyNavConfiguration
New-MyConfiguredNavInstance @val
Write-FilePorte @val
