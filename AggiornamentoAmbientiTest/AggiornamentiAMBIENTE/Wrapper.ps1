# Definizione dell'array di hash tables
$settings = @(
    @{
        'ServerInstance' = 'nome'
        'scelta'         = 1
    }
    @{
        'ServerInstance' = 'nome'
        'scelta'         = 2
    }
)

foreach ($s in $settings) {

    # Definizione del percorso base
    $basePath = "C:\Users\bellodifrancesco\Desktop"

    # Trova tutte le cartelle che corrispondono al pattern "Pacchetto_*"
    $sourceFolders = Get-ChildItem -Path $basePath -Directory | Where-Object { $_.Name -match '^Pacchetto_\d{6}_\d{6}$' }

    # Se troviamo più di una cartella, seleziona quella con la data più recente
    if ($sourceFolders.Count -gt 0) {
        
        $latestFolder = $sourceFolders | Sort-Object { $_.Name -replace 'Pacchetto_', '' } | Select-Object -Last 1
        $sourcePath = $latestFolder.FullName

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
                Move-Item -Path $dir.FullName -Destination $destDir
            }
        }

        Write-Output "Spostamento completato da $sourcePath a $destinationPath"
    }
    else {
        Write-Output "Nessuna cartella corrispondente trovata nel percorso $basePath"
    }


    $arguments = "-NoProfile -ExecutionPolicy Bypass -File .\myFE.ps1 -serverInstance $($s['ServerInstance']) -scelta $($s['scelta'])"

    # Esecuzione dello script in una nuova istanza di PowerShell con privilegi di amministratore
    Start-Process powershell -ArgumentList $arguments -Verb RunAs
}
