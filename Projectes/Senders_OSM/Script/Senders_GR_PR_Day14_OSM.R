# PAQUETS ---------------------------------------------------------------------------------------------------------------------------------------------

library(dplyr)
library(stringr)
library(osmextract)
library(sf)
library(ggplot2)


# ADQUISICIÓ DE DADES --------------------------------------------------------------------------------------------------------------------------------

# Importació del dataset d'OSM
osm_cat_lines <- oe_read("C:/30DayMapChallenge2025/Day14_OSM/cataluna-251111.osm.pbf", layer = 'lines')


# TRANSFORMACIÓ DE LES DADES -------------------------------------------------------------------------------------------------------------------------

# Filtre dels elements que continguin GR
# Fent un cop d'ull a les dades, existeixen bastantes diferències en l'etiquetatge de GR
# En alguns casos es troba a l'inici del camp (^GR.), d'altres més endavant (.GR.)
osm_gr1 <- subset(x = osm_cat_lines, subset = grepl(pattern = '.GR.[0-9]', x = name))
osm_gr2 <- subset(x = osm_cat_lines, subset = grepl(pattern = '^GR.[0-9]', x = name))
# S'ajunta tot el que s'ha trobat i s'eliminen possibles duplicats
# Es converteix en objecte SF
osm_gr <- rbind(osm_gr1, osm_gr2) %>% distinct() %>% st_as_sf()

# Igual amb els PR-C
osm_pr1 <- subset(x = osm_cat_lines, subset = grepl(pattern = '.PR.C.[0-9]', x = name))
osm_pr2 <- subset(x = osm_cat_lines, subset = grepl(pattern = '^PR.C.[0-9]', x = name))
osm_pr <- rbind(osm_pr1, osm_pr2) %>% distinct() %>% st_as_sf()


# Visualització de les dades obtingudes
ggplot() +
  geom_sf(data = osm_gr, show.legend = FALSE) +
  geom_sf(data = osm_pr, show.legend = FALSE) +
  coord_sf()


# Creació d'una columna amb el codi de GR
# Existeixen diferents variacions en com s'han codificat els GR
# Per exemple: GR-1 / GR 1 / GR1
## Pattern: 
### GR
### [- ]? un guió, un espai en blanc o res
### [0-9]++ un número del 0 al 9 i fins a dues posicions més si hi ha números
### (?: )? en cas que existís codi del tipus GR-5.2
#### \\. [0-9]++ literalment punt seguit d'una a tres xifres
### [A-Z]? una lletra de l'A a la Z o res
osm_gr$GR <- str_extract(string = osm_gr$name, 
                         pattern = 'GR[- ]?[0-9]++(?:\\.[0-9]++)?[A-Z]?') %>%
  str_replace_all(pattern = 'GR[- ]?([0-9]++(?:\\.[0-9]++)?[A-Z]?)',
                  replacement = 'GR-\\1')

# El mateix pels PR
osm_pr$PR <- str_extract(string = osm_pr$name, 
                         pattern = 'PR[- ]?C[- ]?[0-9]++(?:\\.[0-9]++)?[A-Z]?') %>%
  str_replace_all(pattern = 'PR[- ]?C[- ]?([0-9]++(?:\\.[0-9]++)?[A-Z]?)',
                  replacement = 'PR-C-\\1')

osm_pr_1 <- subset(x = osm_cat_lines, subset = grepl(pattern = '.Pr.C.[0-9]', x = name))
osm_pr_2 <- subset(x = osm_cat_lines, subset = grepl(pattern = '^Pr.C.[0-9]', x = name))
osm_pr_3 <- rbind(osm_pr_1, osm_pr_2) %>% distinct() %>% st_as_sf()
osm_pr_3$PR <- str_extract(string = osm_pr_3$name, 
                         pattern = 'Pr[- ]?C[- ]?[0-9]++(?:\\.[0-9]++)?[A-Z]?') %>%
  str_replace_all(pattern = 'Pr[- ]?C[- ]?([0-9]++(?:\\.[0-9]++)?[A-Z]?)',
                  replacement = 'PR-C-\\1')

osm_pr <- rbind(osm_pr, osm_pr_3)


# Visualització de les dades
ggplot() +
  geom_sf(data = osm_gr, aes(color = GR), show.legend = TRUE) +
  geom_sf(data = osm_pr, aes(color = PR), show.legend = TRUE) +
  coord_sf()


# Unió de les geometries segons el GR
osm_gr_unit <- osm_gr %>% 
  select(GR, geometry) %>%
  group_by(GR) %>% 
  summarise(geometry = st_union(geometry)) %>%
  mutate(geometry = st_cast(x = geometry, to = 'MULTILINESTRING')) %>%
  mutate(geometry = st_line_merge(geometry))

# El mateix amb els PR
osm_pr_unit <- osm_pr %>% 
  select(PR, geometry) %>%
  group_by(PR) %>% 
  summarise(geometry = st_union(geometry)) %>%
  mutate(geometry = st_cast(x = geometry, to = 'MULTILINESTRING')) %>%
  mutate(geometry = st_line_merge(geometry))


# Canvi SRC
osm_gr_unit <- st_transform(x = osm_gr_unit, crs = 25831)
osm_pr_unit <- st_transform(x = osm_pr_unit, crs = 25831)


# VISUALITZACIÓ --------------------------------------------------------------------------------------------------------------------------------
ggplot() +
  geom_sf(data = osm_gr_unit, aes(color = GR), show.legend = FALSE) +
  geom_sf(data = osm_pr_unit, aes(color = PR), show.legend = FALSE) +
  coord_sf(datum = 25831) + 
  geom_sf_label(data = osm_gr_unit, aes(label = GR)) + 
  geom_sf_label(data = osm_pr_unit, aes(label = PR))


# Exportació
st_write(osm_gr_unit, "C:/30DayMapChallenge2025/Day14_OSM/osm_gr.gpkg", layer = 'linies_GR', append = FALSE)
st_write(osm_pr_unit, "C:/30DayMapChallenge2025/Day14_OSM/osm_pr.gpkg", layer = 'linies_PR', append = FALSE)

