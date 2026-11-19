create or replace view COMPTEURELECTRICITELIB as
SELECT
    ce.ID,ce.DATY,ce.IDLIGNE,ce.VALEUR,ce.ECART,ce.IDCATEGORIE,ce.IDMAGASIN,ce.ETAT,ce.ANCIEN,ce.REMARQUE,ce.HEURE,ce.IDMACHINE,ce.IDMERE,
    l.VAL AS IdLigneLib,
    m.LIBELLE AS IdMachineLib,
    cat.LIBELLE AS IdCategorieLib
FROM CompteurElectricite ce
         LEFT JOIN Ligne l ON ce.IdLigne = l.id
         LEFT JOIN AS_INGREDIENT_MACHINE m ON ce.IdMachine = m.ID
         LEFT JOIN AS_INGREDIENTS_CONSOMMABLE cat ON ce.IdCategorie = cat.id

 