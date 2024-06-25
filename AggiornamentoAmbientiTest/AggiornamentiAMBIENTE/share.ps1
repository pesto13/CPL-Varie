param(
    [string]$Filename
)


$credential = Get-Credential
$pcProduzione = $pcProduzione = Get-Content -Path 'allProdPc.json' -Raw | ConvertFrom-Json
$fileDestination = "C:\apps\DiNetwork"

foreach ($pc in $pcProduzione){
    $Session = New-PSSession -ComputerName $($pc.ComputerName) -Credential $credential
    Copy-Item $Filename -Destination $fileDestination -ToSession $Session -Recurse -Force
    # Invoke-Command -Session $Session -FilePath 'C:\apps\DiNetwork' -AsJob
}

# Wait-Job -State "Running" | Out-Null
# Get-Job | Receive-Job