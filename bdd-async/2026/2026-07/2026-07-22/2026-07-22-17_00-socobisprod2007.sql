create or replace view COMPTEURELECTRICITELIB as
SELECT
    ce.ID,ce.DATY,ce.IDLIGNE,ce.VALEUR,ce.ECART,ce.IDCATEGORIE,ce.IDMAGASIN,ce.ETAT,ce.ANCIEN,ce.REMARQUE,ce.HEURE,ce.IDMACHINE,ce.IDMERE,
    l.VAL AS IdLigneLib,
    m.VAL AS IdMachineLib,
    cat.LIBELLE AS IdCategorieLib
FROM CompteurElectricite ce
         LEFT JOIN Ligne l ON ce.IdLigne = l.id
         LEFT JOIN MACHINE m ON ce.IdMachine = m.id
         LEFT JOIN AS_INGREDIENTS_CONSOMMABLE cat ON ce.IdCategorie = cat.id

CREATE OR REPLACE VIEW COMPTEURELECTRICITEMERELIB AS
SELECT
    c.*,
    l.VAL AS LIGNELIB
FROM
    COMPTEURELECTRICITEMERE c
        LEFT JOIN LIGNE l on l.ID = c.LIGNE