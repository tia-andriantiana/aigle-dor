-- 2026-07-28-16_12-socobisstandard
 
 
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

    rfmv.DATEFIN AS datefinRemise
 
FROM AS_INGREDIENTS ai
 
         LEFT JOIN AS_RECETTE ar

                   ON ar.IDPRODUITS = ai.ID
 
         LEFT JOIN AS_INGREDIENTS cps

                   ON cps.ID = ar.IDINGREDIENTS
 
         LEFT JOIN AS_UNITE u

                   ON ai.unite = u.id
 
         LEFT JOIN remiseFilleMereVise rfmv

                   ON (

                       rfmv.CATEGORIEPRODUIT = ai.CATEGORIEINGREDIENT

                           OR rfmv.idproduit = ai.id

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

    rfmv.DATEFIN;
 