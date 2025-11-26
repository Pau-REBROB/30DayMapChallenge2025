library(readxl)
library(sf)
library(dplyr)
library(stringr)
library(ggplot2)

# Importació de les dades de població
dades_ine <- read_xlsx(path = "C:/30DayMapChallenge2025/Day25_Hexagons/pobmun/pobmun24.xlsx", skip = 1)
# Creació codi municipi (província+municipi)
dades_ine$CODI <- paste(dades_ine$CPRO, dades_ine$CMUN, sep = "")

# Importació geometries municipis Espanya
munis_esp <- st_read("C:/30DayMapChallenge2025/Day25_Hexagons/lineas_limite/SHP_ETRS89/recintos_municipales_inspire_peninbal_etrs89/recintos_municipales_inspire_peninbal_etrs89.shp")
munis_esp <- st_transform(x = munis_esp, crs = 25830)
# Creació del codi de municipi
munis_esp$CODIMUN <- str_sub(string = munis_esp$NATCODE, start = -5, end = -1)

munis_linies <- st_read("C:/30DayMapChallenge2025/Day25_Hexagons/lineas_limite/SHP_ETRS89/ll_municipales_inspire_peninbal_etrs89/ll_municipales_inspire_peninbal_etrs89.shp")
munis_linies <- st_transform(x = munis_linies, crs = 25830)

# Join de les dades amb les geometries
munis_esp_ine <- left_join(x = munis_esp, y = dades_ine, join_by(CODIMUN==CODI))

# Dissolució en una geometria d'Espanya
pol_esp <- st_union(munis_esp)


# Importació de les províncies
prov_linies <- st_read("C:/30DayMapChallenge2025/Day25_Hexagons/lineas_limite/SHP_ETRS89/ll_provinciales_inspire_peninbal_etrs89/ll_provinciales_inspire_peninbal_etrs89.shp")
prov_linies <- st_transform(x = prov_linies, crs = 25830)



# ARA AMB HEXÀGONS MÉS PETITS
# Creació de la malla
malla150 <- st_make_grid(munis_esp,
                         n = c(150,150),
                         square = FALSE,
                         crs = 25830)
malla150 <- st_as_sf(malla150)

# Selecció dels hexàgons que intersecten amb el polígon d'espanya
malla_retallada <- filter(malla150, lengths(st_intersects(malla150, pol_esp)) > 0)

# Unió dels atributs
malla150_atributs <- st_join(malla_retallada, munis_esp_ine)


# Creació intervals de valors
malla150_atributs$intervals <- cut(
  malla150_atributs$POB24,
  breaks = c(0,1000,5000,20000,50000,100000,250000,500000,1000000,2000000,3000000, Inf),
  labels = c('0 - 1.000','1.000 - 5.000','5.000 - 20.0000','20.000 - 50.000','50.000 - 100.000',
             '100.000 - 250.000','250.000 - 500.000','500.000 - 1.000.000','1.000.000 - 2.000.000',
             '2.000.000 - 3.000.000', '> 3.000.000'),
  include.lowest = TRUE
)

# Visualització
ggplot() + 
  geom_sf(data = malla150_atributs, aes(fill = intervals), color = 'white', linewidth = 0.2) +
  # geom_sf(data = prov_linies, linewidth = 0.05, alpha = 0.3) +
  coord_sf(crs = 25830, datum = 25830) +
  labs(
    title = "Població d'Espanya",
    subtitle = 'Font: Instituto Nacional de Estadística',
    x = 'UTM X',
    y = 'UTM Y',
    fill = 'Població'
  ) +
  theme_void() +
  # theme(
  #   axis.title.x = element_text(size = 12, colour = 'darkgrey'),
  #   axis.title.y = element_text(size = 12, colour = 'darkgrey')
  # ) +
  scale_fill_viridis_d(option =  'A',
                       direction = -1,
                       na.value = 'lightgrey') +
  annotate(geom = 'text',
           label = '#30DayMapChallenge\nDay 25: Hexagons', hjust = 'left', size = 4,
           x = 900000, y = 3900000)
  

# Exportar resultats
ggsave("mapa_poblacio.png", 
       width = 10, height = 8, units = "in",
       bg = 'white',
       dpi = 350)