# Habitatges d'ús turístic de la ciutat de Barcelona

## Descripció  
Aquest projecte analitza la distribució dels habitatges d’ús turístic a Barcelona a partir de dades obertes.  
El tractament i la neteja de les dades es va realitzar amb **R**, mentre que la visualització final i la composició cartogràfica es va dur a terme amb **QGIS**.

## Dades
La font de dades es tracte d'un arxiu CSV obtingut del Servei Open Data BCN.
L'arxiu conté un llistat dels habitatges destinats a ús turístic, amb la seva adreça i el barri i el districte al qual pertanyen, juntament amb el número de places que acullen. 

## Objectius  
- Analitzar la distribució espacial dels habitatges turístics  
- Combinar anàlisi de dades amb programació en R i cartografia amb QGIS  
- Desenvolupar una visualització clara i interpretativa per a la comunicació dels resultats

## Eines  
- R (`dplyr`, `sf`) per al processament de dades  
- QGIS per a la composició cartogràfica i simbologia  

## Procés  
1. Importació i neteja de les dades en R
2. Agregació i exportació de les dades en R compatible amb QGIS
3. Creació del mapa temàtic a QGIS com a mapa de punts i mapa de calor  
4. Exportació del mapa final com a imatge

## Resultats  
La visualització mostra la concentració dels habitatges turístics i el nombre de places per barris i per districtes, destacant les zones amb major presència en un mapa de calor.
Cada punt representa un habitatge destinat a ús turístic, i la mida i el color del punt fan referència a la major o menor quantitat de places disponibles a l'habitatge.

---

Imatge del mapa final:

![Mapa Habitatges Turístics](Projectes/Habitatges_turistics_Barcelona/Resultats/Habitatges_us_turistic_de_la_ciutat_de_Barcelona_Day1-Points.png)

---

## Fitxers inclosos  
- `hut_comunicacio_opendata.csv`: font de les dades
- `Habitatges_us_turistic_Barcelona_Day1_Points.R`: script de processament en R  
- `Habitatges_us_turistic_de_la_ciutat_de_Barcelona_Day1-Points.png`: imatge del mapa final  
