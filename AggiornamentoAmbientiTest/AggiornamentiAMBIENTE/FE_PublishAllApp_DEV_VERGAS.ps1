# FEFIX SCRIPT PER GESTIONE DELLA FE CON COMPILATI SPECIFICI PER FATTURAZIONE ELETTRONICA
import-module "C:\Program Files\Microsoft Dynamics 365 Business Central\210\Service\NavAdminTool.ps1"

$ServerInstance = "BC210_2"
$Contatore = 0
# Specifica il percorso del tuo file di testo
$filePath = ".\dependencies.txt"

$Scelta = 0 

#Scegliere se intallare i .app o . runtime
while ($scelta -ne 1 -and $scelta -ne 2) {
    Write-Host "Scegli tra le opzioni seguenti:"
    Write-Host "1)app"
    Write-Host "2)runtime"

    $scelta = Read-Host "Inserisci il numero corrispondente all'opzione scelta"
    $scelta = [int]$scelta  # Converte l'input in un numero intero
}

Write-Host "Hai scelto l'opzione $scelta. Il ciclo è terminato."


# Inizializza un array vuoto per contenere le righe del file
$dependenciesArray = @()

# Verifica se il file esiste
if (Test-Path $filePath -PathType Leaf) {
    # Leggi le righe del file e salvale nell'array
    $dependenciesArray = Get-Content $filePath
    Write-Host "File letto correttamente. Righe lette: $($dependenciesArray.Count)"
} else {
    Write-Host "Il file non esiste o il percorso è sbagliato."
}


#Inverto l'array delle dipendenze per la parte di Uninstall e Unpublish
[array]::reverse($dependenciesArray)

#Ciclo l'array inverso per la parte di Uninstall e Unpublish 
foreach ($line in $dependenciesArray) {
    Write-Host $line

   


            # Trova l'indice dell'ultimo "_" 
            # CPL Concordia, XDataNet_M921 - File Management_21.1.6.0.app
            $lastUnderscoreIndex = $line.LastIndexOf("_")
            # Trova l'indice dell penultimo "_" 
            $PenultimateUnderscoreString = $line.SubString(0,$lastUnderscoreIndex)
            $PenultimateUnderscoreIndex = $PenultimateUnderscoreString.LastIndexOf("_")

           


                # Controlla se la parola "runtime" è presente nella variabile $line
            if ($line -like "*runtime*") {       

                # Trova l'indice dell'ultimo "."
                $ultimateDotIndex = $line.LastIndexOf(".")
                # Trova l'indice dell penultimo "."
                $PenultimateDotString = $line.SubString(0,$ultimateDotIndex)
                $PenultimateDotIndex = $PenultimateDotString.LastIndexOf(".") 
                # Estrai le sottostringhe per i .runtime
                $NomeApp = $line.SubString($PenultimateUnderscoreIndex+1,$lastUnderscoreIndex-$PenultimateUnderscoreIndex-1)
                $Versione = $line.SubString($lastUnderscoreIndex+1,$PenultimateDotIndex-$lastUnderscoreIndex-1)            

                # ------------------------Disinstallazione----------------------------------
                Write-Host "Inizio Disinstallazione app $NomeApp" 
                Uninstall-NAVApp $ServerInstance -Name $NomeApp
                Write-Host "Disinstallata $NomeApp"
                # ------------------------Depubblicazione-----------------------------------
                Write-Host "Inizio depubblicazione app $NomeApp" 
                Unpublish-NAVApp $ServerInstance -Name $NomeApp
                Write-Host "Depubblicazione app $NomeApp" 
            
            } else {               
                # Trova l'indice dell'ultimo "."
                # CPL Concordia, XDataNet_M921 - File Management_21.1.6.0.app
                $ultimateDotIndex = $line.LastIndexOf(".")
                # Estrai le sottostringhe per i .app
                $NomeApp = $line.SubString($PenultimateUnderscoreIndex+1,$lastUnderscoreIndex-$PenultimateUnderscoreIndex-1)
                $Versione = $line.SubString($lastUnderscoreIndex+1,$ultimateDotIndex-$lastUnderscoreIndex-1)


                # ------------------------Disinstallazione----------------------------------
                Write-Host "Inizio Disinstallazione app $NomeApp" 
                Uninstall-NAVApp $ServerInstance -Name $NomeApp -Force
                Write-Host "Disinstallata $NomeApp"
                # ------------------------Depubblicazione-----------------------------------
                Write-Host "Inizio depubblicazione app $NomeApp" 
                Unpublish-NAVApp $ServerInstance -Name $NomeApp
                Write-Host "Depubblicazione app $NomeApp" 

            }    


        # Stampa i risultati
        Write-Host "NomeApp: $NomeApp"
        Write-Host "Versione: $Versione"

        
}

