param(
    [switch]$CopyFromDesktop
)

function Get-LatestPackage {
    # Definizione del percorso base
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

    # Definizione del percorso di destinazione, bisogna lanciarla da dentro la cartella
    $destinationPath = "."
    # Cancella le cartelle "Apps" e "Runtime" nella directory di destinazione, se esistono
    $appDir = Join-Path -Path $destinationPath -ChildPath "Apps"
    $runtimeDir = Join-Path -Path $destinationPath -ChildPath "Runtime"

    if (Test-Path -Path $appDir) {
        Remove-Item -Path $appDir -Recurse -Force
    }
    if (Test-Path -Path $runtimeDir) {
        Remove-Item -Path $runtimeDir -Recurse -Force
    }

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
    # Carica il contenuto del file JSON
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
    

    # Esegui lo script per ogni configurazione trovata nel file JSON
    $jobs = @()
    foreach ($s in $settings) {
        #  -packageName $($sourcePath.Name) al massimo posso fare qualcosa qua
        # Esecuzione dello script in una nuova istanza di PowerShell con privilegi di amministratore
        $jobs += Start-Job -ScriptBlock { 
            param($serverInstance, $scelta)
            return .\myFE.ps1 -serverInstance $serverInstance -scelta $scelta
        } -ArgumentList $($s.ServerInstance), $($s.scelta) 
    }

    # Wait-Job -Job $jobs | Out-Null

    while ($jobs.State -contains 'Running') {
        Clear-Host
        foreach ($job in $jobs) {
            if ($job.State -eq 'Running') {
                # Ricevi l'output solo se il job è completato
                if ($job.State -eq 'Completed') {
                    $jobOutput = Receive-Job -Job $job
                    Write-Output $jobOutput
                }
            }
        }
        Start-Sleep -Seconds 5
    }

    $jobs | Format-Table -AutoSize | Out-File 'log.log' -Append
    Remove-Job -Job -$jobs

}

main