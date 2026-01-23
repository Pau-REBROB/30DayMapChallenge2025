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
- R (`osmextract`) per a l'ús de les dades
- R (`dplyr`, `sf`, 'stringr`) per al processament de dades  
- QGIS per a la composició cartogràfica i simbologia  

## Procés  
1. Descompressió de les dades des de l'arxiu .pbf per obtenir totes les geometries tipus línia (`osmextract`)
2. Filtres dels elements linials (`stringr`) per cobrir totes les possibles codificacions, tant de GR com de PR
3. Creació d'una columna amb el codi GR/PR de manera unificada (`stringr`) a partir del nom codificat a OSM
4. Exportació de les dades en R compatible amb QGIS
5. Creació del mapa temàtic a QGIS com a mapa de línies codificades per tipus de sender
6. Exportació del mapa final com a imatge

## Resultats  
La visualització mostra com encara hi ha molt camí per fer en la catalogació dels camins i senders com a GR i PR a Catalunya.
Durant el procés s'ha observat poca consistència en el nom dels senders.

---

Imatge del mapa final:

![GR PR OSM](../../Projectes/Senders_OSM/Resultats/Xarxa_senders_GR_PR_Catalunya_Day14-OSM.png)

---

## Fitxers inclosos  
- `Senders_GR_PR_Day14_OSM.R`: script de processament en R  
- `Xarxa_senders_GR_PR_Catalunya_Day14-OSM.png`: imatge del mapa final  
