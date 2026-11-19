-------Stefan
--2026-08-03-11_50-aigledor3107

CREATE OR REPLACE VIEW ST_INGREDIENTSVENTEPOS AS
SELECT
    ai.ID,
    ai.LIBELLE AS LIBELLE,
    ai.SEUIL,
    ai.UNITE,
    ai.QUANTITEPARPACK,
    ai.PU,
    ai.ACTIF,
    ai.PHOTO,
    ai.CALORIE,
    ai.DURRE,
    ai.COMPOSE,
    ai.CATEGORIEINGREDIENT,
    ai.IDFOURNISSEUR,
    ai.DATY,
    ai.QTELIMITE,
    ai.PV,
    ai.LIBELLEVENTE,
    ai.SEUILMIN,
    ai.SEUILMAX,
    ai.PUACHATUSD,
    ai.PUACHATEURO,
    ai.PUACHATAUTREDEVISE,
    ai.PUVENTEUSD,
    ai.PUVENTEEURO,
    ai.PUVENTEAUTREDEVISE,
    ai.ISVENTE,
    ai.ISACHAT,
    ai.COMPTE_VENTE,
    ai.COMPTE_ACHAT,
    ai.TVA,
    1 AS TAUX,
    ai.COMPTE_VENTE AS COMPTE,
    ai.LIBELLE || ' ' || ai.COULEUR || ' ' || ai.TAILLE AS LIBELLECOMPOSANT,
    ai.COULEUR,
    vrc.NOMCOULEUR AS COULEURLIB,
    ai.TAILLE,
    ai.MARQUE,
    pointure.VAL AS MARQUELIB,
    ai.CODEBARRE,
    ai.REFERENCE,
    ai.CODEGROS,
    ai.PVGROS,
    u.VAL AS UNITELIB,
    CONCAT(CONCAT(ai.LIBELLE, ' - '), u.VAL) AS DESIGNATION,
    ai.TYPESTOCK,
    ai.PV * (1 + ai.TVA / 100) AS PVTVA
FROM AS_INGREDIENTS ai
         LEFT JOIN AS_RECETTE ar
                   ON ar.IDPRODUITS = ai.ID
         LEFT JOIN AS_INGREDIENTS cps
                   ON cps.ID = ar.IDINGREDIENTS
         LEFT JOIN AS_UNITE u
                   ON ai.UNITE = u.ID
         LEFT JOIN V_REFERENCE_COULEUR vrc
                   ON ai.COULEUR = vrc.REFERENCECOULEUR
         LEFT JOIN POINTURE pointure
                   ON ai.MARQUE = pointure.ID
WHERE ai.PV <> 0
  AND ai.ACTIF = 1
GROUP BY
    ai.ID,
    ai.LIBELLE,
    ai.SEUIL,
    ai.UNITE,
    ai.QUANTITEPARPACK,
    ai.PU,
    ai.ACTIF,
    ai.PHOTO,
    ai.CALORIE,
    ai.DURRE,
    ai.COMPOSE,
    ai.CATEGORIEINGREDIENT,
    ai.IDFOURNISSEUR,
    ai.DATY,
    ai.QTELIMITE,
    ai.PV,
    ai.LIBELLEVENTE,
    ai.SEUILMIN,
    ai.SEUILMAX,
    ai.PUACHATUSD,
    ai.PUACHATEURO,
    ai.PUACHATAUTREDEVISE,
    ai.PUVENTEUSD,
    ai.PUVENTEEURO,
    ai.PUVENTEAUTREDEVISE,
    ai.ISVENTE,
    ai.ISACHAT,
    ai.COMPTE_VENTE,
    ai.COMPTE_ACHAT,
    ai.TVA,
    ai.COULEUR,
    vrc.NOMCOULEUR,
    ai.TAILLE,
    ai.MARQUE,
    pointure.VAL,
    ai.CODEBARRE,
    ai.REFERENCE,
    ai.CODEGROS,
    ai.PVGROS,
    u.VAL,
    ai.TYPESTOCK;


