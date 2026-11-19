--Stefan



CREATE OR REPLACE VIEW SALAIRECATEGORIE_ACTIF AS
SELECT
    cq.id,
    cq.idcategorie,
    cq.idqualification,
    cq.remarque,
    cq.montant,
    cq.date_debut,
    cq.etat
FROM CATEGORIE_QUALIFICATION cq
WHERE cq.etat = 1;