#Inverto l'array delle dipendenze per la parte di Publish ,Synch, Install, Upgrade
[array]::reverse($dependenciesArray)

#Ciclo l'array inverso per la parte di e Publish ,Synch, Install, Upgrade
foreach ($line in $dependenciesArray) {
    
            $Contatore +=1

            if ($scelta -eq 1) {
            # Rimuovi ".runtime" e ".app" dalla stringa
            $line = $line -replace "\.runtime", ""
            }


             if ($scelta -eq 2) {
            # Rimuovi ".runtime" e ".app" dalla stringa
            $line = $line -replace "\.runtime", "" -replace "\.app", ""
            $line = $line+".runtime.app"
            }


            # Trova l'indice dell'ultimo "_" 
            $lastUnderscoreIndex = $line.LastIndexOf("_")
            # Trova l'indice dell penultimo "_" 
            $PenultimateUnderscoreString = $line.SubString(0,$lastUnderscoreIndex)
            $PenultimateUnderscoreIndex = $PenultimateUnderscoreString.LastIndexOf("_")

     # Controlla se la parola "runtime" è presente nella variabile $line
            if ($line -like "*runtime*") {
                
                # Trova l'indice dell'ultimo "."
                $ultimateDotIndex = $line.LastIndexOf(".")
                # Trova l'indice dell penultimo "."
                $PenultimateDotString = $line.SubString(0,$ultimateDotIndex)
                $PenultimateDotIndex = $PenultimateDotString.LastIndexOf(".") 
                # Estrai le sottostringhe per i .runtime
                $NomeApp = $line.SubString($PenultimateUnderscoreIndex+1,$lastUnderscoreIndex-$PenultimateUnderscoreIndex-1)
                $Versione = $line.SubString($lastUnderscoreIndex+1,$PenultimateDotIndex-$lastUnderscoreIndex-1)       
                $APPPath = '.\'+$line     


                # ------------------------Pubblicazione-----------------------------------
                Write-Host "Inizio Pubblicazione app $NomeApp" 
                Publish-NAVApp -ServerInstance $ServerInstance -Path $APPPath -SkipVerification
                Write-Host "Pubblicazione app $NomeApp" 

                # ------------------------Sync-----------------------------------
                Write-Host "Inizio Sync app $NomeApp" 
                Sync-NAVApp -ServerInstance $ServerInstance -Name $NomeApp -Version $Versione -Mode ForceSync -Force
                Write-Host "Fine Sync app $NomeApp"

                # ------------------------Install-----------------------------------
                Write-Host "Inizio Installazione app $NomeApp" 
                Install-NAVApp -ServerInstance $ServerInstance -Name $NomeApp -Version $Versione -Force 
                Write-Host "Fine Installazione app $NomeApp"


                # ------------------------Upgrade-----------------------------------
                Write-Host "Inizio Upgrade app $NomeApp" 
                Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name $NomeApp -Version $Versione -Force
                Write-Host "Fine Upgrade app $NomeApp"


                Write-host "app N."$Contatore
            
            } else {               
                  
                
                # Trova l'indice dell'ultimo "."
                $ultimateDotIndex = $line.LastIndexOf(".")
                # Estrai le sottostringhe per i .app
                $NomeApp = $line.SubString($PenultimateUnderscoreIndex+1,$lastUnderscoreIndex-$PenultimateUnderscoreIndex-1)
                $Versione = $line.SubString($lastUnderscoreIndex+1,$ultimateDotIndex-$lastUnderscoreIndex-1)
                $APPPath = '.\'+$line


                # ------------------------Pubblicazione-----------------------------------
                Write-Host "Inizio Pubblicazione app $NomeApp" 
                Publish-NAVApp -ServerInstance $ServerInstance -Path $APPPath -SkipVerification
                Write-Host "Pubblicazione app $NomeApp" 

                # ------------------------Sync-----------------------------------
                Write-Host "Inizio Sync app $NomeApp" 
                Sync-NAVApp -ServerInstance $ServerInstance -Name $NomeApp -Version $Versione -Mode ForceSync -Force
                Write-Host "Fine Sync app $NomeApp"

                # ------------------------Install-----------------------------------
                Write-Host "Inizio Installazione app $NomeApp" 
                Install-NAVApp -ServerInstance $ServerInstance -Name $NomeApp -Version $Versione -Force 
                Write-Host "Fine Installazione app $NomeApp"


                # ------------------------Upgrade-----------------------------------
                Write-Host "Inizio Upgrade app $NomeApp" 
                Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name $NomeApp -Version $Versione -Force
                Write-Host "Fine Upgrade app $NomeApp"

                Write-host "app N."$Contatore

            }   
}

