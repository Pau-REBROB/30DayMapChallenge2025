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
4. Unió de les dades amb les geometries
5. Creació de la malla hexagonal, retall segons la geometria d'Espanya i unió dels atributs
6. Visualització de les dades amb `ggplot2`, creant abans els intervals de valors de població
7. Exportació del mapa final com a imatge

## Resultats  
Predomini de municipis amb menys de 5.000 habitants en tot l'interior de la península, especialment amb menys de 1.000 habitants a la meitat nord. 
Les grans ciutats destaquen com a nuclis foscos envoltats d'ataronjats.

---

Imatge del mapa final:

![Mapa Poblacio Hexgrid](../../Projectes/Poblacio_Espanya_hexagons/Resultats/Poblacio_Espanya_Day25-Hexagons.png)

---

## Fitxers inclosos  
*- `hut_comunicacio_opendata.csv`: font de les dades
- `Poblacio_Espanya_Hexagons_Day25_Hexagons.R`: script de processament en R  
- `Poblacio_Espanya_Day25-Hexagons.png`: imatge del mapa final*  

