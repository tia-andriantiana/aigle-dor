CREATE OR REPLACE  VIEW COMPTEURCPL AS 
  SELECT
    c.id,
    c.daty,
    c.idligne,
    c.valeur,
    c.ecart,
    c.idcategorie,
    c.idtranche,
    l.val        AS idlignelib,
    cc.val       AS idcategorielib,
    t.val        AS idtranchelib,
    c.etat,
    c.IDMAGASIN,
    m.VAL AS idMagasinLib,
    t.HEUREDEBUT,
    t.HEUREFIN
FROM compteurmaintenance c
         LEFT JOIN ligne l
                   ON l.id = c.idligne
         LEFT JOIN categorieconsommable cc
                   ON cc.id = c.idcategorie
         LEFT JOIN tranche t
                   ON t.id = c.idtranche
         LEFT JOIN MAGASIN2 m ON m.ID = c.IDMAGASIN
 ;

 
CREATE OR REPLACE  VIEW TEMPSOUVERTURELIB AS 
  SELECT
    t.ID,t.IDMACHINE,t.TEMPS,t.CAPACITE,t.IDUNITE,
    aim.LIBELLE AS idmachinelib,
    au.VAL as idunitelib,
    
    t.ID || t.IDMACHINE || t.TEMPS || t.CAPACITE || t.IDUNITE || 
    aim.LIBELLE || au.VAL  AS motsClesss
FROM tempsouverture t
         LEFT JOIN as_ingredient_maintenance aim
                   ON aim.id = t.idmachine
         LEFT JOIN AS_UNITE au
                   ON au.id = t.IDUNITE
 ;


 CREATE OR REPLACE
VIEW ETATINSPECTIONMOTCLES AS
    SELECT
	et.*,
	et.ID || et.val || et.DESCE AS motsClesss
FROM
	ETATINSPECTION et;