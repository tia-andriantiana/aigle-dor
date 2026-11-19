create or replace view ST_INGREDIENTSVENTEPOS as
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
    CAST(ai.PV * (1 + ai.TVA / 100) AS NUMBER(30,2)) AS PVTVA,
    CAST(ai.PV * (1 + ai.TVA / 100) AS NUMBER(30,2)) AS MONTANTTTC

FROM AS_INGREDIENTS ai
         LEFT JOIN AS_RECETTE ar
                   ON ar.IDPRODUITS = ai.ID
         LEFT JOIN AS_INGREDIENTS cps
                   ON cps.ID = ar.IDINGREDIENTS
         LEFT JOIN AS_UNITE u
                   ON ai.UNITE = u.ID
         LEFT JOIN V_REFERENCE_COULEUR vrc on vrc.REFERENCECOULEUR = ai.COULEUR
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


create or replace view V_REFCOULEUR_AVECCODE as
SELECT
    c.REFERENCECOULEUR,
    LISTAGG(cc.val , ' - ') WITHIN GROUP (ORDER BY c.REFERENCECOULEUR) || '-' || c.REFERENCECOULEUR AS nomcouleur,
    LISTAGG(cc.desce , ' - ') WITHIN GROUP (ORDER BY c.REFERENCECOULEUR) AS codecouleur
FROM
    COMBINAISONCOULEUR c
    left join couleur cc on c.idcouleur = cc.id

GROUP BY
    c.REFERENCECOULEUR;
