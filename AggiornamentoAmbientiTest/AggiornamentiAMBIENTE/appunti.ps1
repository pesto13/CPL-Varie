param(
    [string]$Filename
)


$credential = Get-Credential
$pcProduzione = $pcProduzione = Get-Content -Path 'allProdPc.json' -Raw | ConvertFrom-Json
# $fileDestination = "C:\apps\DiNetwork"

    
$jobs = @()

foreach ($pc in $pcProduzione) {

    $jobs += Invoke-Command -Credential $credential -ComputerName $($pc.ComputerName) -ScriptBlock {
        param ($ClientName)
        Set-Location "C:\apps\DiNetwork"
        .\myFE.ps1 -serverInstance $ClientName -scelta 2 -packageName Get-Date 
        # return $ClientName
    } -ArgumentList $($pc.ClientName) -AsJob

}

Wait-Job -Job $jobs | Out-Null
$jobs | Receive-Job