Get-NAVAppInfo -ServerInstance $ServerInstance | Where-Object -Property publisher -like 'cpl*'
Get-NAVAppInfo -ServerInstance $ServerInstance | Where-Object -Property publisher -like 'cpl*' | measure




# $Version = "21.1.231010.0"
# $VersionMubi = "21.1.6.0"




#  Write-Host "Inizio Disinstallazione app" 
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D911 - ENTRY EXTENSION - XPQR'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D016 - GESTIONE RUOLO UTENTE'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D011 - TESORERIA - XMLPORT PAGE QUERY REPORT'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D010 - TESORERIA'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D050 - ACQUIRENTE UNICO - XMLPORT PAGE QUERY REPORT'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D015 - STAMPE CLIENTI  - XMLPORT PAGE QUERY REPORT'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D019 - DNT ADMINISTRATION TOOLS XMLPORT PAGE QUERY REPORT'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D014 - ASSICURAZIONE CLIENTI FINALI'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D017 - PERSONALIZZAZIONE GEI'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D055 - ESTRAZIONI UTENZE - XMLPORT PAGE QUERY REPORT'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D053 - ESTRAZIONI PDR - XMLPORT PAGE QUERY REPORT'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D056 - ESTRAZIONI GDM - XMLPORT PAGE QUERY REPORT'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D039 - PEREQUAZIONE - XMLPORT PAGE QUERY REPORT'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D059 - ESTRAZIONI VARIE - XMLPORT PAGE QUERY REPORT' 
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D057 - ESTRAZIONI LETTURE - XMLPORT PAGE QUERY REPORT'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D043 - UFFICIO METRICO - SICUREZZA E CONTINUITA - XPQR'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D041 - QUALITA COMMERCIALE - SICUREZZA E CONTINUITA - XPQR'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D038 - PEREQUAZIONE'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D048 - MOROSITA - XMLPORT PAGE QUERY REPORT'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D047 - MOROSITA'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D035 - INDENNIZZI - XMLPORT PAGE QUERY REPORT'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D049 - ACQUIRENTE UNICO'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D034 - INDENNIZZI'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D033 - DELIBERA 40  - XMLPORT PAGE QUERY REPORT'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D032 - DELIBERA 40'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D021 - CRUSCOTTO FE - XMLPORT PAGE QUERY REPORT'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D013 - CONTABILITA AGGIUNTIVA - XMLPORT PAGE QUERY REPORT'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D012 - CONTABILITA AGGIUNTIVA'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D029 - SPESE E SERVIZI  - XMLPORT PAGE QUERY REPORT'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D028 - SPESE E SERVIZI'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D046 - WKR - XMLPORT PAGE QUERY REPORT'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D037 - SETTLEMENT  - XMLPORT PAGE QUERY REPORT'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D036 - SETTLEMENT'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D031 - VETTORIAMENTO  - XMLPORT PAGE QUERY REPORT'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D030 - VETTORIAMENTO'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D052 - VOLTURE - XMLPORT PAGE QUERY REPORT'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D045 - SWITCH - XMLPORT PAGE QUERY REPORT'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D058 - BONUS - XMLPORT PAGE QUERY REPORT'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D009 - REGISTR. FOGLI LAVORO IN COGE-XMLPORT PAGE QUERY REPORT'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D008 - REGISTRAZIONE FOGLI LAVORO IN COGE'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D081 - SCAMBIO DATI - XPQR'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D062 - ANAGRAFICA LETTURE - XPQR'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D044 - SCAMBIO DATI'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D003 - BONUS'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D004 - GESTIONE GIRI LETTURISTA'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D051 - GESTIONE ANAGRAFICHE DI BASE - XMLPORT PAGE QUERY REPORT'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D001 - ANAGRAFICHE DI BASE'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D912 - ESTENSIONI ANAGRAFICHE STD - XPQR'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D020 - CRUSCOTTO FE'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D909 - ENTRY EXTENSION'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D910 - ESTENSIONI ANAGRAFICHE STD'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D905 - DIGAS LIBRARY - XMLPORT PAGE QUERY REPORT'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D904 - COMMON LIBRARY - XMLPORT PAGE QUERY REPORT'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D903 - REPORT LIBRARY'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D902 - Digas Library'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'D901 - Common Library'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'M915 - Accounting Tools'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'M914 - Accounting Interfaces'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'M913 - Accounting Core'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'M920 - Mubi Job Queue'
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'M912 - Mubi Library' 
#  Uninstall-NAVApp -ServerInstance $ServerInstance -Name 'M921 - File Management'


