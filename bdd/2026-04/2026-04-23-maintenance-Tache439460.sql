
CREATE OR REPLACE  VIEW INSPECTIONFILLELIB AS 
  SELECT SQ.ID,SQ.IDMERE,SQ.IDELEMENT,SQ.IDELEMENTLIB,SQ.IDETATINSPECTION,SQ.REMARQUE,SQ.IDETATINSPECTIONLIB,SQ.IDMACHINELIB,SQ.IDMACHINE,SQ.idLigne,SQ.idLigneLib,
  (NVL(TO_CHAR(ID),'') || ' | ' || NVL(TO_CHAR(IDMERE),'') || ' | ' || NVL(TO_CHAR(IDELEMENT),'') || ' | ' || NVL(TO_CHAR(IDELEMENTLIB),'') || ' | ' || NVL(TO_CHAR(IDETATINSPECTION),'') || ' | ' || NVL(TO_CHAR(REMARQUE),'') || ' | ' || NVL(TO_CHAR(IDETATINSPECTIONLIB),'') || ' | ' || NVL(TO_CHAR(IDMACHINELIB),'') || ' | ' || NVL(TO_CHAR(IDMACHINE),'')) AS MOTSCLESSS
FROM (
  (
SELECT
    ifi.id,
    ifi.idmere,
    ifi.idElement,
    eis.val     AS idElementlib,
    ifi.idEtatInspection,
    ifi.remarque,
    ei.val    AS idEtatInspectionlib,
    m.libelle AS idMachinelib,
    m.id AS idMachine,
     l.id AS idLigne,
    l.VAL AS idLigneLib
FROM InspectionFille ifi
         LEFT JOIN ElementInspection eis
                   ON ifi.idElement = eis.id
         LEFT JOIN ElementInspectionMachine ai
                   ON ai.idelementinspection = ifi.idelement
         LEFT JOIN AS_INGREDIENT_MAINTENANCE m
                   ON ai.idMachine = m.id
         LEFT JOIN EtatInspection ei
                   ON ifi.idEtatInspection = ei.id
         left join ligne l on m.IDLIGNE = l.id)
) SQ;

CREATE OR REPLACE  VIEW AS_INGREDIENT_MAINTENANCE_LIB AS 
SELECT
    am.ID,
    am.IDINGREDIENT,
    am.IDENTITE,
    am.REFERENCEOBJET,
    am.MARQUEOBJET,
    am.MODELEOBJET,
    am.NUMEROSERIEOBJET,
    am.DESCRIPTIONOBJET,
    am.QUALITEOBJET,
    am.ETATOBJET,
    am.LOCALISATIONOBJET,
    am.PUISSANCEOBJET,
    am.OBSERVATIONOBJET,
    am.TYPERATTACHEMENT,
    am.ESTENGIN,
    am.LIBELLE,
    am.DATEAQUISITION,

    ai.libelle AS INGREDIENTLIB,
    am.IDENTITE AS IDENTITELIB,
    qo.VAL AS QUALITEOBJETLIB,
    eo.VAL AS ETATOBJETLIB,
    ld.val AS localisationObjetLib,

    CASE
        WHEN am.ESTENGIN = 1 THEN 'Oui'
        ELSE 'Non'
    END AS ESTENGINLIB,

    l.id AS idligne,
    l.val AS idlignelib,
    am.pu AS PU,

    (
        NVL(am.ID, '') || ' | ' ||
        NVL(ai.libelle, '') || ' | ' ||
        NVL(am.IDENTITE, '') || ' | ' ||
        NVL(qo.val, '') || ' | ' ||
        NVL(eo.val, '') || ' | ' ||
        NVL(ld.val, '') || ' | ' ||
        NVL(l.val, '') || ' | ' ||
        NVL(am.LIBELLE, '')
    ) AS MOTSCLESSS

FROM AS_INGREDIENTS ai
JOIN AS_INGREDIENT_MAINTENANCE am ON ai.ID = am.IDINGREDIENT
LEFT JOIN QUALITESOBJETMAINTENANCE qo ON am.QUALITEOBJET = qo.ID
LEFT JOIN ETATOBJETMAINTENANCE eo ON am.ETATOBJET = eo.ID
LEFT JOIN LOG_DEPARTEMENT ld ON am.LOCALISATIONOBJET = ld.ID
LEFT JOIN LIGNE l ON l.ID = am.IDLIGNE;