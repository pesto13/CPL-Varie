param(
    [Parameter(Mandatory = $true)]
    [string]$serverInstance,
    [Parameter(Mandatory = $true)]
    [Int64]$scelta
)

Import-Module .\Installation.psm1 -Force       
Import-Module "C:\Program Files\Microsoft Dynamics 365 Business Central\210\Service\NavAdminTool.ps1" | Out-Null

$dependenciesPath = ".\list.txt"
$dependenciesArray = @()

if (Test-Path $dependenciesPath -PathType Leaf) {
    $dependenciesArray = Get-Content $dependenciesPath
    Write-Verbose "File letto correttamente. Righe lette: $($dependenciesArray.Count)"
}

# attività
Uninstall-UnpublishAllApp -ServerInstance $serverInstance -dependenciesArray $dependenciesArray 
[array]::reverse($dependenciesArray)
Publish-AllApp -ServerInstance $serverInstance -dependenciesArray $dependenciesArray

# log
Write-Output (Get-InstallationLog -ServerInstance casirate)

