param(
    [switch]$CopyFromDesktop,
    [switch]$Verbose
)

# questo vorrebbe essere evoluzione di Wrapper
# lo sto usando per fare i test per quanto riguarda i log

function Get-LatestPackage {

    $basePath = "$env:UserProfile\Desktop"

    # Trova tutte le cartelle che corrispondono al pattern "Pacchetto_*"
    $sourceFolders = Get-ChildItem -Path $basePath -Directory | Where-Object { $_.Name -match '^Pacchetto_\d{6}_\d{6}$' }

    # Se non troviamo nessuna cartella, restituiamo un messaggio di errore
    if ($sourceFolders.Count -le 0) {
        Write-Error "Nessuna cartella corrispondente trovata nel percorso $basePath"
        return $null
    }

    # Seleziona la cartella con la data più recente
    $latestFolder = $sourceFolders | Sort-Object { $_.Name -replace 'Pacchetto_', '' } | Select-Object -Last 1
    return $latestFolder
}

function Copy-Artifacts {
    param(
        [string]$sourcePath
    )

    $destinationPath = "."
    # Cancella le cartelle "Apps" e "Runtime" nella directory di destinazione, se esistono
    $appDir = Join-Path -Path $destinationPath -ChildPath "Apps"
    $runtimeDir = Join-Path -Path $destinationPath -ChildPath "Runtime"

    if (Test-Path -Path $appDir) { Remove-Item -Path $appDir     -Recurse -Force }
    if (Test-Path -Path $runtimeDir) { Remove-Item -Path $runtimeDir -Recurse -Force }

    # Copia tutte le cartelle dalla directory di origine alla directory di destinazione
    foreach ($dir in Get-ChildItem -Path $sourcePath -Directory) {
        $destDir = Join-Path -Path $destinationPath -ChildPath $dir.Name
        if (-Not (Test-Path -Path $destDir)) {
            Copy-Item -Path $dir.FullName -Destination $destDir -Recurse
        }
    }
    Write-Verbose "Copia completata da $sourcePath a $destinationPath"
}

function main {

    $settingsFile = "settings.json"
    $settings = Get-Content $settingsFile -raw | ConvertFrom-Json

    if ($CopyFromDesktop) {
        $sourcePath = Get-LatestPackage

        if ($null -eq $sourcePath) {
            Write-Error 'Nessuna cartella corrispondente trovata'
            return
        }

        # Esegui la copia degli artefatti
        Copy-Artifacts -sourcePath $sourcePath.FullName
    }

    # https://learn.microsoft.com/it-it/powershell/module/microsoft.powershell.core/about/about_scripts?view=powershell-5.1#other-script-features
    $jobs = @()
    foreach ($s in $settings) {
        $jobs += Start-Job -ScriptBlock {
            param($serverInstance, $scelta)
            . .\myFE.ps1 -serverInstance $serverInstance -scelta $scelta
        } -ArgumentList $($s.ServerInstance), $($s.scelta)
    }

    Wait-Job -Job $jobs
    $jobs | Format-Table -AutoSize | Out-File 'log.log' -Append
    Remove-Job -Job $jobs
}

main