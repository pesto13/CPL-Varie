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
        
        $lastUnderscoreIndex = $line.LastIndexOf("_")
        $PenultimateUnderscoreString = $line.SubString(0, $lastUnderscoreIndex)
        $PenultimateUnderscoreIndex = $PenultimateUnderscoreString.LastIndexOf("_")
        $ultimateDotIndex = $line.LastIndexOf(".")

        $NomeApp = $line.SubString($PenultimateUnderscoreIndex + 1, $lastUnderscoreIndex - $PenultimateUnderscoreIndex - 1)
        $Versione = $line.SubString($lastUnderscoreIndex + 1, $ultimateDotIndex - $lastUnderscoreIndex - 1)

        if ($scelta -eq 2){ $line = $line.Replace('.app', '.runtime.app') }   

        $APPPath = ".\" + $PathApp + $line

        # ------------------------Pubblicazione-----------------------------------
        Write-Verbose "Inizio Pubblicazione app $NomeApp" 
        Publish-NAVApp -ServerInstance $ServerInstance -Path $APPPath -SkipVerification
        Write-Verbose "Pubblicazione app $NomeApp" 

        # ------------------------Sync-----------------------------------
        Write-Verbose "Inizio Sync app $NomeApp" 
        Sync-NAVApp -ServerInstance $ServerInstance -Name $NomeApp -Version $Versione -Mode ForceSync -Force
        Write-Verbose "Fine Sync app $NomeApp"

        # ------------------------Install-----------------------------------
        Write-Verbose "Inizio Installazione app $NomeApp" 
        Install-NAVApp -ServerInstance $ServerInstance -Name $NomeApp -Version $Versione -Force 
        Write-Verbose "Fine Installazione app $NomeApp"

        # ------------------------Upgrade-----------------------------------
        Write-Verbose "Inizio Upgrade app $NomeApp" 
        Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name $NomeApp -Version $Versione -Force
        Write-Verbose "Fine Upgrade app $NomeApp"

        $ProgressNumber++
        Write-Progress -Activity "$serverInstance" -Status "Uninstalling app: $NomeApp" -PercentComplete ($ProgressNumber / $dependenciesArray.Count) * 100 / 2 
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
        Write-Verbose $line

        $lastUnderscoreIndex = $line.LastIndexOf("_")
        $PenultimateUnderscoreString = $line.SubString(0, $lastUnderscoreIndex)
        $PenultimateUnderscoreIndex = $PenultimateUnderscoreString.LastIndexOf("_")
        $ultimateDotIndex = $line.LastIndexOf(".")
        
        $NomeApp = $line.SubString($PenultimateUnderscoreIndex + 1, $lastUnderscoreIndex - $PenultimateUnderscoreIndex - 1)
        $Versione = $line.SubString($lastUnderscoreIndex + 1, $ultimateDotIndex - $lastUnderscoreIndex - 1)

        # ------------------------Disinstallazione----------------------------------
        Write-Verbose "Inizio Disinstallazione app $NomeApp" 
        Uninstall-NAVApp $ServerInstance -Name $NomeApp -Force
        Write-Verbose "Disinstallata $NomeApp"
        # ------------------------Depubblicazione-----------------------------------
        Write-Verbose "Inizio depubblicazione app $NomeApp" 
        Unpublish-NAVApp $ServerInstance -Name $NomeApp
        Write-Verbose "Depubblicazione app $NomeApp" 
        
        # Stampa i risultati
        Write-Verbose "NomeApp: $NomeApp"
        Write-Verbose "Versione: $Versione"

        $ProgressNumber++
        Write-Progress -Activity "$serverInstance" -Status "Uninstalling app: $NomeApp" -PercentComplete ($ProgressNumber / $dependenciesArray.Count) * 100 / 2
    }
}

$ProgressNumber

function main {
    Import-Module "C:\Program Files\Microsoft Dynamics 365 Business Central\210\Service\NavAdminTool.ps1" | Out-Null

    $dependenciesPath = ".\Apps\dependencies.txt"
    $appPath = @(".\Apps\", ".\Runtime\")
    $dependenciesArray = @()

    if (Test-Path $dependenciesPath -PathType Leaf) {
        $dependenciesArray = Get-Content $dependenciesPath
        Write-Verbose "File letto correttamente. Righe lette: $($dependenciesArray.Count)"
    }

    # attività
    [array]::reverse($dependenciesArray)
    Uninstall-UnpublishAllApp -ServerInstance $serverInstance -dependenciesArray $dependenciesArray 
    [array]::reverse($dependenciesArray)
    Publish-AllApp -ServerInstance $serverInstance -dependenciesArray $dependenciesArray -PathApp $appPath[$scelta - 1] -scelta $scelta

    # log
    $appCount = (Get-NAVAppInfo -ServerInstance $serverInstance | Where-Object -Property publisher -like 'cpl*').Count
    Write-Verbose "Numero totale di app pubblicate: $appCount"
    Write-Output "[$(Get-Date)] $serverInstance $appCount $env:USERNAME"
}

main
