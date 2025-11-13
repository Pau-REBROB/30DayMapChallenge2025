library(dplyr)
library(stringr)
library(osmextract)
library(sf)
library(ggplot2)


# Importació del dataset d'OSM
osm_cat_lines <- oe_read("C:/30DayMapChallenge2025/Day14_OSM/cataluna-251111.osm.pbf", layer = 'lines')


# Filtre dels elements que continguin GR
# Fent un cop d'ull a les dades, existeixen bastantes diferències en l'etiquetatge de GR
# En alguns casos es troba a l'inici del camp (^GR.), d'altres més endavant (.GR.)
osm_gr1 <- subset(x = osm_cat_lines, subset = grepl(pattern = '.GR.', x = name))
osm_gr2 <- subset(x = osm_cat_lines, subset = grepl(pattern = '^GR.', x = name))
# S'ajunta tot el que s'ha trobat i s'eliminen possibles duplicats
# Es converteix en objecte SF
osm_gr <- rbind(osm_gr1, osm_gr2) %>% distinct() %>% st_as_sf()


# Visualització de les dades obtingudes
ggplot() +
  geom_sf(data = osm_gr, show.legend = FALSE) +
  coord_sf()


# Creació d'una columna amb el codi de GR
# Existeixen diferents variacions en com s'han codificat els GR
# Per exemple: GR-1 / GR 1 / GR1
## Pattern: 
### GR
### [- ]? un guió, un espai en blanc o res
### [0-9]++ un número del 0 al 9 i fins a dues posicions més si hi ha números
### [A-Z]? una lletra de l'A a la Z o res
osm_gr$GR <- str_extract(string = osm_gr$name, 
                         pattern = 'GR[- ]?[0-9]++[A-Z]?') %>%
  str_replace_all(pattern = 'GR[- ]?([0-9]++[A-Z]?)',
                  replacement = 'GR-\\1')


# Visualització de les dades
ggplot() +
  geom_sf(data = osm_gr, aes(color = GR), show.legend = TRUE) +
  coord_sf()


# Unió de les geometries segons el GR
osm_gr_unit <- osm_gr %>% 
  select(GR, geometry) %>%
  group_by(GR) %>% 
  summarise(geometry = st_union(geometry)) %>%
  mutate(geometry = st_cast(x = geometry, to = 'MULTILINESTRING')) %>%
  mutate(geometry = st_line_merge(geometry))


# Canvi SRC
osm_gr_unit <- st_transform(x = osm_gr_unit, crs = 25831)


# Visualització
ggplot() +
  geom_sf(data = osm_gr_unit, aes(color = GR), show.legend = TRUE) +
  coord_sf(datum = 25831) + 
  geom_sf_label(data = osm_gr_unit, aes(label = GR))


# Exportació
st_write(osm_gr_unit, "C:/30DayMapChallenge2025/Day14_OSM/osm_gr.gpkg", layer = 'linies_GR')
