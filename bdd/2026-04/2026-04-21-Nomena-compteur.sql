create or replace view COMPTEURLIB as
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
        WHEN c.etat = 0 THEN 'ANNULÉ'
        WHEN c.etat = 1 THEN 'CRÉÉ'
        WHEN c.etat = 11 THEN 'VISÉ'
        END AS etatlib
FROM COMPTEUR c
         LEFT JOIN FABRICATION f ON f.id = c.idfabrication
         LEFT JOIN AS_INGREDIENT_MACHINE aim    ON aim.id = c.idmachine;