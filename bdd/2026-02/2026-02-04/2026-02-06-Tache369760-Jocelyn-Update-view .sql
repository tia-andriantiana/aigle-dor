

CREATE OR REPLACE VIEW COMPTEURLIB AS 
  SELECT 
c."ID",c."NOMBRE",c."IDFABRICATION",c."IDMACHINE",c."DATY",c."HEURE",c."DEBUT",c."ETAT",c."IDORIGINE",
f.LIBELLE AS idfabricationlib,
m.VAL AS idmachinelib,
CASE 
	WHEN c.etat = 0 
	THEN 'ANNULEE'
	WHEN c.etat = 1 
	THEN 'CREE'
	WHEN c.etat = 11 
	THEN 'VISEE'
END AS etatlib
FROM COMPTEUR c 
LEFT JOIN FABRICATION f ON f.id = c.idfabrication
LEFT JOIN MACHINE m ON m.id = c.idmachine

 ;
--update  VIEW COMPTEURLIB

CREATE OR REPLACE VIEW COMPTEURLIB AS  
SELECT 
    c."ID",
    c."NOMBRE",
    c."IDFABRICATION",
    c."IDMACHINE",
    c."DATY",
    c."HEURE",
    c."DEBUT",
    c."ETAT",
    c."IDORIGINE",
    f.LIBELLE AS idfabricationlib,
    aim.INGREDIENTLIB AS idmachinelib,
    CASE 
        WHEN c.etat = 0 THEN 'ANNULEE'
        WHEN c.etat = 1 THEN 'CREE'
        WHEN c.etat = 11 THEN 'VISEE'
    END AS etatlib
FROM COMPTEUR c
LEFT JOIN FABRICATION f ON f.id = c.idfabrication
LEFT JOIN AS_INGREDIENT_MACHINE aim    ON aim.id = c.idmachine;