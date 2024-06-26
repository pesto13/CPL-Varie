param(
    [Parameter(Mandatory = $true)]
    [string]$serverInstance,
    [Parameter(Mandatory = $true)]
    [Int64]$scelta
)


Write-Host 'eccoci'
return "$serverinstance $scelta ciaobello $(Get-Date)"