#  Write-Host "Inizio Depubblicazione app" 
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D911 - ENTRY EXTENSION - XPQR'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D016 - GESTIONE RUOLO UTENTE'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D011 - TESORERIA - XMLPORT PAGE QUERY REPORT'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D010 - TESORERIA'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D050 - ACQUIRENTE UNICO - XMLPORT PAGE QUERY REPORT'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D015 - STAMPE CLIENTI  - XMLPORT PAGE QUERY REPORT'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D019 - DNT ADMINISTRATION TOOLS XMLPORT PAGE QUERY REPORT'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D014 - ASSICURAZIONE CLIENTI FINALI'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D017 - PERSONALIZZAZIONE GEI'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D055 - ESTRAZIONI UTENZE - XMLPORT PAGE QUERY REPORT'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D053 - ESTRAZIONI PDR - XMLPORT PAGE QUERY REPORT'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D056 - ESTRAZIONI GDM - XMLPORT PAGE QUERY REPORT'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D039 - PEREQUAZIONE - XMLPORT PAGE QUERY REPORT'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D059 - ESTRAZIONI VARIE - XMLPORT PAGE QUERY REPORT' 
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D057 - ESTRAZIONI LETTURE - XMLPORT PAGE QUERY REPORT'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D043 - UFFICIO METRICO - SICUREZZA E CONTINUITA - XPQR'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D041 - QUALITA COMMERCIALE - SICUREZZA E CONTINUITA - XPQR'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D038 - PEREQUAZIONE'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D048 - MOROSITA - XMLPORT PAGE QUERY REPORT'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D047 - MOROSITA'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D035 - INDENNIZZI - XMLPORT PAGE QUERY REPORT'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D049 - ACQUIRENTE UNICO'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D034 - INDENNIZZI'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D033 - DELIBERA 40  - XMLPORT PAGE QUERY REPORT'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D032 - DELIBERA 40'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D021 - CRUSCOTTO FE - XMLPORT PAGE QUERY REPORT'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D013 - CONTABILITA AGGIUNTIVA - XMLPORT PAGE QUERY REPORT'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D012 - CONTABILITA AGGIUNTIVA'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D029 - SPESE E SERVIZI  - XMLPORT PAGE QUERY REPORT'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D028 - SPESE E SERVIZI'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D046 - WKR - XMLPORT PAGE QUERY REPORT'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D037 - SETTLEMENT  - XMLPORT PAGE QUERY REPORT'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D036 - SETTLEMENT'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D031 - VETTORIAMENTO  - XMLPORT PAGE QUERY REPORT'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D030 - VETTORIAMENTO'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D052 - VOLTURE - XMLPORT PAGE QUERY REPORT'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D045 - SWITCH - XMLPORT PAGE QUERY REPORT'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D058 - BONUS - XMLPORT PAGE QUERY REPORT'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D009 - REGISTR. FOGLI LAVORO IN COGE-XMLPORT PAGE QUERY REPORT'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D008 - REGISTRAZIONE FOGLI LAVORO IN COGE'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D081 - SCAMBIO DATI - XPQR'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D062 - ANAGRAFICA LETTURE - XPQR'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D044 - SCAMBIO DATI'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D003 - BONUS'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D004 - GESTIONE GIRI LETTURISTA'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D051 - GESTIONE ANAGRAFICHE DI BASE - XMLPORT PAGE QUERY REPORT'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D001 - ANAGRAFICHE DI BASE'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D912 - ESTENSIONI ANAGRAFICHE STD - XPQR'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D020 - CRUSCOTTO FE'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D909 - ENTRY EXTENSION'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D910 - ESTENSIONI ANAGRAFICHE STD'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D905 - DIGAS LIBRARY - XMLPORT PAGE QUERY REPORT'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D904 - COMMON LIBRARY - XMLPORT PAGE QUERY REPORT'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D903 - REPORT LIBRARY'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D902 - Digas Library'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'D901 - Common Library'
#  Unpublish-NAVApp -ServerInstance $ServerInstance -Name 'M915 - Accounting Tools'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'M914 - Accounting Interfaces'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'M913 - Accounting Core'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'M920 - Mubi Job Queue'
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'M912 - Mubi Library' 
#  Unpublish-navapp -ServerInstance $ServerInstance -Name 'M921 - File Management'





