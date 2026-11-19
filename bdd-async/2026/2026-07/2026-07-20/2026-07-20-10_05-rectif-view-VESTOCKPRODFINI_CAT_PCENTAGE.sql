CREATE OR REPLACE  VIEW "VESTOCKPRODFINI_CAT_PCENTAGE" ("ID", "IDTYPEPRODUITLIB", "QUANTITE", "POURCENTAGE", "DATY", "MONTANTRESTE") AS
  SELECT
    TYPEPRODUIT        AS id,
    typeproduitlib AS idTypeProduitLib ,
    CAST(SUM(quantite) AS NUMBER(30,2))  AS quantite,
    CAST(
            SUM(quantite) * 100.0
                / SUM(SUM(quantite)) OVER ()
        AS NUMBER(10,2))                     AS pourcentage,
    CURRENT_DATE AS DATY,
    CAST(SUM(montantReste) AS NUMBER(30,2))  AS montantReste
FROM V_ETATSTOCK_PROD_FINI2 where TYPEPRODUIT is not null
GROUP BY TYPEPRODUIT, typeproduitlib
;