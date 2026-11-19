CREATE OR REPLACE VIEW CompteurElectriciteLib AS
SELECT
    ce.*,
    l.VAL AS IdLigneLib,
    m.VAL AS IdMachineLib,
    cat.LIBELLE AS IdCategorieLib
FROM CompteurElectricite ce
         LEFT JOIN Ligne l ON ce.IdLigne = l.id
         LEFT JOIN MACHINE m ON ce.IdMachine = m.id
         LEFT JOIN AS_INGREDIENTS_CONSOMMABLE cat ON ce.IdCategorie = cat.id;