#  Write-Host "Inizio Pubblicazione app" 
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, XDataNet_M921 - File Management_21.1.6.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, XDataNet_M912 - Mubi Library_21.1.6.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, XDataNet_M920 - Mubi Job Queue_21.1.6.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, XDataNet_M913 - Accounting Core_21.1.6.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, XDataNet_M914 - Accounting Interfaces_21.1.6.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, XDataNet_M915 - Accounting Tools_21.1.6.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D901 - Common Library_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D902 - Digas Library_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D903 - REPORT LIBRARY_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D904 - COMMON LIBRARY - XMLPORT PAGE QUERY REPORT_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D905 - DIGAS LIBRARY - XMLPORT PAGE QUERY REPORT_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D910 - ESTENSIONI ANAGRAFICHE STD_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D909 - ENTRY EXTENSION_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D020 - CRUSCOTTO FE_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D912 - ESTENSIONI ANAGRAFICHE STD - XPQR_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D911 - ENTRY EXTENSION - XPQR_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D001 - ANAGRAFICHE DI BASE_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D051 - GESTIONE ANAGRAFICHE DI BASE - XMLPORT PAGE QUERY REPORT_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D004 - GESTIONE GIRI LETTURISTA_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D003 - BONUS_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D044 - SCAMBIO DATI_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D062 - ANAGRAFICA LETTURE - XPQR_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D081 - SCAMBIO DATI - XPQR_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D008 - REGISTRAZIONE FOGLI LAVORO IN COGE_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D009 - REGISTR. FOGLI LAVORO IN COGE-XMLPORT PAGE QUERY REPORT_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D058 - BONUS - XMLPORT PAGE QUERY REPORT_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D045 - SWITCH - XMLPORT PAGE QUERY REPORT_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D052 - VOLTURE - XMLPORT PAGE QUERY REPORT_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D030 - VETTORIAMENTO_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D031 - VETTORIAMENTO  - XMLPORT PAGE QUERY REPORT_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D036 - SETTLEMENT_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D037 - SETTLEMENT  - XMLPORT PAGE QUERY REPORT_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D046 - WKR - XMLPORT PAGE QUERY REPORT_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D028 - SPESE E SERVIZI_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D029 - SPESE E SERVIZI  - XMLPORT PAGE QUERY REPORT_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D012 - CONTABILITA AGGIUNTIVA_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D013 - CONTABILITA AGGIUNTIVA - XMLPORT PAGE QUERY REPORT_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D021 - CRUSCOTTO FE - XMLPORT PAGE QUERY REPORT_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D032 - DELIBERA 40_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D033 - DELIBERA 40  - XMLPORT PAGE QUERY REPORT_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D034 - INDENNIZZI_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D049 - ACQUIRENTE UNICO_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D035 - INDENNIZZI - XMLPORT PAGE QUERY REPORT_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D047 - MOROSITA_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D048 - MOROSITA - XMLPORT PAGE QUERY REPORT_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D038 - PEREQUAZIONE_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D041 - QUALITA COMMERCIALE - SICUREZZA E CONTINUITA - XPQR_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D043 - UFFICIO METRICO - SICUREZZA E CONTINUITA - XPQR_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D057 - ESTRAZIONI LETTURE - XMLPORT PAGE QUERY REPORT_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D059 - ESTRAZIONI VARIE - XMLPORT PAGE QUERY REPORT_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D039 - PEREQUAZIONE - XMLPORT PAGE QUERY REPORT_21.1.231010.0.app' -SkipVerification 
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D056 - ESTRAZIONI GDM - XMLPORT PAGE QUERY REPORT_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D053 - ESTRAZIONI PDR - XMLPORT PAGE QUERY REPORT_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D055 - ESTRAZIONI UTENZE - XMLPORT PAGE QUERY REPORT_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D017 - PERSONALIZZAZIONE GEI_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D014 - ASSICURAZIONE CLIENTI FINALI_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D015 - STAMPE CLIENTI  - XMLPORT PAGE QUERY REPORT_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D019 - DNT ADMINISTRATION TOOLS XMLPORT PAGE QUERY REPORT_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D050 - ACQUIRENTE UNICO - XMLPORT PAGE QUERY REPORT_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D010 - TESORERIA_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D011 - TESORERIA - XMLPORT PAGE QUERY REPORT_21.1.231010.0.app' -SkipVerification
# Publish-NAVApp -ServerInstance $ServerInstance -Path '.\CPL Concordia, iDigital3, XDataNet_D016 - GESTIONE RUOLO UTENTE_21.1.231010.0.app' -SkipVerification



