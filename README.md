## Shiny app riguardante il pendolarismo in Italia

Il [file ISTAT](https://www.istat.it/it/archivio/139381) contiene i dati, desunti dal 15° Censimento generale della popolazione 2011, su 28.553.667 persone (stimate) residenti in famiglia, che hanno dichiarato di recarsi giornalmente al luogo abituale di studio o di lavoro in Italia, partendo dall’alloggio di residenza, e di rientrarvi. 

Oltre che per il motivo dello spostamento, lavoro o studio, la tabella contiene le ulteriori seguenti classificazioni: 
 - sesso: maschio o femmina
 - mezzo di trasporto utilizzato: treno; tram; metropolitana; autobus urbano, filobus; corriera, autobus extra-urbano; autobus aziendale o scolastico; auto privata (conducente); auto privata (passeggero); motocicletta, ciclomotore, scooter; bicicletta; altro mezzo; a piedi.
 - fascia oraria mattutina di partenza dal luogo di residenza: prima delle 7:15; dalle 7:15 alle 8:14; dalle 8:15 alle 9:14; dopo le 9:14.
 - durata del tragitto: fino a 15 minuti; da 16 a 30 minuti; da 31 a 60 minuti; oltre 60 minuti.


Il file è composto da 4.876.242 record suddivisi come `S` e `L` (campo 1). Il codice tiene in considerazione i soli 3.887.617 record siglati come `L`, essendo questa la tipologia contenente il maggior dettaglio di cui sopra. Vengono inoltre scartati anche i record relativi a territori esteri (campo 7), per un totale finale di 3,875,072 record.

Il file è fornito in formato *larghezza fissa*, ma essendo ogni campo separato da spazi, e non comparendo spazi in nessun campo, il file puo' essere letto tranquillamente come normale file di testo separato da spazi.

Un'ulteriore trasformazione viene infine applicata per aggiornare il codice comune al corrente anno 2021, nel file il riferimento e' all'anno di censimento 2011 (vedi file [comuni_11-21.csv](https://github.com/lvalnegri/shiny-pendolarismo_italia/blob/main/comuni_11-21.csv)).
