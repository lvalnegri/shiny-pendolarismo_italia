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
y <- y[V1 == 'L' & V7 != 3][, `:=`( CMN1 = V3*1000 +V4, CMN2 = V8*1000 +V9)][, paste0('V', c(1:4, 7:10, 15)) := NULL]

yc <- fread('d:/OneDrive/VPS/master-i.ml/public/ext_data/geografia/CMN/comuni_11-21.csv')
y <- yc[, .(CMN2 = CMN11, CMNL = CMN)][y, on = 'CMN2'][, CMN2 := NULL]
y <- yc[, .(CMN1 = CMN11, CMNR = CMN)][y, on = 'CMN1'][, CMN1 := NULL]
cols <- c('V11', 'V12', 'V13')
y <- y[, .(numero = sum(as.integer(V14))), c('CMNR', 'CMNL', 'V5', 'V6', cols)]
y[, (cols) := lapply(.SD, as.integer), .SDcols = cols]
setnames(y, c('V5', 'V6', cols), c('sesso', 'motivo', 'mezzo', 'orario', 'tempo'))
setorderv(y, c('CMNR', 'CMNL'))
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

rm(y, yc)
gc()
