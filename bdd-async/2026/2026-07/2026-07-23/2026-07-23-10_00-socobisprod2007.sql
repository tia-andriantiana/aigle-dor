
CREATE OR REPLACE  VIEW V_INVENTAIREFILLECPL (ID, IDINVENTAIRE, IDPRODUIT, IDPRODUITLIB, EXPLICATION, QUANTITETHEORIQUE, QUANTITE, LIBELLEEXTACTE, PU, ECART, DATEINV, MONTANTTHEORIQUE, MONTANTREELLE, ECARTMONTANT, CATEGORIEINGREDIENT,MVTSRC) AS 
  SELECT
    i.ID AS ID,
    i.IDINVENTAIRE AS IDINVENTAIRE,
    i.IDPRODUIT AS IDPRODUIT,
    p.LIBELLE AS IDPRODUITLIB,
    i.EXPLICATION AS EXPLICATION,
 
    CAST(
            NVL(i.QUANTITETHEORIQUE, 0)
        AS NUMBER(30, 6)
    ) AS QUANTITETHEORIQUE,
 
    CAST(
            NVL(i.QUANTITE, 0)
        AS NUMBER(30, 6)
    ) AS QUANTITE,
 
    p.LIBELLEEXTACTE AS LIBELLEEXTACTE,
 
    CAST(
            NVL(i.PU, 0)
        AS NUMBER(30, 6)
    ) AS PU,
 
    CAST(
            NVL(i.QUANTITE, 0)
                - NVL(i.QUANTITETHEORIQUE, 0)
        AS NUMBER(30, 6)
    ) AS ECART,
 
    iv.DATY AS DATEINV,
 
    CAST(
            NVL(i.PU, 0)
                * NVL(i.QUANTITETHEORIQUE, 0)
        AS NUMBER(30, 6)
    ) AS MONTANTTHEORIQUE,
 
    CAST(
            NVL(i.PU, 0)
                * NVL(i.QUANTITE, 0)
        AS NUMBER(30, 6)
    ) AS MONTANTREELLE,
 
    CAST(
            (
                NVL(i.PU, 0)
                    * NVL(i.QUANTITE, 0)
                )
                -
            (
                NVL(i.PU, 0)
                    * NVL(i.QUANTITETHEORIQUE, 0)
                )
        AS NUMBER(30, 6)
    ) AS ECARTMONTANT,
 
    p.CATEGORIEINGREDIENT AS CATEGORIEINGREDIENT,
    i.mvtsrc
 
FROM INVENTAIREFILLE i
 
         LEFT JOIN INVENTAIRE iv
                   ON iv.ID = i.IDINVENTAIRE
 
         LEFT JOIN AS_INGREDIENTS p
                   ON p.ID = i.IDPRODUIT
 
WHERE iv.ETAT >= 11;