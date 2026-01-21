# PAQUETS ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 

library(readxl)
library(sf)
library(dplyr)
library(stringr)
library(ggplot2)


# ADQUISICIÓ DADES -------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Importació de les dades de població
dades_ine <- read_xlsx(path = "C:/30DayMapChallenge2025/Day25_Hexagons/pobmun/pobmun24.xlsx",
                       skip = 1)

## Importació geometries municipis d'Espanya
munis_esp <- st_read("C:/30DayMapChallenge2025/Day25_Hexagons/lineas_limite/SHP_ETRS89/recintos_municipales_inspire_peninbal_etrs89/recintos_municipales_inspire_peninbal_etrs89.shp")

## Importació geometries municipis d'Espanya, només el contorn 
munis_linies <- st_read("C:/30DayMapChallenge2025/Day25_Hexagons/lineas_limite/SHP_ETRS89/ll_municipales_inspire_peninbal_etrs89/ll_municipales_inspire_peninbal_etrs89.shp")


# TRANSFORMACIÓ DADES --------------------------------------------------------------------------------------------------------------------------------------------------------------

## Creació codi municipi: codi província + codi municipi
dades_ine$CODI <- paste(dades_ine$CPRO, 
                        dades_ine$CMUN,
                        sep = "")

## Creació del codi de municipi a l'objecte de límits municipals, com a subcodi del que indica l'arxiu
## per tal de coincidir amb el de l'INE
munis_esp$CODIMUN <- str_sub(string = munis_esp$NATCODE, 
                             start = -5,
                             end = -1)

## Transformació a SRC oficial
munis_esp <- st_transform(x = munis_esp, 
                          crs = 25830)
munis_linies <- st_transform(x = munis_linies,
                             crs = 25830)
prov_linies <- st_transform(x = prov_linies, 
                            crs = 25830)

## Join de les dades de població amb les geometries 
munis_esp_ine <- left_join(x = munis_esp,
                           y = dades_ine,
                           join_by(CODIMUN == CODI))

## Creació d'un objecte amb la geometria d'Espanya
pol_esp <- munis_esp %>%
st_union() %>%
st_as_sf()


## Creació de la malla hexagonal
malla150 <- munis_esp %>%
st_make_grid(n = c(150,150),
             square = FALSE,
             crs = 25830) %>%
st_as_sf()

## Selecció dels hexàgons que intersecten amb el polígon d'espanya (no els retallem segons la seva geometria)
malla_retallada <- filter(malla150,
                          lengths(st_intersects(malla150, pol_esp)) > 0)

## Unió dels atributs amb els hexàgons
malla150_atributs <- st_join(malla_retallada,
                             munis_esp_ine)


# PLOTTING ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Creació intervals de valors de població
malla150_atributs$intervals <- cut(
  malla150_atributs$POB24,
  breaks = c(0,1000,5000,20000,50000,100000,250000,500000,1000000,2000000,3000000, Inf),
  labels = c('0 - 1.000','1.000 - 5.000','5.000 - 20.0000','20.000 - 50.000','50.000 - 100.000',
             '100.000 - 250.000','250.000 - 500.000','500.000 - 1.000.000','1.000.000 - 2.000.000',
             '2.000.000 - 3.000.000', '> 3.000.000'),
  include.lowest = TRUE
)

## Visualització
ggplot() + 
  geom_sf(data = malla150_atributs, aes(fill = intervals), color = 'white', linewidth = 0.2) +
  coord_sf(crs = 25830, datum = 25830) +
  labs(
    title = "Població d'Espanya",
    subtitle = 'Font: Instituto Nacional de Estadística',
    x = 'UTM X',
    y = 'UTM Y',
    fill = 'Població'
  ) +
  theme_void() +
  scale_fill_viridis_d(option =  'A',
                       direction = -1,
                       na.value = 'lightgrey') +
  annotate(geom = 'text',
           label = '#30DayMapChallenge\nDay 25: Hexagons', hjust = 'left', size = 4,
           x = 900000, y = 3900000)
  

## Exportació de resultats
ggsave("mapa_poblacio.png", 
       width = 10, height = 8, units = "in",
       bg = 'white',
       dpi = 350)
