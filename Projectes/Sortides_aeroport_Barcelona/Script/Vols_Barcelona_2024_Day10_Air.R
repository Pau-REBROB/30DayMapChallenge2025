# Paquets --------------------------------------------------------------------------------------------------------------------------------------------
library(sf)
library(dplyr)
library(eurostat)
library(ggplot2)


# OBTENCIÓ DADES ------------------------------------------------------------------------------------------------------------------------------------
## Dades aeroports UE
aeroports <- read_sf("C:/30DayMapChallenge2025/Day10_Air/Airports-2013-SHP/SHAPE/AIRP_PT_2013.shp")
aeroports <- st_transform(x = aeroports, crs = 4326)
st_crs(x = aeroports) <- 4326

## Dades vols entre UE i Spain
dades_vols <- get_eurostat(search_eurostat("Air passenger transport routes between partner airports and main airports in Spain",
                                           type = "dataset")$code[1])


# TRANSFORMACIÓ DADES --------------------------------------------------------------------------------------------------------------------------------
# Creació del DF amb les sortides de Barcelona, amb nombre de vols i passatgers
## Dades sortides des de Barcelona l'any 2024 dades anuals
sortides_bcn_2024 <- dades_vols %>% 
subset(subset = grepl(pattern = 'ES_LEBL_', x = airp_pr)) %>% # Filtre aeroport de Barcelona
subset(subset = grepl(pattern = '2024', x = TIME_PERIOD)) %>% # Filtre any 2024
subset(subset = grepl(pattern = '_DEP', x = tra_meas)) %>% # Filtre arribades
subset(subset = freq == 'A') # Filtre anual %>%
as.data.frame()

## Dataset amb registres de nombre de vols, de passatgers i de seients (atribut value)
## Transformació del dataset, amb els registres sent els aeroports d'on arriben els vols i amb una columna pel nombre de vols i una pel de passatgers
### Creació de dos df separats (nombre vols / nombre passatgers) per després unir-se en un sol
df_vols_2024 <- df_sortides_bcn_2024[df_sortides_bcn_2024$unit == 'FLIGHT', ]
colnames(df_vols_2024)[6] <- 'Num_vols'

df_passatgers_2024 <- df_sortides_bcn_2024[df_sortides_bcn_2024$unit == 'PAS', ]
colnames(df_passatgers_2024)[6] <- 'Num_passatgers'
df_passatgers_2024 <- subset(x = df_passatgers_2024,
                             subset = grepl(pattern = 'BRD', x = tra_meas))

df_vols_passatgers <- left_join(df_vols_2024,
                                df_passatgers_2024,
                                by = join_by(airp_pr))

### Neteja del df generat
df_vols_passatgers_2024 <- df_vols_passatgers[,c('airp_pr',
                                                'unit.x','tra_meas.x','Num_vols',
                                                'unit.y','tra_meas.y','Num_passatgers')]
colnames(df_vols_passatgers_2024) <- c('Sortida',
                                       'Vol','Codi_vol','Num_vols',
                                       'Passatgers','Codi_passatgers','Num_passatgers')

### Extracció del codi d'aeroport com a nou atribut
df_vols_passatgers_2024$codi_aeroport <- substr(x = df_vols_passatgers_2024$Sortida,
                                                start = 12,
                                                stop = 15)

### Unió amb el df original d'aeroports per obtenir les geometries puntuals (la localització)
df_geo <- left_join(df_vols_passatgers_2024,
                    aeroports,
                    by = join_by(codi_aeroport == AIRP_ICAO_))

### Neteja del df obtingut
df_geo <- df_geo[,c('Sortida',
                    'Vol','Codi_vol','Num_vols',
                    'Passatgers','Codi_passatgers','Num_passatgers',
                    'codi_aeroport','AIRP_NAME_','CNTR_CODE','AIRP_CITY',
                    'geometry')]

colnames(df_geo) <- c('Sortida',
                      'Vol','Codi_vol','Num_vols',
                      'Passatgers','Codi_passatgers','Num_passatgers',
                      'codi_aeroport','Aeroport','País','Ciutat',
                      'geometry')

df_geo <- na.omit(df_geo) # Eliminació dels registres amb geometries i aeroports buits

## Transformació en objecte tipus SF 
sortides_sf <- df_geo %>%
st_as_sf() %>%
st_transform(crs = 4326)

st_crs(x = sortides_sf) <- 4326

sortides_sf <- cbind(sortides_sf, 
                     st_coordinates(sortides_sf))


# Creació de l'objecte aeroport de Barcelona 
aeroport_bcn <- aeroports %>%
filter(AIRP_ICAO_ == 'LEBL') %>%
st_as_sf(aeroport_bcn) %>%
cbind(st_coordinates(aeroport_bcn))

## Integració al df principal per obtenir les coordenades d'origen de tots els vols
sortides_sf$X_BCN <- aeroport_bcn$X
sortides_sf$Y_BCN <- aeroport_bcn$Y


# Creació de l'objecte països europeus 
europa <- st_read("C:/30DayMapChallenge2025/Day10_Air/COMM_RG_01M_2016_4326.geojson")
st_crs(europa) # EPSG 4326

# Creació de l'objecte de resta de països 
paisos <- st_read("C:/30DayMapChallenge2025/Day10_Air/CNTR_RG_01M_2024_4326.geojson")
st_crs(paisos) # EPSG 4326


# PLOTING -------------------------------------------------------------------------------------------------------------------------------------------
ggplot() +
  geom_sf(data = europa, fill = NA, color = 'grey95', linewidth = 0.2) +
  geom_sf(data = paisos, fill = NA, color = 'black', linewidth = 0.1) +
  coord_sf(datum = 4326, xlim = c(-24,42), ylim = c(27,72), expand = FALSE) +
  geom_point(data = sortides_sf, aes(x = X, y = Y), 
             size = 0.35, shape = 21, fill = 'white', color = 'black') +
  geom_curve(data = sortides_sf, 
             aes(xend = X, yend = Y, x = X_BCN, y = Y_BCN,
                 linewidth = Num_passatgers, alpha = Num_passatgers),
             color = 'red', curvature = 0.5) +
  scale_linewidth_continuous(range = c(0.25,1),
                             guide = 'none') + 
  scale_alpha_continuous(name = 'Nombre de passatgers',
                         range = c(0.3,1),
                         guide = 'none') + 
  labs(
    title = 'Flux de viatgers des de Barcelona el 2024',
    subtitle = 'Font: Eurostat',
    x = 'Longitud',
    y = 'Latitud'
  ) +
  theme_minimal()

## Exportar resultats
ggsave("mapa_passatgers.png", 
       width = 10, height = 8, units = "in",
       bg = 'white',
       dpi = 550)
