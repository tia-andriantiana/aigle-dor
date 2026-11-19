ALTER TABLE As_INGREDIENTS ADD compte_stock VARCHAR(50);
ALTER TABLE As_INGREDIENTS ADD compte_sortie_stock VARCHAR(50);


create or replace view AS_INGREDIENTS_LIB as
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
       ing.compte_sortie_stock

FROM as_ingredients ing
         LEFT JOIN AS_UNITE AU ON ing.UNITE = AU.ID
         LEFT JOIN CATEGORIEINGREDIENTLIB catIng
                   ON catIng.id = ing.CATEGORIEINGREDIENT
         LEFT JOIN POSTE p ON p.id = ing.REFPOST
         LEFT JOIN FAMILLEPRODUIT fp ON fp.id=ing.idfamille
         LEFT JOIN QUALIFICATION_PAIE qp ON qp.id = ing.REFQUALIFICATION
         LEFT JOIN TYPE_PRODUIT tp ON tp.ID=ing.typeProduit;


CREATE OR REPLACE VIEW MvtStockFilleGrp AS
SELECT
    f.IDMVTSTOCK,
    SUM(f.ENTREE * f.PU) AS entree,
    SUM(f.SORTIE * f.PU) AS SORTIE,
    ing.compte_stock,
    compte_sortie_stock
FROM MVTSTOCKFILLE f
         LEFT JOIN AS_INGREDIENTS ing ON ing.ID = f.IDPRODUIT
GROUP BY f.IDMVTSTOCK, ing.compte_stock,compte_sortie_stock;

update As_INGREDIENTS set  compte_sortie_stock = '603110',  compte_stock= '311000' where 1 >0;