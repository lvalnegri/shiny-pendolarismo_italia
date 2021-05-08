library(data.table)
library(fst)

message('\nScarico il file zippato dati sezioni...')
tmp <- tempfile()
download.file('http://www.istat.it/storage/cartografia/matrici_pendolarismo/matrici_pendolarismo_2011.zip', destfile = tmp)

message('Estraggo il file dati...')
fname <- unzip(tmp, list = TRUE)
fname <- fname[order(fname$Length, decreasing = TRUE), 'Name'][1]
unzip(tmp, files = fname, exdir = file.path(ext_path, 'istat'), junkpaths = TRUE)
unlink(tmp)

message('\nLeggo il file...')
y <- fread(file.path(ext_path, 'istat', basename(fname)), sep = ' ')

message('\nArrangio il dataset...')
y <- y[V1 == 'L' & V7 != 3
    ][, `:=`( CMNR = V3*1000 +V4, CMNL = V8*1000 +V9)
      ][, c('V1', 'V2', 'V3', 'V4', 'V7', 'V8', 'V9', 'V10', 'V15') := NULL]
cols <- names(y)
y <- y[, lapply(.SD, as.integer), .SDcols = cols]
setnames(y, c('sesso', 'motivo', 'mezzo', 'orario', 'tempo', 'numero', 'CMNR', 'CMNL'))
setcolorder(y, c('CMNR', 'CMNL'))
y[, `:=`(
        sesso  = factor(sesso,  labels = c('Maschio', 'Femmina')),
        motivo = factor(motivo, labels = c('Studio', 'Lavoro')),
        mezzo  = factor(mezzo,  labels = c(
                    'treno', 'tram', 'metropolitana', 'autobus urbano, filobus', 'corriera, autobus extra-urbano',
                    'autobus aziendale o scolastico','auto privata (come conducente)', 'auto privata (come passeggero)', 
                    'motocicletta,ciclomotore,scooter', 'bicicletta', 'altro mezzo', 'a piedi'
        )),
        orario = factor(orario, labels = c('prima delle 7,15', 'dalle 7,15 alle 8,14', 'dalle 8,15 alle 9,14', 'dopo le 9,14')),
        tempo  = factor(tempo,  labels = c('fino a 15 minuti', 'da 16 a 30 minuti', 'da 31 a 60 minuti', 'oltre 60 minuti'))
)]

message('\nSalvo in formato fst...')
write_fst(y, file.path(app_path, 'pendolari_italia', 'dataset'))

rm(y)
gc()
