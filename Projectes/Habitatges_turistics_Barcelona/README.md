# Habitatges d'ús turístic a Barcelona

## Descripció  
Aquest projecte analitza la distribució dels habitatges d’ús turístic a Barcelona a partir de dades obertes.  
El tractament i la neteja de les dades es va realitzar amb **R** utilitzant paquets com `dplyr` i `sf`, mentre que la visualització final i la composició cartogràfica es va dur a terme amb **QGIS**.

## Objectius  
- Analitzar la distribució espacial dels habitatges turístics  
- Combinar anàlisi de dades amb programació en R i cartografia amb QGIS  
- Desenvolupar una visualització clara i interpretativa per a la comunicació territorial

## Eines  
- R (`dplyr`, `sf`) per al processament de dades  
- QGIS per a la composició cartogràfica i simbologia  

## Procés  
1. Importació i neteja de les dades en R  
2. Exportació a format compatible amb QGIS  
3. Creació del mapa temàtic a QGIS  
4. Exportació del mapa final com a imatge

## Resultats  
La visualització mostra la concentració dels habitatges turístics per districtes, destacant les zones amb major presència. Aquesta informació pot ser útil per a l’anàlisi urbanística i la gestió turística.

---

Imatge del mapa final:

![Mapa Habitatges Turístics](mapa_final.png)

---

## Fitxers inclosos  
- `processament_dades.R`: script de processament en R  
- `mapa_final.png`: imatge del mapa final  
- projecte QGIS (`habitatges_turistics.qgz`) 
