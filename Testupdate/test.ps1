$PORTEMD = 'porte.md'
$DEFULT_SLOT_PORT = 'defaultSlotPort.json'


function Get-NextDNT{
    #TODO attenzione che con 10 slot non funziona piu
    param(
        [Parameter(Mandatory=$true)]
        [String]$latestDNT
    )

    $dntNumber = [int][string]$latestDNT[-1]
    return "DNT" + ((([int]$dntNumber) % 7) + 1)
}

function Get-AutomaticNextSlot {
    # leggo da file porte e leggo ultimo DNT
    $latestDNT = (Get-Content $PORTEMD | Select-Object -Last 1) -split "`t" | Select-Object -first 1
    return Get-NextDNT($latestDNT)
}

function Get-AutomaticNextFirstPort {
    param (
        [Parameter(Mandatory=$true)]
        [string]$SlotX
    )
    $jsonData = Get-Content -Path $DEFULT_SLOT_PORT -Raw | ConvertFrom-Json -AsHashtable
    return $jsonData[$SlotX]
}

$nextSlot = Get-AutomaticNextSlot
$nextport = Get-AutomaticNextFirstPort($nextSlot)

# 
Read-Host "Il prossimo slot da utilizzare sarebbe $nextSlot con porte $nextport.
-Batti invio per confermare
-Oppure inseririsci il valore dello slot nel quale inserire il servizio"
# 