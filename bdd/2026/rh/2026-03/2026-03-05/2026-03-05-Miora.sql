UPDATE menudynamique SET href = 'module.jsp?but=paie/categorie/salaireparcategorie-saisie.jsp' WHERE id = 'MENDYN1765468330900915';
UPDATE menudynamique SET href = 'module.jsp?but=paie/categorie/salaireparcategorie-liste.jsp' WHERE id = 'MENDYN1765468357776807';


CREATE OR REPLACE VIEW CATEGORIE_QUALIFICATION_VW AS
SELECT 
    cq.*,
    cp.val AS categorieLib,
    qual.val AS qualificationLib,
    CASE 
        WHEN cq.etat = 1 THEN 'ACTIF'
        WHEN cq.etat = -1 THEN 'INACTIF'
        ELSE 'INCONNU'
    END AS etatLib
FROM CATEGORIE_QUALIFICATION cq
LEFT JOIN CATEGORIE_PAIE cp 
    ON cp.id = cq.idcategorie
LEFT JOIN QUALIFICATION_PAIE qual 
    ON cq.idqualification = qual.id;



CREATE OR REPLACE VIEW SALAIRECATEGORIE_ACTIF AS
SELECT 
    cq.id,
    cq.idcategorie,
    cq.idqualification,
    cq.remarque,
    cq.montant,
    cq.date_debut
FROM CATEGORIE_QUALIFICATION cq
WHERE cq.etat = 1;
