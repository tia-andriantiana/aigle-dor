create or replace view AS_INGREDIENTS_LIB as
SELECT ing.id,
       ing.LIBELLE,
       ing.PARFUMS,
       CAST(ing.SEUIL AS NUMBER(10,5)) AS SEUIL ,
       au.VAL AS unite,
       CAST(ing.QUANTITEPARPACK AS NUMBER(10,5)) AS QUANTITEPARPACK,
       CAST(ing.pu AS NUMBER(30,5)) AS pu,
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
       CAST(ing.pv AS NUMBER(30,5)) AS pv,
       CAST(ing.tva AS NUMBER(10,5)) AS tva,
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
       f.nom as idFournisseurLib,
       dep.val AS idDepartementLib,
       ing.LIBELLEVENTE,
       eq.QUANTITE as nbpiece,
       tp.val AS typeproduitLib,
       ing.COMPTE_RISTOURNE,
       ing.CODEBARRE,
       ing.REFERENCE
FROM as_ingredients ing
         LEFT JOIN AS_UNITE AU ON ing.UNITE = AU.ID
         LEFT JOIN CATEGORIEINGREDIENTLIB catIng
                   ON catIng.id = ing.CATEGORIEINGREDIENT
         LEFT JOIN POSTE p ON p.id = ing.REFPOST
         LEFT JOIN FAMILLEPRODUIT fp ON fp.id=ing.idfamille
         LEFT JOIN QUALIFICATION_PAIE qp ON qp.id = ing.REFQUALIFICATION
         LEFT JOIN TYPE_PRODUIT tp ON tp.ID=ing.typeProduit
         LEFT JOIN FOURNISSEUR f ON ing.idFournisseur = f.id
         LEFT JOIN departement dep ON dep.id=ing.parfums
         Left join EQUIVALENCEVENTE eq on eq.IDPRODUIT1 = ing.ID;