#  Write-Host "Inizio Sync app" 
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D911 - ENTRY EXTENSION - XPQR' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'M921 - File Management' -Version $VersionMubi -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'M912 - Mubi Library' -Version $VersionMubi -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'M920 - Mubi Job Queue' -Version $VersionMubi -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'M913 - Accounting Core' -Version $VersionMubi -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'M914 - Accounting Interfaces' -Version $VersionMubi -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'M915 - Accounting Tools' -Version $VersionMubi -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D901 - Common Library' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D902 - Digas Library' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D903 - REPORT LIBRARY' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D904 - COMMON LIBRARY - XMLPORT PAGE QUERY REPORT' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D905 - DIGAS LIBRARY - XMLPORT PAGE QUERY REPORT' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D910 - ESTENSIONI ANAGRAFICHE STD' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D909 - ENTRY EXTENSION' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D020 - CRUSCOTTO FE' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D912 - ESTENSIONI ANAGRAFICHE STD - XPQR' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D001 - ANAGRAFICHE DI BASE' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D051 - GESTIONE ANAGRAFICHE DI BASE - XMLPORT PAGE QUERY REPORT' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D004 - GESTIONE GIRI LETTURISTA' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D003 - BONUS' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D044 - SCAMBIO DATI' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D062 - ANAGRAFICA LETTURE - XPQR' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D081 - SCAMBIO DATI - XPQR' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D008 - REGISTRAZIONE FOGLI LAVORO IN COGE' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D009 - REGISTR. FOGLI LAVORO IN COGE-XMLPORT PAGE QUERY REPORT' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D058 - BONUS - XMLPORT PAGE QUERY REPORT' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D045 - SWITCH - XMLPORT PAGE QUERY REPORT' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D052 - VOLTURE - XMLPORT PAGE QUERY REPORT' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D030 - VETTORIAMENTO' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D031 - VETTORIAMENTO  - XMLPORT PAGE QUERY REPORT' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D036 - SETTLEMENT' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D037 - SETTLEMENT  - XMLPORT PAGE QUERY REPORT' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D046 - WKR - XMLPORT PAGE QUERY REPORT' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D028 - SPESE E SERVIZI' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D029 - SPESE E SERVIZI  - XMLPORT PAGE QUERY REPORT' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D012 - CONTABILITA AGGIUNTIVA' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D013 - CONTABILITA AGGIUNTIVA - XMLPORT PAGE QUERY REPORT' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D021 - CRUSCOTTO FE - XMLPORT PAGE QUERY REPORT' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D032 - DELIBERA 40' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D033 - DELIBERA 40  - XMLPORT PAGE QUERY REPORT' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D034 - INDENNIZZI' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D049 - ACQUIRENTE UNICO' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D035 - INDENNIZZI - XMLPORT PAGE QUERY REPORT' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D047 - MOROSITA' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D048 - MOROSITA - XMLPORT PAGE QUERY REPORT' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D038 - PEREQUAZIONE' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D041 - QUALITA COMMERCIALE - SICUREZZA E CONTINUITA - XPQR' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D043 - UFFICIO METRICO - SICUREZZA E CONTINUITA - XPQR' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D057 - ESTRAZIONI LETTURE - XMLPORT PAGE QUERY REPORT' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D059 - ESTRAZIONI VARIE - XMLPORT PAGE QUERY REPORT' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D039 - PEREQUAZIONE - XMLPORT PAGE QUERY REPORT' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D056 - ESTRAZIONI GDM - XMLPORT PAGE QUERY REPORT' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D053 - ESTRAZIONI PDR - XMLPORT PAGE QUERY REPORT' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D055 - ESTRAZIONI UTENZE - XMLPORT PAGE QUERY REPORT' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D017 - PERSONALIZZAZIONE GEI' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D014 - ASSICURAZIONE CLIENTI FINALI' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D019 - DNT ADMINISTRATION TOOLS XMLPORT PAGE QUERY REPORT' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D015 - STAMPE CLIENTI  - XMLPORT PAGE QUERY REPORT' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D050 - ACQUIRENTE UNICO - XMLPORT PAGE QUERY REPORT' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D010 - TESORERIA' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D011 - TESORERIA - XMLPORT PAGE QUERY REPORT' -Version $Version -Mode ForceSync -Force
# Sync-NAVApp -ServerInstance $ServerInstance -Name 'D016 - GESTIONE RUOLO UTENTE' -Version $Version -Mode ForceSync -Force






