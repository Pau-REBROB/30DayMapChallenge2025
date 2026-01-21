# Població a Espanya 2024 en una malla hexagonal

## Descripció  
Aquest projecte analitza la distribució de la població d'Espanya a partir de dades obertes.  
Tot el procés de tractament, neteja i visualització de les dades es va realitzar amb **R**.

## Dades
La font de dades es tracte d'un arxiu CSV obtingut del Instituto Nacional de Estadística (INE).
L'arxiu, que està contingut en una carpeta que conté la sèrie temporal des de l'any 1999, conté el llistat de municipis espanyols amb la població total i la població masculina i femenina segons el padró municipal del 2024. 

## Objectius  
- Representar la distribució espacial de la població  
- Combinar anàlisi de dades i la seva representació amb programació en R  
- Desenvolupar una visualització clara i interpretativa en forma de malla hexagonal (***hex grid***)

## Eines  
- R (`readxl`, `dplyr`, `stringr`, `sf`, `ggplot2`) per al processament i visualització de dades  

## Procés  
1. Importació de les dades de població amb `readxl` i de les diferents geometries
2. Creació dels codis municipials
3. Transformació al sistema de referència oficial EPSG:25830
4. Agregació i exportació de les dades en R compatible amb QGIS
5. Creació del mapa temàtic a QGIS com a mapa de punts i mapa de calor  
6. Exportació del mapa final com a imatge

## Resultats  
*La visualització mostra la concentració dels habitatges turístics i el nombre de places per barris i per districtes, destacant les zones amb major presència en un mapa de calor.
Cada punt representa un habitatge destinat a ús turístic, i la mida i el color del punt fan referència a la major o menor quantitat de places disponibles a l'habitatge.*

---

Imatge del mapa final:

![Mapa Poblacio Hexgrid](../../Projectes/Poblacio_Espanya_hexagons/Resultats/Poblacio_Espanya_Day25-Hexagons.png)

---

## Fitxers inclosos  
*- `hut_comunicacio_opendata.csv`: font de les dades
- `Habitatges_us_turistic_Barcelona_Day1_Points.R`: script de processament en R  
- `Habitatges_us_turistic_de_la_ciutat_de_Barcelona_Day1-Points.png`: imatge del mapa final*  

