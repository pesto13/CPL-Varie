


function Get-TopologicalSort {
    param (
        edges
    )

    # stack = []
    # tutti visited a false
    # parti da un nodo con 0 entranti, funzione che cerca? statico?

    # fai partire dfs su quel vertice 0


    # se leggi al contrario li hai tutti
    
}


function DFS {
    param (
        node,
        visited,
        i,
        stack
    )

    visited[i] = $true;


    # per ogni nodo uscente
        # se non e` visitato
            # DFS()

    # dependecies.append(questo nodo)


}


function Get-ZeroIncomingNode {
    param (
        graph
    )
    
    # per ognuno
        # se count = 0 return
}


# 

# funzione che gli dai array di file / app e ti genera il grafo delle dipendenze

function Get-DependenciesGraph {
    param (
        OptionalParameters
    )
    

    # per ogni file
    # aggiungi dipendeze di quel app nel grafo (append)
}


Export-ModuleMember -Function Get-TopologicalSort
Export-ModuleMember -Function Get-DependenciesGraph