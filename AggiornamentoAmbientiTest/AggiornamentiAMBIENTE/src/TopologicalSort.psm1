function Get-TopologicalSort {
    param (
        [hashtable]$Edges,
        [string]$StartingKeyNode
    )

    $stack = New-Object System.Collections.Generic.List[System.Object]
    $visited = @{}
    foreach ($k in $Edges.Keys) { 
        $visited[$k] = $false 
    }    

    DFS -Edges $Edges -Key $StartingKeyNode -Visited $visited -Stack ([ref]$stack)

    $stack.Reverse()
    return $stack
}

function DFS {
    param (
        [hashtable]$Edges,
        [string]$Key,
        [hashtable]$Visited,
        [ref]$Stack
    )

    $Visited[$Key] = $true

    foreach ($outgoingKeyEdge in $Edges[$Key]['Dependencies']) {
        if (-not $Visited[$outgoingKeyEdge]) { 
            DFS -Edges $Edges -Key $outgoingKeyEdge -Visited $Visited -Stack ($Stack)
        }
    }

    $Stack.Value.Add( $Edges[$Key]['AppPath'])
}

function Get-ZeroIncomingNode {
    param (
        [hashtable]$Graph
    )

    foreach ($key in $Graph.Keys) {
        if ($Graph[$key].Dependencies.Count -eq 0) {
            return $key
        }
    }
    return $null
}

# function Get-ZeroOutGoingNode {
#     param(
#         [hashtable]$Graph
#     )

#     $Nodes = New-Object System.Collections.Generic.HashSet[String]
#     $NodesWithOutGoingEdge = New-Object System.Collections.Generic.HashSet[String]

#     foreach ($key in $Graph.Keys) {
#         $Nodes.Add($key)
#     }

#     foreach ($key in $Graph.Keys) {
#         foreach ($dep in $Graph[$key]['Dependencies']) {
#             $NodesWithOutGoingEdge.Add($dep.ToString())
#         }
#     }

#     $Nodes.ExceptWith($NodesWithOutGoingEdge)
#     return [array]$Nodes
# }

function Get-DependenciesGraph {
    param (
        [string]$ArtifactPath
    )

    $dependenciesDict = @{}

    Get-ChildItem $ArtifactPath -Exclude 'dependencies.txt' | ForEach-Object {
        $appInfo = Get-NAVAppInfo -Path $_.FullName
        $appId = $appInfo.AppId.ToString()
        $appPath = $_.FullName
        $dependencies = Get-AppDependenciesList -AppInfo $appInfo

        $dependenciesDict[$appId] = @{
            AppPath      = $appPath
            Dependencies = $dependencies
        }
    }

    return $dependenciesDict
}

function Get-AppDependenciesList {
    param (
        [PSObject]$AppInfo
    )
    
    $appList = @()
    $AppInfo.Dependencies | Where-Object { $_.Name -ne 'Application' } | 
    ForEach-Object { $appList += $_.AppId }
    
    return $appList
}

function Get-TransposeGraph {
    param (
        [hashtable]$Graph
    )
    
    $TransposeGraph = @{}
    foreach( $key in $Graph.Keys ){
        $TransposeGraph[$key] = @{
            AppPath      = $Graph[$key]['AppPath']
            Dependencies = @()
        }
    }

    foreach( $key in $Graph.Keys ){
        foreach( $d in $Graph[$key]['Dependencies']){
           $TransposeGraph[$d.ToString()]['Dependencies'] += $key
        }
    }
    return $TransposeGraph 
}

Export-ModuleMember -Function Get-ZeroIncomingNode
# Export-ModuleMember -Function Get-ZeroOutGoingNode
Export-ModuleMember -Function Get-DependenciesGraph
Export-ModuleMember -Function Get-TopologicalSort
Export-ModuleMember -Function Get-AppDependenciesList
Export-ModuleMember -Function Get-TransposeGraph