#  Write-Host "Inizio Installazione app" 
# Install-NAVApp -ServerInstance $ServerInstance -Name 'M921 - File Management' -Version $VersionMubi -Force 
# Install-NAVApp -ServerInstance $ServerInstance -Name 'M912 - Mubi Library' -Version $VersionMubi -Force 
# Install-NAVApp -ServerInstance $ServerInstance -Name 'M920 - Mubi Job Queue' -Version $VersionMubi -Force 
# Install-NAVApp -ServerInstance $ServerInstance -Name 'M913 - Accounting Core' -Version $VersionMubi -Force 
# Install-NAVApp -ServerInstance $ServerInstance -Name 'M914 - Accounting Interfaces' -Version $VersionMubi -Force 
# Install-NAVApp -ServerInstance $ServerInstance -Name 'M915 - Accounting Tools' -Version $VersionMubi -Force 
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D901 - Common Library' -Version $Version -Force 
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D902 - Digas Library' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D903 - REPORT LIBRARY' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D904 - COMMON LIBRARY - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D905 - DIGAS LIBRARY - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D910 - ESTENSIONI ANAGRAFICHE STD' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D909 - ENTRY EXTENSION' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D020 - CRUSCOTTO FE' -Version $Version -Force 
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D912 - ESTENSIONI ANAGRAFICHE STD - XPQR' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D911 - ENTRY EXTENSION - XPQR' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D001 - ANAGRAFICHE DI BASE' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D051 - GESTIONE ANAGRAFICHE DI BASE - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D004 - GESTIONE GIRI LETTURISTA' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D003 - BONUS' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D044 - SCAMBIO DATI' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D062 - ANAGRAFICA LETTURE - XPQR' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D081 - SCAMBIO DATI - XPQR' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D008 - REGISTRAZIONE FOGLI LAVORO IN COGE' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D009 - REGISTR. FOGLI LAVORO IN COGE-XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D058 - BONUS - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D045 - SWITCH - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D052 - VOLTURE - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D030 - VETTORIAMENTO' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D031 - VETTORIAMENTO  - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D036 - SETTLEMENT' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D037 - SETTLEMENT  - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D046 - WKR - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D028 - SPESE E SERVIZI' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D029 - SPESE E SERVIZI  - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D012 - CONTABILITA AGGIUNTIVA' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D013 - CONTABILITA AGGIUNTIVA - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D021 - CRUSCOTTO FE - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D032 - DELIBERA 40' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D033 - DELIBERA 40  - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D034 - INDENNIZZI' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D049 - ACQUIRENTE UNICO' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D035 - INDENNIZZI - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D047 - MOROSITA' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D048 - MOROSITA - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D038 - PEREQUAZIONE' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D041 - QUALITA COMMERCIALE - SICUREZZA E CONTINUITA - XPQR' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D043 - UFFICIO METRICO - SICUREZZA E CONTINUITA - XPQR' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D057 - ESTRAZIONI LETTURE - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D059 - ESTRAZIONI VARIE - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D039 - PEREQUAZIONE - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D056 - ESTRAZIONI GDM - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D053 - ESTRAZIONI PDR - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D055 - ESTRAZIONI UTENZE - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D017 - PERSONALIZZAZIONE GEI' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D014 - ASSICURAZIONE CLIENTI FINALI' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D019 - DNT ADMINISTRATION TOOLS XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D015 - STAMPE CLIENTI  - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D050 - ACQUIRENTE UNICO - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D010 - TESORERIA' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D011 - TESORERIA - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Install-NAVApp -ServerInstance $ServerInstance -Name 'D016 - GESTIONE RUOLO UTENTE' -Version $Version -Force



