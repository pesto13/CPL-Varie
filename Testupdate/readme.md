# Testupdate - Ambienti di test

## Mission
Testupdate è creato per poter gestire in modo efficace gli ambienti di test.
Lo scopo è quello di poter creare un ambiente per specifico cliente.
L'ambiente viene creato di notte con la migrazione del DB sullo specifico slot e si aggancia ai servizi già creati sulla macchina windows.
Esistono 7 ambienti per quanto riguarda dinetwork, possono essere operativi 7 diversi ambienti contemporaneamente.

## INFO
```sv-dbbc-test.cpgnet.local```   Database
```sv-srv-testdnt.cpgnet.local``` Servizio
```SV-TESTUPDT-DB.CPGNET.LOCAL``` Database Dismesso (non mi fa accedere)


### Problema
Con aumento dei clienti maggiori sovrapposioni di clienti sullo stesso slot si avranno. Potrebbe essere necessario spostare un cliente in uno slot diverso.
Ora come ora i clienti sullo stesso slot si contendono le medesime porte.

## Macchine utilizzate
sv-srv-testdnt.cpgnet.local qua faccio il servizio (dove lancio scritp powershell)
SV-TESTUPDT-DB.CPGNET.LOCAL qua ho database

## Processo
La parte operativa da svolgere è la preparazione dei servizi su windows. Il database si aggancia successivamente a questi servizi e questi servizi vengono avviati ```START-NAVSERVER```

Collegati alla macchina
__sv-srv-testdnt.cpgnet.local__
Devi usare il file contenuto nella cartella ```C\Porte\porte.txt``` tienilo aggiornato (serve per controllare in fretta)

## Contenuto del progetto
- File word
- Script di creazione _Powersell_
- Script di inserimento _Python_ sul testupdate site 


