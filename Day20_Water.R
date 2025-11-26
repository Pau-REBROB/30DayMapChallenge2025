library(dplyr)
library(stringr)
library(osmextract)
library(sf)
library(ggplot2)


osm_cat_pol <- oe_read("C:/30DayMapChallenge2025/Day14_OSM/cataluna-251111.osm.pbf", layer = 'multipolygons')


pantans <- subset(x = osm_cat_pol,
                  subset = grepl(pattern = '^Pantà d.', x = name))
embassaments <- subset(x = osm_cat_pol,
                       subset = grepl(pattern = '^Embassament d.', x = name))



pant_emb_conqint <- c('#Baells','#Darnius-Boadella',
                      '#Foix','Llosa del Cavall','#Pasteral',
                      '#Riudecanyes','Sant Ponç','#Sau','#Susqueda') 
pant_emb_ebre <- c('#Siurana','#Camarasa','#Canelles','Escales',
                   '#Guiamets','Oliana','#Rialb',
                   '#Riba-roja','Talarn','#Terradets')



pantans$Panta <- str_extract(string = pantans$name, pattern = '\\S+$')
### \\S+ indica qualsevol caracter diferent a en blanc, i més caracters;
### $ significa que estigui al final de tot
pantans_conqint <- pantans[pantans$Panta %in% pant_emb_conqint,]
pantans_ebre <- pantans[pantans$Panta %in% pant_emb_ebre,]

embassaments$Embassament <- str_extract(string = embassaments$name, pattern = '\\S+$')
embassaments_conqint <- embassaments[embassaments$Embassament %in% pant_emb_conqint,]
embassaments_ebre <- embassaments[embassaments$Embassament %in% pant_emb_ebre,]
