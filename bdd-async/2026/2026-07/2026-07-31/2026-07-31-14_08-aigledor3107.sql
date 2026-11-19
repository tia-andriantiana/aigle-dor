--Stefan


-- 2026-07-31-10_15-aigledor3107


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

    rfmv.remise,
    ai.PV - (ai.PV * NVL(rfmv.remise, 0) / 100) AS pvRemise,

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

-- 2026-07-31-12_25-aigledor3107
ALTER TABLE MAGASIN2 ADD isVente NUMBER DEFAULT 0;