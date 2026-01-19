# Sortides des de l'aeroport de Barcelona, any 2024

## Descripció  
Aquest projecte analitza i representa les sortides des de l'aeroport de Barcelona cap a destinacions de la UE l'any 2024 a partir de dades obertes  
Tot el procés de tractament i transformació de les dades, així com la composició cartogràfica, es va realitzar amb **R**

## Dades
Les dades s'han obtingut a través de l'API d'Eurostat, dataset ".."

Contenen el llistat de totes les arribades i sortides de tots els aeroports de la UE anuals i mensuals, des de l'any 2000, amb el nombre de passatgers i el nombre de vols

## Objectius  
- Analitzar el flux de passatgers des de l'aeroport de Barcelona l'any 2024  
- Combinar anàlisi de dades i representació gràfica amb programació en R  
- Desenvolupar una visualització clara i interpretativa per a la comunicació dels resultats

## Eines  
- R (`dplyr`, `sf`, `ggplot2`) per al processament i representació de dades  

## Procés  
1. Importació del dataset
2. Filtratge dels vols segons i.aeroport de Barcelona, ii.any 2024, iii.arribades, iv.valor total anual
3. Creació d'un df amb el nombre de passatgers i un df amb el nombre de vols per a cada destí, i unió dels dos df
4. Neteja de les dades amb canvi de nom a variables més explicatives
5. 
6. Agregació i exportació de les dades en R compatible amb QGIS
7. Creació del mapa temàtic a QGIS com a mapa de punts i mapa de calor  
8. Exportació del mapa final com a imatge

## Resultats  
La visualització mostra la concentració dels habitatges turístics i el nombre de places per barris i per districtes, destacant les zones amb major presència en un mapa de calor.
Cada punt representa un habitatge destinat a ús turístic, i la mida i el color del punt fan referència a la major o menor quantitat de places disponibles a l'habitatge.

---

Imatge del mapa final:

![Mapa Habitatges Turístics](../../Projectes/Habitatges_turistics_Barcelona/Resultats/Flux de viatgers des de l'aeroport de Barcelona 2024.png)

---

## Fitxers inclosos  
- `Vols_Barcelona_2024.R`: script de processament en R  
- `Flux_viatgers_Barcelona_2024_Day10-Air.png`: imatge del mapa final  
