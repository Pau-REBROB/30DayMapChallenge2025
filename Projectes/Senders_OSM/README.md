# Senders GR i PR de Catalunya a OpenStreetMap

## Descripció  
Aquest projecte analitza l'estat dels senders catalogats com a GR i PR a Catalunya a partir de dades obertes d'OpenStreetMap.  
El tractament i la neteja de les dades es va realitzar amb **R**, mentre que la visualització final i la composició cartogràfica es va dur a terme amb **QGIS**.

## Dades
La font de dades es tracte d'un arxiu .pbf obtingut del servei de descàrregues d'OSM (Geofabrik).
L'arxiu conté un totes les dades de Catalunya.

## Objectius  
- Analitzar l'estat dels senders GR i PR a OSM  
- Combinar preparació i anàlisi de dades amb programació en R i cartografia amb QGIS  
- Desenvolupar una visualització clara i interpretativa per a la comunicació dels resultats

## Eines  
- R (`dplyr`) per al processament de dades  
- QGIS per a la composició cartogràfica i simbologia  

## Procés  
1. Importació i neteja de les dades en R
2. Agregació i exportació de les dades en R compatible amb QGIS
3. Creació del mapa temàtic a QGIS com a mapa de punts i mapa de calor  
4. Exportació del mapa final com a imatge

## Resultats  
La visualització mostra com encara hi ha molt camí per fer en la catalogació dels camins i senders com a GR i PR a Catalunya.
Durant el procés s'ha observat poca consistència en el nom dels senders.

---

Imatge del mapa final:

![GR PR OSM](../../Projectes/Senders_OSM/Resultats/AAA_Day14-OSM.png)

---

## Fitxers inclosos  
- `Senders_GR_PR_Day14_OSM.R`: script de processament en R  
- `Habitatges_us_turistic_de_la_ciutat_de_Barcelona_Day1-Points.png`: imatge del mapa final  