#  Write-Host "Inizio DataUpgrade app" 
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D911 - ENTRY EXTENSION - XPQR' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'M921 - File Management' -Version $VersionMubi -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'M912 - Mubi Library' -Version $VersionMubi -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'M920 - Mubi Job Queue' -Version $VersionMubi -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'M913 - Accounting Core' -Version $VersionMubi -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'M914 - Accounting Interfaces' -Version $VersionMubi -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'M915 - Accounting Tools' -Version $VersionMubi -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D901 - Common Library' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D902 - Digas Library' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D903 - REPORT LIBRARY' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D904 - COMMON LIBRARY - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D905 - DIGAS LIBRARY - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D910 - ESTENSIONI ANAGRAFICHE STD' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D909 - ENTRY EXTENSION' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D020 - CRUSCOTTO FE' -Version $Version -Force  
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D912 - ESTENSIONI ANAGRAFICHE STD - XPQR' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D001 - ANAGRAFICHE DI BASE' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D051 - GESTIONE ANAGRAFICHE DI BASE - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D004 - GESTIONE GIRI LETTURISTA' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D003 - BONUS' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D044 - SCAMBIO DATI' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D062 - ANAGRAFICA LETTURE - XPQR' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D081 - SCAMBIO DATI - XPQR' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D008 - REGISTRAZIONE FOGLI LAVORO IN COGE' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D009 - REGISTR. FOGLI LAVORO IN COGE-XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D058 - BONUS - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D045 - SWITCH - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D052 - VOLTURE - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D030 - VETTORIAMENTO' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D031 - VETTORIAMENTO  - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D036 - SETTLEMENT' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D037 - SETTLEMENT  - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D046 - WKR - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D028 - SPESE E SERVIZI' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D029 - SPESE E SERVIZI  - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D012 - CONTABILITA AGGIUNTIVA' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D013 - CONTABILITA AGGIUNTIVA - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D021 - CRUSCOTTO FE - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D032 - DELIBERA 40' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D033 - DELIBERA 40  - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D034 - INDENNIZZI' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D049 - ACQUIRENTE UNICO' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D035 - INDENNIZZI - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D047 - MOROSITA' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D048 - MOROSITA - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D038 - PEREQUAZIONE' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D041 - QUALITA COMMERCIALE - SICUREZZA E CONTINUITA - XPQR' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D043 - UFFICIO METRICO - SICUREZZA E CONTINUITA - XPQR' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D057 - ESTRAZIONI LETTURE - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D059 - ESTRAZIONI VARIE - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D039 - PEREQUAZIONE - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D056 - ESTRAZIONI GDM - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D053 - ESTRAZIONI PDR - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D055 - ESTRAZIONI UTENZE - XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D017 - PERSONALIZZAZIONE GEI' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D014 - ASSICURAZIONE CLIENTI FINALI' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D019 - DNT ADMINISTRATION TOOLS XMLPORT PAGE QUERY REPORT' -Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D015 - STAMPE CLIENTI  - XMLPORT PAGE QUERY REPORT' -Version $Version -Force   
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D050 - ACQUIRENTE UNICO - XMLPORT PAGE QUERY REPORT'-Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D010 - TESORERIA'-Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D011 - TESORERIA - XMLPORT PAGE QUERY REPORT'-Version $Version -Force
# Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Name 'D016 - GESTIONE RUOLO UTENTE' -Version $Version -Force





# Get-NAVAppInfo -ServerInstance $ServerInstance | Where-Object -Property publisher -like 'cpl*'
# Get-NAVAppInfo -ServerInstance $ServerInstance | Where-Object -Property publisher -like 'cpl*' | measure