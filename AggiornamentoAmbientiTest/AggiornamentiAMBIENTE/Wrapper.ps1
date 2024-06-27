function Get-LatestPackage {
    # Definizione del percorso base
    $basePath = "$env:UserProfile\Desktop"

    # Trova tutte le cartelle che corrispondono al pattern "Pacchetto_*"
    $sourceFolders = Get-ChildItem -Path $basePath -Directory | Where-Object { $_.Name -match '^Pacchetto_\d{6}_\d{6}$' }

    # Se non troviamo nessuna cartella, restituiamo un messaggio di errore
    if ($sourceFolders.Count -le 0) {
        Write-Output "Nessuna cartella corrispondente trovata nel percorso $basePath"
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
    Write-Output "Copia completata da $sourcePath a $destinationPath"
}

function main {
    # Carica il contenuto del file JSON
    $settingsFile = "settings.json"
    $settings = Get-Content $settingsFile -raw | ConvertFrom-Json
    
    $sourcePath = Get-LatestPackage

    if ($null -eq $sourcePath) {
        Write-Error 'Nessuna cartella corrispondente trovata'
        return
    }

    # Esegui la copia degli artefatti
    Copy-Artifacts -sourcePath $sourcePath.FullName
    

    # Esegui lo script per ogni configurazione trovata nel file JSON
    $jobs = @()
    foreach ($s in $settings) {
        $arguments = "-NoProfile -ExecutionPolicy Bypass -File .\myFE.ps1 -serverInstance $($s.ServerInstance) -scelta $($s.scelta)"
        #  -packageName $($sourcePath.Name) al massimo posso fare qualcosa qua
        # Esecuzione dello script in una nuova istanza di PowerShell con privilegi di amministratore
        $jobs += Invoke-Command -ScriptBlock { & powershell.exe $using:arguments} -AsJob
    }

    Wait-Job -Job $jobs | Out-Null
    $jobs | Format-Table -AutoSize | Out-File 'log.log' -Append

}

main