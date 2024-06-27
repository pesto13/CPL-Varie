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
        [string]$PathApp,
        [Parameter(Mandatory = $true)]
        [Int64]$scelta
    )
    foreach ($line in $dependenciesArray) {
        
        $Contatore += 1
        $lastUnderscoreIndex = $line.LastIndexOf("_")
        $PenultimateUnderscoreString = $line.SubString(0, $lastUnderscoreIndex)
        $PenultimateUnderscoreIndex = $PenultimateUnderscoreString.LastIndexOf("_")
        $ultimateDotIndex = $line.LastIndexOf(".")

        $NomeApp = $line.SubString($PenultimateUnderscoreIndex + 1, $lastUnderscoreIndex - $PenultimateUnderscoreIndex - 1)
        $Versione = $line.SubString($lastUnderscoreIndex + 1, $ultimateDotIndex - $lastUnderscoreIndex - 1)

        if ($scelta -eq 2){ $line = $line.Replace('.app', '.runtime.app') }   

        $APPPath = ".\" + $PathApp + $line

        # ------------------------Pubblicazione-----------------------------------
        Write-Output "Inizio Pubblicazione app $NomeApp" 
        Publish-NAVApp -ServerInstance $ServerInstance -Path $APPPath -SkipVerification
        Write-Output "Pubblicazione app $NomeApp" 

        # ------------------------Sync-----------------------------------
        Write-Output "Inizio Sync app $NomeApp" 
        Sync-NAVApp -ServerInstance $ServerInstance -Name $NomeApp -Version $Versione -Mode ForceSync -Force
        Write-Output "Fine Sync app $NomeApp"

        # ------------------------Install-----------------------------------
        Write-Output "Inizio Installazione app $NomeApp" 
        Install-NAVApp -ServerInstance $ServerInstance -Name $NomeApp -Version $Versione -Force 
        Write-Output "Fine Installazione app $NomeApp"

        # ------------------------Upgrade-----------------------------------
        Write-Output "Inizio Upgrade app $NomeApp" 
        Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name $NomeApp -Version $Versione -Force
        Write-Output "Fine Upgrade app $NomeApp"

        Write-Output "app N."$Contatore        
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
        Write-Output $line

        $lastUnderscoreIndex = $line.LastIndexOf("_")
        $PenultimateUnderscoreString = $line.SubString(0, $lastUnderscoreIndex)
        $PenultimateUnderscoreIndex = $PenultimateUnderscoreString.LastIndexOf("_")
        $ultimateDotIndex = $line.LastIndexOf(".")
        
        $NomeApp = $line.SubString($PenultimateUnderscoreIndex + 1, $lastUnderscoreIndex - $PenultimateUnderscoreIndex - 1)
        $Versione = $line.SubString($lastUnderscoreIndex + 1, $ultimateDotIndex - $lastUnderscoreIndex - 1)

        # ------------------------Disinstallazione----------------------------------
        Write-Output "Inizio Disinstallazione app $NomeApp" 
        Uninstall-NAVApp $ServerInstance -Name $NomeApp -Force
        Write-Output "Disinstallata $NomeApp"
        # ------------------------Depubblicazione-----------------------------------
        Write-Output "Inizio depubblicazione app $NomeApp" 
        Unpublish-NAVApp $ServerInstance -Name $NomeApp
        Write-Output "Depubblicazione app $NomeApp" 
        
        # Stampa i risultati
        Write-Output "NomeApp: $NomeApp"
        Write-Output "Versione: $Versione"
    }
}


function main {
    Import-Module "C:\Program Files\Microsoft Dynamics 365 Business Central\210\Service\NavAdminTool.ps1"

    $dependenciesPath = ".\Apps\dependencies.txt"
    $appPath = @(".\Apps\", ".\Runtime\")
    $dependenciesArray = @()

    if (Test-Path $dependenciesPath -PathType Leaf) {
        $dependenciesArray = Get-Content $dependenciesPath
        Write-Output "File letto correttamente. Righe lette: $($dependenciesArray.Count)"
    }

    # attivita
    [array]::reverse($dependenciesArray)
    Uninstall-UnpublishAllApp -ServerInstance $serverInstance -dependenciesArray $dependenciesArray
    [array]::reverse($dependenciesArray)
    Publish-AllApp -ServerInstance $serverInstance -dependenciesArray $dependenciesArray -PathApp $appPath[$scelta - 1] -scelta $scelta

    # log
    $appCount = (Get-NAVAppInfo -ServerInstance $serverInstance | Where-Object -Property publisher -like 'cpl*').Count
    Write-Output "Numero totale di app pubblicate: $appCount"
    return "[$(Get-Date)] $serverInstance $appCount $env:USERNAME"
}

main
