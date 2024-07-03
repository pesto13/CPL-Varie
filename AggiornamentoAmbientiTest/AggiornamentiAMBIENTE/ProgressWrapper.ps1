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

    $jobs = @()
    foreach ($s in $settings) {
        $jobs += Start-Job -ScriptBlock {
            param($serverInstance, $scelta, $scriptPath)
            Set-Location $scriptPath
            .\myFE.ps1 -serverInstance $serverInstance -scelta $scelta -ErrorAction SilentlyContinue
        } -ArgumentList $($s.ServerInstance), $($s.scelta), $PSScriptRoot
    }

    while ($jobs.State -contains "Running") {
        Start-Sleep -Milliseconds 500
        foreach ($j in $jobs) {
            if ($j.State -eq "Running" -and $j.HasMoreData) {
                $data = Receive-Job $j
                if ($null -ne $data) {
                    $i = $data.ToString()
                    Write-Output $i
                }
            }
        }
    }

    # Ricevere l'output finale di ciascun job e aggiungerlo all'array $allOutput
    foreach ($j in $jobs) {
        $finalOutput = Receive-Job -Job $j
        if ($null -ne $finalOutput) {
            $allOutput += $finalOutput.ToString();
        }
    }

    # Scrivere l'output nel file di log
    $allOutput | Format-Table -AutoSize | Out-File 'log.log' -Append
    Remove-Job -Job $jobs
}

main