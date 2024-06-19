param(
    [Parameter(Mandatory = $true)]
    [string]$serverInstance,
    [Parameter(Mandatory = $true)]
    [Int64]$scelta
)

function Publish-AllApp {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ServerInstance,
        [Parameter(Mandatory = $true)]
        [Array]$dependenciesArray,
        [Parameter(Mandatory = $true)]
        [string]$PathApp
    )
    foreach ($line in $dependenciesArray) {
        
        $Contatore += 1
        $lastUnderscoreIndex = $line.LastIndexOf("_")
        $PenultimateUnderscoreString = $line.SubString(0, $lastUnderscoreIndex)
        $PenultimateUnderscoreIndex = $PenultimateUnderscoreString.LastIndexOf("_")
        $ultimateDotIndex = $line.LastIndexOf(".")

        $NomeApp = $line.SubString($PenultimateUnderscoreIndex + 1, $lastUnderscoreIndex - $PenultimateUnderscoreIndex - 1)
        $Versione = $line.SubString($lastUnderscoreIndex + 1, $ultimateDotIndex - $lastUnderscoreIndex - 1)
        $APPPath = ".\" + $PathApp + $line

        # ------------------------Pubblicazione-----------------------------------
        Write-Host "Inizio Pubblicazione app $NomeApp" 
        Publish-NAVApp -ServerInstance $ServerInstance -Path $APPPath -SkipVerification
        Write-Host "Pubblicazione app $NomeApp" 

        # ------------------------Sync-----------------------------------
        Write-Host "Inizio Sync app $NomeApp" 
        Sync-NAVApp -ServerInstance $ServerInstance -Name $NomeApp -Version $Versione -Mode ForceSync -Force
        Write-Host "Fine Sync app $NomeApp"

        # ------------------------Install-----------------------------------
        Write-Host "Inizio Installazione app $NomeApp" 
        Install-NAVApp -ServerInstance $ServerInstance -Name $NomeApp -Version $Versione -Force 
        Write-Host "Fine Installazione app $NomeApp"

        # ------------------------Upgrade-----------------------------------
        Write-Host "Inizio Upgrade app $NomeApp" 
        Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name $NomeApp -Version $Versione -Force
        Write-Host "Fine Upgrade app $NomeApp"

        Write-host "app N."$Contatore        
    }
}


function Uninstall-UnpublishAllApp {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ServerInstance,
        [Parameter(Mandatory = $true)]
        [Array]$dependenciesArray
    )
    foreach ($line in $dependenciesArray) {
        Write-Host $line

        $lastUnderscoreIndex = $line.LastIndexOf("_")
        $PenultimateUnderscoreString = $line.SubString(0, $lastUnderscoreIndex)
        $PenultimateUnderscoreIndex = $PenultimateUnderscoreString.LastIndexOf("_")
        $ultimateDotIndex = $line.LastIndexOf(".")
        
        $NomeApp = $line.SubString($PenultimateUnderscoreIndex + 1, $lastUnderscoreIndex - $PenultimateUnderscoreIndex - 1)
        $Versione = $line.SubString($lastUnderscoreIndex + 1, $ultimateDotIndex - $lastUnderscoreIndex - 1)

        # ------------------------Disinstallazione----------------------------------
        Write-Host "Inizio Disinstallazione app $NomeApp" 
        Uninstall-NAVApp $ServerInstance -Name $NomeApp -Force
        Write-Host "Disinstallata $NomeApp"
        # ------------------------Depubblicazione-----------------------------------
        Write-Host "Inizio depubblicazione app $NomeApp" 
        Unpublish-NAVApp $ServerInstance -Name $NomeApp
        Write-Host "Depubblicazione app $NomeApp" 
        
        # Stampa i risultati
        Write-Host "NomeApp: $NomeApp"
        Write-Host "Versione: $Versione"
    }
}


function main {
    Import-Module "C:\Program Files\Microsoft Dynamics 365 Business Central\210\Service\NavAdminTool.ps1"

    $filePath = ".\Apps\dependencies.txt"
    $logFilePath = ".\logfile.log"
    $appPath = @(".\Apps\", ".\Runtime\")
    $dependenciesArray = @()

    if (Test-Path $filePath -PathType Leaf) {
        $dependenciesArray = Get-Content $filePath
        Write-Host "File letto correttamente. Righe lette: $($dependenciesArray.Count)"
    }
    else {
        Write-Error "Il file non esiste o il percorso è sbagliato." | Out-File $logFilePath -Append
        exit
    }

    [array]::reverse($dependenciesArray)
    Uninstall-UnpublishAllApp -ServerInstance $serverInstance -dependenciesArray $dependenciesArray
    [array]::reverse($dependenciesArray)  # Ripristina l'array originale
    Publish-AllApp -ServerInstance $serverInstance -dependenciesArray $dependenciesArray -PathApp $appPath[$scelta - 1]

    $apps = Get-NAVAppInfo -ServerInstance $serverInstance | Where-Object -Property publisher -like 'cpl*'
    $appCount = $apps.Count
    Write-Host "Numero totale di app pubblicate: $appCount"
    "[$(Get-Date)] $serverInstance $appCount" | Out-File -FilePath $logFilePath -Append
}

main -ServerInstance $serverInstance -scelta $scelta
