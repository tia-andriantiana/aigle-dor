-- SOCOBISCOMPLET0420.AS_INGREDIENTS_LIB source

CREATE OR REPLACE VIEW AS_INGREDIENTS_LIB  AS
SELECT ing.id,
       ing.LIBELLE,
       ing.PARFUMS,
       ing.SEUIL,
       au.VAL AS unite,
       ing.QUANTITEPARPACK,
       ing.pu,
       ing.ACTIF,
       ing.PHOTO,
       ing.CALORIE,
       ing.DURRE,
       ing.COMPOSE,
       CAST(
               CASE
                   WHEN ing.COMPOSE = 1 THEN 'OUI'
                   WHEN ing.COMPOSE = 0 THEN 'NON'
                   END AS VARCHAR2(100)
       ) AS COMPOSELIB,
       cating.id AS IDCATEGORIEINGREDIENT ,
       catIng.VAL AS CATEGORIEINGREDIENT,
       ing.CATEGORIEINGREDIENT AS idcategorie,
       ing.idfournisseur,
       ing.daty,
       catIng.desce as bienOuServ,
       CASE WHEN ing.id IN (SELECT idproduit FROM INDISPONIBILITE i )
                THEN 'INDISPONIBLE'
            WHEN ing.id NOT IN (SELECT idproduit FROM INDISPONIBILITE i )
                THEN 'DISPONIBLE'
           END AS etatlib,
       ing.COMPTE_VENTE,
       ing.COMPTE_ACHAT,
       ing.pv,
       ing.tva,
       ing.TYPESTOCK,
       ing.UNITE as idunite,
       ing.REFPOST,
       ing.REFQUALIFICATION ,
       p.VAL AS REFPOSTLIB,
       qp.VAL AS REFQUALIFICATIONLIB,
       fp.val AS idfamilleLib,
       ing.typeProduit,
       tp.idligne,
       ing.compte_stock,
       ing.compte_sortie_stock,
       f.nom as idFournisseurLib
FROM as_ingredients ing
         LEFT JOIN AS_UNITE AU ON ing.UNITE = AU.ID
         LEFT JOIN CATEGORIEINGREDIENTLIB catIng
                   ON catIng.id = ing.CATEGORIEINGREDIENT
         LEFT JOIN POSTE p ON p.id = ing.REFPOST
         LEFT JOIN FAMILLEPRODUIT fp ON fp.id=ing.idfamille
         LEFT JOIN QUALIFICATION_PAIE qp ON qp.id = ing.REFQUALIFICATION
         LEFT JOIN TYPE_PRODUIT tp ON tp.ID=ing.typeProduit
        LEFT JOIN FOURNISSEUR f ON ing.idFournisseur = f.id;


UPDATE menudynamique SET libelle = 'Produit' WHERE id = 'MNDN00001';


-- SOCOBISCOMPLET0420.STAT_DEPENSE_CAT source


CREATE OR REPLACE VIEW STAT_DEPENSE_CAT AS
SELECT
    ffc.daty,
    ai.CATEGORIEINGREDIENT ,
    cat.val AS CATEGORIEINGREDIENTLIB,
    EXTRACT(MONTH FROM ffc.daty) as MOISINT,
    TRIM(TO_CHAR(ffc.daty, 'Month', 'NLS_DATE_LANGUAGE=FRENCH')) AS MOISSTRING,
    EXTRACT(YEAR FROM ffc.daty) as ANNEE,
    sum(ffc.montant) / 1000000 AS depense

FROM FACTUREFOURNISSEURFILLECPL  ffc
         JOIN FACTUREFOURNISSEUR fc on fc.id = ffc.idfacturefournisseur and etat >= 11
         JOIN AS_INGREDIENTS ai ON ffc.IDPRODUIT = ai.id
         LEFT JOIN CATEGORIEINGREDIENT cat ON ai.CATEGORIEINGREDIENT  = cat.id
GROUP BY
    ai.CATEGORIEINGREDIENT,
    ffc.daty,
    cat.val
;