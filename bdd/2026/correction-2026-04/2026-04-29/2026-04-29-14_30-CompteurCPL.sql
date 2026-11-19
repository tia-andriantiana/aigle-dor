-- SOCOBISRECTIFDONNEE.COMPTEURLIB source

CREATE OR REPLACE  VIEW "COMPTEURLIB" ("ID", "NOMBRE", "IDFABRICATION", "IDMACHINE", "DATY", "HEURE", "DEBUT", "ETAT", "IDORIGINE", "IDFABRICATIONLIB", "IDMACHINELIB", "ETATLIB") AS 
  SELECT
	    c.ID,
	    c.NOMBRE,
	    c.IDFABRICATION,
	    c.IDMACHINE,
	    c.DATY,
	    c.HEURE,
	    c.DEBUT,
	    c.ETAT,
	    c.IDORIGINE,
	    f.LIBELLE AS idfabricationlib,
	    aim.INGREDIENTLIB AS idmachinelib,
	     CASE
	        WHEN c.ETAT = 0
	            THEN 'ANNUL&Eacute;E'
	        WHEN c.ETAT = 1
	            THEN 'CR&Eacute;&Eacute;E'
	        WHEN c.ETAT = 11
	            THEN 'VIS&Eacute;(E) par Chef de Fabrication'
	        WHEN c.ETAT = 3
	            THEN 'VIS&Eacute;(E) par Releveur'
	        END AS etatlib
	FROM COMPTEUR c
	         LEFT JOIN FABRICATION f ON f.id = c.idfabrication
	         LEFT JOIN AS_INGREDIENT_MACHINE aim    ON aim.id = c.idmachine
 ;

 -- SOCOBISRECTIFDONNEE.COMPTEURCPL source

CREATE OR REPLACE  VIEW "COMPTEURCPL"AS 
  SELECT
    c.id,
    c.daty,
    c.idligne,
    c.ancien,
    c.valeur,
    c.ecart,
    c.idcategorie,
    l.val        AS idlignelib,
    cc.libelle       AS idcategorielib,
    c.etat,
       CASE
	        WHEN c.ETAT = 0
	            THEN 'ANNUL&Eacute;E'
	        WHEN c.ETAT = 1
	            THEN 'CR&Eacute;&Eacute;E'
	        WHEN c.ETAT = 11
	            THEN 'VIS&Eacute;(E) par Chef de Fabrication'
	        WHEN c.ETAT = 3
	            THEN 'VIS&Eacute;(E) par Releveur'
	        END AS etatlib,
    c.IDMAGASIN,
    m.VAL AS idMagasinLib
FROM compteurmaintenance c
         LEFT JOIN ligne l
                   ON l.id = c.idligne
         LEFT JOIN AS_INGREDIENTS_CONSOMMABLE cc
                   ON cc.id = c.idcategorie
         LEFT JOIN MAGASIN2 m ON m.ID = c.IDMAGASIN;