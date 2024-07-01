param(
    [Parameter(Mandatory)]
    [string]$Filename,
    [Parameter(Mandatory)]
    [string]$fileDestination,
    [Parameter(Mandatory)]
    [string]$JSONConfig
)

$credential = Get-Credential
$pcProduzione = Get-Content -Path $JSONConfig -Raw | ConvertFrom-Json
# $fileDestination = "C:\apps\DiNetwork"

foreach ($pc in $pcProduzione){
    $Session = New-PSSession -ComputerName $($pc.ComputerName) -Credential $credential
    Copy-Item $Filename -Destination $fileDestination -ToSession $Session -Recurse -Force
    Remove-PSSession $Session
}