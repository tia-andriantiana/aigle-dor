CREATE OR REPLACE VIEW compteurCPLRecent as
SELECT *
FROM (
    SELECT 
        cm.ID,
        cm.DATY,
        cm.IDLIGNE,
        cm.VALEUR,
        cm.ECART,
        cm.IDCATEGORIE,
        cm.IDMAGASIN,
        cm.ETAT,
        cm.ANCIEN,
        cm.IDLIGNELIB ,
        cm.IDCATEGORIELIB ,
        cm.IDMAGASINLIB ,
        ROW_NUMBER() OVER (
            PARTITION BY cm.IDLIGNE, cm.IDCATEGORIE, cm.IDMAGASIN
            ORDER BY cm.DATY DESC
        ) AS rn
        
    FROM CompteurCPL cm
)
WHERE rn = 1;

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDRLVV0125', 'Valeur Compteur', 'list_alt', 'module.jsp?but=compteur/compteur-recent-liste.jsp', 8, 2, 'MNDNMT01');