CREATE OR REPLACE VIEW ST_INGREDIENTSVENTEPOS_REM AS
SELECT
    ai.ID,
    ai.LIBELLE AS libelle,
    ai.SEUIL,
    ai.UNITE,
    ai.QUANTITEPARPACK,
    ai.PU,
    ai.ACTIF,
    ai.PHOTO,
    ai.CALORIE,
    ai.DURRE,
    ai.COMPOSE,
    ai.CATEGORIEINGREDIENT,
    ai.IDFOURNISSEUR,
    ai.DATY,
    ai.QTELIMITE,
    ai.PV,
    ai.LIBELLEVENTE,
    ai.SEUILMIN,
    ai.SEUILMAX,
    ai.PUACHATUSD,
    ai.PUACHATEURO,
    ai.PUACHATAUTREDEVISE,
    ai.PUVENTEUSD,
    ai.PUVENTEEURO,
    ai.PUVENTEAUTREDEVISE,
    ai.ISVENTE,
    ai.ISACHAT,
    ai.COMPTE_VENTE,
    ai.COMPTE_ACHAT,
    ai.TVA,
    1 AS taux,
    ai.COMPTE_VENTE AS compte,
    ai.LIBELLE || ' ' || ai.COULEUR || ' ' || ai.TAILLE AS libellecomposant,
    ai.COULEUR,
    ai.TAILLE,
    ai.codebarre,
    ai.REFERENCE,
    ai.codegros,
    ai.pvgros,
    u.VAL AS UNITELIB,
    CONCAT(CONCAT(ai.libelle, ' - '), u.val) AS designation,
    ai.PV * (1 + ai.TVA / 100) AS PVTVA,
    rfmv.remise,
    (ai.PV * (1 + ai.TVA / 100)) * (1 - NVL(rfmv.remise,0)/100) AS pvRemise,
    rfmv.IDCATEGORIECLIENT,
    rfmv.IDPOINT,
    rfmv.id AS idRemiseFille,
    rfmv.idRemise,
    rfmv.nom AS RemiseNom,
    rfmv.daty AS datyRemise,
    rfmv.DATEDEBUT AS datedebutRemise,
    rfmv.DATEFIN AS datefinRemise,
    ai.TYPESTOCK

FROM AS_INGREDIENTS ai

         LEFT JOIN AS_RECETTE ar
                   ON ar.IDPRODUITS = ai.ID

         LEFT JOIN AS_INGREDIENTS cps
                   ON cps.ID = ar.IDINGREDIENTS

         LEFT JOIN AS_UNITE u
                   ON ai.unite = u.id

         LEFT JOIN remiseFilleMereVise rfmv
                   ON (
                       (rfmv.idproduit IS NOT NULL
                           AND rfmv.idproduit = ai.id)

                           OR (rfmv.idproduit IS NULL
                           AND rfmv.CATEGORIEPRODUIT IS NOT NULL
                           AND rfmv.CATEGORIEPRODUIT = ai.CATEGORIEINGREDIENT)

                           OR (rfmv.idproduit IS NULL
                           AND rfmv.CATEGORIEPRODUIT IS NULL)
                       )

WHERE ai.PV != 0
AND ai.ACTIF = 1
GROUP BY
    ai.ID,
    ai.LIBELLE,
    ai.SEUIL,
    ai.UNITE,
    ai.QUANTITEPARPACK,
    ai.PU,
    ai.ACTIF,
    ai.PHOTO,
    ai.CALORIE,
    ai.DURRE,
    ai.COMPOSE,
    ai.CATEGORIEINGREDIENT,
    ai.IDFOURNISSEUR,
    ai.DATY,
    ai.QTELIMITE,
    ai.PV,
    ai.LIBELLEVENTE,
    ai.SEUILMIN,
    ai.SEUILMAX,
    ai.PUACHATUSD,
    ai.PUACHATEURO,
    ai.PUACHATAUTREDEVISE,
    ai.PUVENTEUSD,
    ai.PUVENTEEURO,
    ai.PUVENTEAUTREDEVISE,
    ai.ISVENTE,
    ai.ISACHAT,
    ai.COMPTE_VENTE,
    ai.COMPTE_ACHAT,
    ai.TVA,
    ai.COULEUR,
    ai.TAILLE,
    ai.REFERENCE,
    ai.codebarre,
    u.VAL,
    ai.codegros,
    ai.pvgros,
    rfmv.remise,
    rfmv.IDCATEGORIECLIENT,
    rfmv.IDPOINT,
    rfmv.id,
    rfmv.idRemise,
    rfmv.nom,
    rfmv.daty,
    rfmv.DATEDEBUT,
    rfmv.DATEFIN,
    ai.TYPESTOCK
;