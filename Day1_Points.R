#DAY 1 - POINTS

## Importació CSV amb els pisos turístics com a punts
pisos_punts <- read.csv("C:/30DayMapChallenge2025/Day1_Points/hut_comunicacio_opendata.csv", encoding="UTF-8", dec=",")
## Comprovació que tots els punts tenen associats una coordenada
sum(is.na.data.frame(pisos_punts$LONGITUD_X)) #0
sum(is.na.data.frame(pisos_punts$LATITUD_Y))  #0

## Observació de les dades per eliminar informació irrellevant
View(pisos_punts)
pisos_punts <- pisos_punts[
  c('N_EXPEDIENT','CODI_DISTRICTE','NOM_DISTRICTE','CODI_BARRI','NOM_BARRI','TIPUS_CARRER','CARRER',
    'NUM1','LLETRA1','NUM2','LLETRA2','NUMERO_REGISTRE_GENERALITAT','NUMERO_PLACES','LONGITUD_X','LATITUD_Y')
  ]

## Transformació de dataframe a objecte SF
library(sf)
sf_pisos <- st_as_sf(x = pisos_punts, coords = c('LONGITUD_X','LATITUD_Y'), remove = FALSE, crs = 4326)
st_crs(sf_pisos) <- 4326

sf_pisos
### Resultat: Simple feature collection with 10692 features and 15 fields / Geometry type: POINT / Dimension: XY
### Bounding box:  xmin: 2.09328 ymin: 41.35259 xmax: 2.219091 ymax: 41.45278 / Geodetic CRS:  WGS 84

## Transformació del SRC de EPSG:4326 al sistema oficial EPSG:25831
sf_pisos_25831 <- st_transform(x = sf_pisos, crs = 25831)
## Addició de les coordenades en columnes separades
sf_pisos_25831 <- cbind(sf_pisos_25831, st_coordinates(sf_pisos_25831))

## Visualització de les dades
library(ggplot2)
ggplot(data = sf_pisos_25831) + geom_sf() + coord_sf(datum = 25831, xlim = c(424239,434738), ylim = c(4578249,4589339))
### Bounding box:  xmin: 424240 ymin: 4578250 xmax: 434737.3 ymax: 4589338


## Importació de l'arxiu de les divisions administratives de Barcelona
### Importació de barris
barris <- st_read("C:/30DayMapChallenge2025/Day1_Points/BCN_UNITATS_ADM/0301040100_Barris_UNITATS_ADM.shp")
plot(barris$geometry)
### Importació de districtes
districtes <- st_read("C:/30DayMapChallenge2025/Day1_Points/BCN_UNITATS_ADM/0301040100_Districtes_UNITATS_ADM.shp")
plot(districtes$geometry)

## Visualització de totes les dades conjuntament
ggplot() + 
  geom_sf(data = districtes) + 
  geom_sf(data = barris) + 
  geom_point(data = sf_pisos_25831, mapping = aes(x = X, y = Y, colour = NOM_DISTRICTE), size = 0.1) + 
  coord_sf(datum = 25831)


## OPERACIONS ESPACIALS
## Número de pisos (punts) que hi ha a cada districte
## Número de places que hi ha a cada habitatge d'aquests pisos per districte
library(dplyr)
estadist <- sf_pisos_25831 %>% group_by(NOM_DISTRICTE) %>% 
  summarise('Nombre habitatges' = n(), 'Número de places' = sum(NUMERO_PLACES, na.rm = TRUE)) %>%
  st_drop_geometry()
estadist


## Exportació de les dades
## Exportació de la capa de punts com a SHP
st_write(sf_pisos_25831, "C:/30DayMapChallenge2025/Day1_Points/sf_pisos_25831.shp")

## Exportació de les estadístiques com a CSV
write.csv(estadist, "C:/30DayMapChallenge2025/Day1_Points/estadistiques.csv")