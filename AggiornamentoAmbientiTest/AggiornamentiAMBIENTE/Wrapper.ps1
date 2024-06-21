
param (
    [switch]$skipMove
)


function Get-LatestPackage {
    # Definizione del percorso base
    $basePath = "$env:UserProfile\Desktop"

    # Trova tutte le cartelle che corrispondono al pattern "Pacchetto_*"
    $sourceFolders = Get-ChildItem -Path $basePath -Directory | Where-Object { $_.Name -match '^Pacchetto_\d{6}_\d{6}$' }

    # Se troviamo più di una cartella, seleziona quella con la data più recente
    if ($sourceFolders.Count -le 0) {
        Write-Output "Nessuna cartella corrispondente trovata nel percorso $basePath"
        return $null
    }

    $latestFolder = $sourceFolders | Sort-Object { $_.Name -replace 'Pacchetto_', '' } | Select-Object -Last 1
    return $latestFolder
}


function Copy-Artifacts {
    param(
        [string]$sourcePath
    )

    # Definizione del percorso di destinazione
    $destinationPath = "C:\apps\DiNetwork"

    # Cancella le cartelle "App" e "Runtime" nella directory di destinazione, se esistono
    $appDir = Join-Path -Path $destinationPath -ChildPath "App"
    $runtimeDir = Join-Path -Path $destinationPath -ChildPath "Runtime"

    if (Test-Path -Path $appDir) {
        Remove-Item -Path $appDir -Recurse -Force
    }
    if (Test-Path -Path $runtimeDir) {
        Remove-Item -Path $runtimeDir -Recurse -Force
    }

    # Sposta tutte le cartelle dalla directory di origine alla directory di destinazione
    foreach ($dir in Get-ChildItem -Path $sourcePath -Directory) {
        $destDir = Join-Path -Path $destinationPath -ChildPath $dir.Name
        if (-Not (Test-Path -Path $destDir)) {
            Copy-Item -Path $dir.FullName -Destination $destDir
        }
    }

    Write-Output "Spostamento completato da $sourcePath a $destinationPath"
    return $true
}

function main {
    # param (
    #     [switch]$skipMove
    # )
    # Carica il contenuto del file JSON
    $settingsFile = "settings.json"
    $settings = Get-Content $settingsFile -raw | ConvertFrom-Json
    
    $sourcePath = Get-LatestPackage

    if ($null -eq $sourcePath) {
        Write-Error 'Nessuna cartella corrispondente trovata'
        return
    }

    # -not($skipMove) -and 
    if (-not(Copy-Artifacts -sourcePath $sourcePath.FullName)) {
        Write-Error 'Errore nello spostamento delle cartelle'
    }

    foreach ($s in $settings) {
        $arguments = "-NoProfile -ExecutionPolicy Bypass -File .\myFE.ps1 -serverInstance $($s.ServerInstance) -scelta $($s.scelta) -packageName $($sourcePath.Name)"
        # Esecuzione dello script in una nuova istanza di PowerShell con privilegi di amministratore
        Start-Process powershell -ArgumentList $arguments -Verb RunAs
    }
}


main