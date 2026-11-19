CREATE OR REPLACE  VIEW AS_INGREDIENT_MAINTENANCE_LIB AS
SELECT
    am."ID",am."IDINGREDIENT",am."IDENTITE",am."REFERENCEOBJET",am."MARQUEOBJET",am."MODELEOBJET",am."NUMEROSERIEOBJET",am."DESCRIPTIONOBJET",am."QUALITEOBJET",am."ETATOBJET",am."LOCALISATIONOBJET",am."PUISSANCEOBJET",am."OBSERVATIONOBJET",am."TYPERATTACHEMENT",am."ESTENGIN",am."LIBELLE",am."DATEAQUISITION",
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
    am.pu as PU,
    concat(am.id,concat(ai.libelle,concat(am.identite,concat(qo.val,concat(eo.val,ld.val))))) AS motsClesss
FROM AS_INGREDIENTS ai
         JOIN AS_INGREDIENT_MAINTENANCE am ON ai.ID = am.IDINGREDIENT
         LEFT JOIN QUALITESOBJETMAINTENANCE qo ON am.QUALITEOBJET = qo.ID
         LEFT JOIN ETATOBJETMAINTENANCE eo ON am.ETATOBJET = eo.ID
         left join LOG_DEPARTEMENT ld on am.localisationObjet=ld.id
         LEFT JOIN LIGNE l ON l.id=am.idligne;