


foreach($s in $pc){
    Invoke-Command -ComputerName $client -ScriptBlock { .\myFE.ps1 -serverInstance '' -scelta 2 -packageName Get-Date }
}