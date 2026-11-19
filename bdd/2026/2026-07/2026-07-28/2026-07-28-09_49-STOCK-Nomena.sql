CREATE OR REPLACE VIEW V_ETATSTOCK_ING AS
WITH max_inventaire AS (
    SELECT
        invff.idproduit,
        imeref.idmagasin,
        MAX(imeref.DATY) AS max_daty,
        MAX(invff.QUANTITE)
            KEEP (DENSE_RANK LAST ORDER BY imeref.DATY) AS qte_max_daty,
        MAX(invff.pu)
            KEEP (DENSE_RANK LAST ORDER BY imeref.DATY) AS pu_max_daty
    FROM INVENTAIREFILLE invff
             LEFT JOIN inventaireDateHeure imeref
                       ON imeref.ID = invff.IDINVENTAIRE
    WHERE imeref.ETAT >= 11
    GROUP BY
        invff.idproduit,
        imeref.idmagasin
),
     somme_precalc AS (
         SELECT
             mff.idproduit AS idproduit,
             meref.idmagasin AS idmagasin,

             NVL(
                     SUM(
                             CASE
                                 WHEN meref.DATY > NVL(
                                         inv.max_daty,
                                         TO_DATE('01/01/2025', 'DD/MM/YYYY')
                                                   )
                                     THEN mff.ENTREE
                                 ELSE 0
                                 END
                     ),
                     0
             ) AS entree,

             NVL(
                     SUM(
                             CASE
                                 WHEN meref.DATY > NVL(
                                         inv.max_daty,
                                         TO_DATE('01/01/2025', 'DD/MM/YYYY')
                                                   )
                                     THEN mff.SORTIE
                                 ELSE 0
                                 END
                     ),
                     0
             ) AS sortie,

             ai.LIBELLE AS idproduitlib,
             ai.CATEGORIEINGREDIENT AS CATEGORIEINGREDIENT,
             ai.UNITE AS unite,
             ai.TYPESTOCK AS typestock,
             u.VAL AS idunitelib,
             c.VAL AS idtypeproduitlib,
             AVG(mff.PU) AS pu,

             NULL AS IDFOURNISSEUR,
             NULL AS IDFOURNISSEURLIB,

             m.VAL AS idmagasinlib,
             MAX(inv.max_daty) AS invdaty,
             NVL(MAX(inv.qte_max_daty), 0) AS invquantite,

             NVL(
                     SUM(
                             CASE
                                 WHEN meref.DATY > NVL(
                                         inv.max_daty,
                                         TO_DATE('01/01/2025', 'DD/MM/YYYY')
                                                   )
                                     THEN mff.ENTREE * mff.pu
                                 ELSE 0
                                 END
                     ),
                     0
             ) AS montantEntree,

             NVL(
                     SUM(
                             CASE
                                 WHEN meref.DATY > NVL(
                                         inv.max_daty,
                                         TO_DATE('01/01/2025', 'DD/MM/YYYY')
                                                   )
                                     THEN mff.SORTIE * mff.pu
                                 ELSE 0
                                 END
                     ),
                     0
             ) AS montantSortie,

             NVL(
                     AVG(inv.pu_max_daty * inv.qte_max_daty),
                     0
             ) AS montantInv

         FROM MVTSTOCKFILLE mff
                  LEFT JOIN mvtStockDateHeure meref
                            ON meref.ID = mff.IDMVTSTOCK
                  LEFT JOIN max_inventaire inv
                            ON inv.idproduit = mff.idproduit
                                AND inv.idmagasin = meref.idmagasin
                  LEFT JOIN AS_INGREDIENTS ai
                            ON ai.id = mff.IDPRODUIT
                  LEFT JOIN CATEGORIEINGREDIENT c
                            ON ai.CATEGORIEINGREDIENT = c.id
                  LEFT JOIN MAGASINPOINT m
                            ON meref.IDMAGASIN = m.id
                  LEFT JOIN AS_UNITE u
                            ON ai.UNITE = u.id
         WHERE meref.ETAT >= 11
           AND meref.IDTYPEMVSTOCK != 'TPMVST000023'
         GROUP BY
             mff.idproduit,
             meref.idmagasin,
             ai.LIBELLE,
             ai.CATEGORIEINGREDIENT,
             ai.UNITE,
             ai.TYPESTOCK,
             u.VAL,
             c.VAL,
             m.VAL
     )
SELECT
    NULL AS ID,
    NULL AS DATY,
    CAST(invquantite AS NUMBER(30, 2)) AS invquantite,
    CAST(entree AS NUMBER(30, 2)) AS entree,
    CAST(sortie AS NUMBER(30, 2)) AS sortie,

    CAST(
            invquantite + entree - sortie
        AS NUMBER(30, 2)
    ) AS reste,

    CAST(
            invquantite + entree - sortie
        AS NUMBER(30, 2)
    ) AS quantite,

    CAST(
            montantInv + montantEntree - montantSortie
        AS NUMBER(30, 2)
    ) AS montantreste,

    CAST(
            (montantInv + montantEntree - montantSortie)
                / (invquantite + entree - sortie)
        AS NUMBER(30, 2)
    ) AS pu,

    idproduitlib,
    CATEGORIEINGREDIENT,
    UNITE,
    TYPESTOCK,
    idunitelib,
    idtypeproduitlib,
    IDFOURNISSEUR,
    IDFOURNISSEURLIB,
    IDPRODUIT,
    IDMAGASIN,
    idmagasinlib,
    invdaty,

    idproduit || ' ' ||
    idproduitlib || ' ' ||
    idmagasin || ' ' ||
    idmagasinlib || ' ' ||
    CATEGORIEINGREDIENT || ' ' ||
    idtypeproduitlib || ' ' ||
    UNITE || ' ' ||
    idunitelib AS motsclesss

FROM somme_precalc
WHERE invquantite + entree - sortie != 0;