## Shiny app riguardante il pendolarismo in Italia

Il file contiene i dati sul numero di persone che si spostano tra comuni, o all'interno dello stesso comune, classificate, oltre che per il motivo dello spostamento: lavoro o studio, anche per: 
 - sesso
 - mezzo di trasporto utilizzato
 - fascia oraria mattutina di partenza dal luogo di residenza
 - durata del tragitto

Il file è composto da 4.876.242 record suddivisi come `S` e `L`. Il codice tiene in considerazione i soli 3.887.617 record siglati come `L`, essendo questa la tipologia contenente il maggior dettaglio di cui sopra. Vengono inoltre scartati i record relativi a territori esteri.  

Il file è salvato in formato *larghezza fissa*, ma essendo ogni campo separato da spazi, e non comparendo spazi in nessun campo, il file puo' essere letto tranquillamente come normale file di testo separato da spazi.

Un ulteriore trasformazione viene applicata per aggiornare il codice comune all'anno 2021, nel file il riferimento e' all'anno di censimento 2011.
