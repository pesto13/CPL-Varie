param(
    [switch]$Verbose
)

# QUSTO e` stato usato in produzione l'ultima volta

$credential = Get-Credential
$pcProduzione = $pcProduzione = Get-Content -Path 'allProdPc.json' -Raw | ConvertFrom-Json
$jobs = @()

foreach ($pc in $pcProduzione) {
    $jobs += Invoke-Command -Credential $credential -ComputerName $($pc.ComputerName) -ScriptBlock {
        param ($ClientName)
        Set-Location "C:\apps\DiNetwork"
        if($Verbose){
            .\myFE.ps1 -serverInstance $ClientName -scelta 2 -Verbose
        }else{
            .\myFE.ps1 -serverInstance $ClientName -scelta 2
        }
    } -ArgumentList $($pc.ClientName) -AsJob
}

Wait-Job -Job $jobs | Out-Null
$jobs | Receive-Job | Format-Table -AutoSize | Out-File 'log.log'
Remove-Job -Job -$jobs