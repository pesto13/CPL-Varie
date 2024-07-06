# Carica i moduli
Import-Module .\TopologicalSort.psm1 -Force
Import-Module "C:\Program Files\Microsoft Dynamics 365 Business Central\210\Service\NavAdminTool.ps1"

# Crea il grafo delle dipendenze
$grafo = Get-DependenciesGraph -ArtifactPath .\Runtime\
$grafo | ConvertTo-Json | Out-File -FilePath '.\dependencies.json'

# Trova nodi senza dipendenze in ingresso
$startingNode = Get-ZeroIncomingNode -Graph $grafo
$TransposeGraph = Get-TransposeGraph -Graph $grafo
$TransposeGraph | ConvertTo-Json | Out-File -FilePath '.\traspose.json'
# Esegui l'ordinamento topologico
$list = (Get-TopologicalSort -Edges $TransposeGraph -StartingKeyNode $startingNode)
$list | Out-File -FilePath '.\list.txt'