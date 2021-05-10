dmpkg.funs::load_pkgs(c('data.table', 'leaflet', 'polylabelr', 'sf'))
itpath <- file.path(ext_path, 'it', 'istat', 'confini')

message('\nScarico i confini comunali...')
tmp <- tempfile()
download.file('https://www.istat.it/storage/cartografia/confini_amministrativi/non_generalizzati/Limiti01012021.zip', destfile = tmp)
unzip(tmp, exdir = itpath, junkpaths = TRUE)
yb <- st_read(file.path(itpath, list.files(itpath, pattern = '^C.*shp$'))) %>% dplyr::select(CMN = PRO_COM) %>% dplyr::arrange(CMN)
yb <- st_transform(yb, 4326)
unlink(tmp)

message('\nCalcolo i centri "poi"...')
yp <- rbindlist(sapply(1:nrow(yb), function(x) poi(yb[x,]) ))
y <- data.table( yb %>% st_drop_geometry(), yp[, .(x_poi = x, y_poi = y)] )
system(paste0( 'iconv -f Latin1 -t utf-8 dati/comuni_utf.csv > dati/comuni.csv'))
yc <- fread('./dati/comuni.csv')
ycn <- copy(names(yc))
yc[, c('x_poi', 'y_poi') := NULL]
y <- y[yc, on = 'CMN']
setcolorder(y, ycn)
    
message('\nSalvo in formato fst e csv...')
write_fst(y, file.path(app_path, 'it_pendolarismo', 'comuni'))
fwrite(y, './dati/comuni.csv')

yb <- yb %>% dplyr::inner_join(y)
leaflet() %>% 
    addTiles() %>% 
    addPolygons(
        data = yb, 
        color = 'orange', stroke = TRUE, weight = 3, fillOpacity = 0.1,
        label = ~CMNd, highlightOptions = highlightOptions(stroke = TRUE, color = 'white', weight = 8)
    ) %>% 
    addCircleMarkers(
        data = y, lng = ~x_lon, lat = ~y_lat, 
        radius = 4, weight = 2, color = 'black', fillColor = 'red',
        label = ~CMNd
    ) %>% 
    addCircleMarkers(
        data = y, lng = ~x_poi, lat = ~y_poi, 
        radius = 4, weight = 2, color = 'black', fillColor = 'blue',
        label = ~CMNd
    )
    

rm(y, yc)
gc()
