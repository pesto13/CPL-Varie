
function Publish-AllApp {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ServerInstance,
        [Parameter(Mandatory = $true)]
        [Array]$dependenciesArray
    )
    $ProgressNumber = 0
    foreach ($line in $dependenciesArray) {
        
        $info = Get-NAVAppInfo -Path $line
        $AppVersion = $info.Version
        $AppName = $info.Name

        # ------------------------Pubblicazione-----------------------------------
        Write-Verbose "Inizio Pubblicazione app $AppName" 
        Publish-NAVApp -ServerInstance $ServerInstance -Path $line -SkipVerification
        Write-Verbose "Pubblicazione app $AppName" 

        # ------------------------Sync-----------------------------------
        Write-Verbose "Inizio Sync app $AppName" 
        Sync-NAVApp -ServerInstance $ServerInstance -Name $AppName -Version $AppVersion -Mode ForceSync -Force
        Write-Verbose "Fine Sync app $AppName"

        # ------------------------Install-----------------------------------
        Write-Verbose "Inizio Installazione app $AppName" 
        Install-NAVApp -ServerInstance $ServerInstance -Name $AppName -Version $AppVersion -Force 
        Write-Verbose "Fine Installazione app $AppName"

        # ------------------------Upgrade-----------------------------------
        Write-Verbose "Inizio Upgrade app $AppName" 
        Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name $AppName -Version $AppVersion -Force
        Write-Verbose "Fine Upgrade app $AppName"

        $ProgressNumber++
        Write-Progress -Activity "$serverInstance" -Status "Installing app: $AppName" -PercentComplete ($ProgressNumber / $dependenciesArray.Count * 100)
    }
}


function Uninstall-UnpublishAllApp {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ServerInstance,
        [Parameter(Mandatory = $true)]
        [Array]$dependenciesArray
    )
    $ProgressNumber = 0;
    foreach ($line in $dependenciesArray) {

        $info = Get-NAVAppInfo -Path $line
        $AppVersion = $info.Version
        $AppName = $info.Name
        
        # ------------------------Disinstallazione----------------------------------
        Write-Verbose "Inizio Disinstallazione app $AppName" 
        Uninstall-NAVApp $ServerInstance -Name $AppName -Force
        Write-Verbose "Disinstallata $AppName"
        # ------------------------Depubblicazione-----------------------------------
        Write-Verbose "Inizio depubblicazione app $AppName" 
        Unpublish-NAVApp $ServerInstance -Name $AppName
        Write-Verbose "Depubblicazione app $AppName" 
        
        # Stampa i risultati
        Write-Verbose "AppName: $AppName"
        Write-Verbose "AppVersion: $AppVersion"

        $ProgressNumber++
        Write-Progress -Activity "$serverInstance" -Status "Unistalling app: $AppName" -PercentComplete ($ProgressNumber / $dependenciesArray.Count * 100)
    }
}

function Get-InstallationLog {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ServerInstance
    )

    $appCount = (Get-NAVAppInfo -ServerInstance $serverInstance | Where-Object -Property publisher -like 'cpl*').Count
    Write-Verbose "Numero totale di app pubblicate: $appCount"
    Write-Output "[$(Get-Date)] $serverInstance $appCount $env:USERNAME"
}


Export-ModuleMember -Function Uninstall-UnpublishAllApp
Export-ModuleMember -Function Publish-AllApp
Export-ModuleMember -Function Get-InstallationLog