create or replace view V_ETATSTOCK_ENTREE_STANDARD as
SELECT
    invdaty,
    cast(invquantite as number(30,2)) as invquantite,
   ve.id,
   ai.id AS IDPRODUIT,
   ai.LIBELLE AS idproduitlib,
   ai.CATEGORIEINGREDIENT,
   c.VAL AS idtypeproduitlib,
   ve.IDMAGASIN, ai.typeStock,
   m.VAL AS idmagasinlib,
   ve.QUANTITE,
   CAST(ve.ENTREE AS NUMBER(30,2)) AS ENTREE,
   CAST(ve.SORTIE AS NUMBER(30,2)) AS SORTIE,
   CAST(ve.RESTE AS NUMBER(30,2)) AS RESTE,
   cast(ve.reste*ve.pu as number(30,2)) as montantReste,
   ai.UNITE,
   u.VAL AS idunitelib,
   ve.PU,
   ve.DATY,
   ve.IDFOURNISSEUR,
   ve.IDFOURNISSEURLIB
FROM (
       SELECT
            s.invdaty,
            s.invquantite,
           m.ID,
           m.IDMVTSTOCK,
           m.IDPRODUIT,
           case when s.invFid like 'invvidef%'
           then m.ENTREE
           else s.entree end
               as entree,
           s.SORTIE,
           m.IDVENTEDETAIL,
           m.IDTRANSFERTDETAIL,
           m.PU,
           m.MVTSRC,
           mp.DATY,
           case when s.invFid like 'invvidef%'
           then NVL(m.ENTREE, 0) - NVL(s.SORTIE, 0) + NVL(s.invquantite, 0)
           else NVL(s.ENTREE, 0) - NVL(s.SORTIE, 0) + NVL(s.invquantite, 0)
           end    AS RESTE,
           case when s.invFid like 'invvidef%'
           then NVL(m.ENTREE, 0) - NVL(s.SORTIE, 0) + NVL(s.invquantite, 0)
           else NVL(s.ENTREE, 0) - NVL(s.SORTIE, 0) + NVL(s.invquantite, 0)
           end AS QUANTITE,
           mp.IDMAGASIN,
           b.IDFOURNISSEUR,
           b.IDFOURNISSEURLIB
       FROM mvtSTockFilleVraiSource m
       LEFT JOIN MVTSTOCK mp ON mp.id = m.IDMVTSTOCK
       LEFT JOIN AS_BONDELIVRAISON_LIB b ON b.ID = mp.IDOBJET

       LEFT JOIN (
           SELECT
    inv.invidproduit AS IDPRODUIT,
    inv.invmvtsrc AS MVTSRC,
    inv.invIdMagasin AS IDMAGASIN,
    inv.invquantite,
    inv.invdaty,
    NVL(mvt.SORTIE, 0) AS SORTIE,
    NVL(mvt.ENTREE, 0) AS ENTREE,
    inv.invFid,
    (NVL(inv.invquantite, 0) + NVL(mvt.ENTREE, 0) - NVL(mvt.SORTIE, 0)) AS STOCK_FINAL
FROM (
    SELECT
        invf.QUANTITE AS invquantite,
        invf.IDPRODUIT AS invidproduit,
        invf.MVTSRC AS invmvtsrc,
        im.daty AS invdaty,
        im.IDMAGASIN AS invIdMagasin,
        invf.id as invFid
    FROM inventaireFilleAvecVide invF
    LEFT JOIN inventaireAvecVide im ON im.ID = invf.IDINVENTAIRE
    WHERE im.ETAT >= 11
      AND im.daty = (
          SELECT MAX(im2.daty)
          FROM inventaireFilleAvecVide invf2
          LEFT JOIN inventaireAvecVide im2 ON im2.id = invf2.IDINVENTAIRE
          WHERE im2.ETAT >= 11
            AND invf2.IDPRODUIT = invf.IDPRODUIT
            AND invf2.MVTSRC = invf.MVTSRC
            AND im2.IDMAGASIN = im.IDMAGASIN
          --  AND im2.daty <= TO_DATE('20/07/2026', 'DD-MM-YYYY')
      )
) inv

LEFT JOIN (
    SELECT
        m.MVTSRC,
        mp.IDMAGASIN,
        m.IDPRODUIT,
        SUM(m.SORTIE) AS SORTIE,
        SUM(m.ENTREE) AS ENTREE
    FROM mvtSTockFilleVraiSource m
    JOIN MVTSTOCK mp ON mp.id = m.IDMVTSTOCK
    LEFT JOIN (
        SELECT
            invf3.IDPRODUIT,
            invf3.MVTSRC,
            im3.IDMAGASIN,
            MAX(im3.DATY) AS max_invdaty
        FROM inventaireFilleAvecVide invf3
        LEFT JOIN inventaireAvecVide im3 ON im3.id = invf3.IDINVENTAIRE
        WHERE im3.ETAT >= 11
        --  AND im3.DATY <= TO_DATE('20/07/2026', 'DD-MM-YYYY')
        GROUP BY invf3.IDPRODUIT, invf3.MVTSRC, im3.IDMAGASIN
    ) inv_ref ON inv_ref.IDPRODUIT = m.IDPRODUIT
             AND inv_ref.MVTSRC = m.MVTSRC
             AND inv_ref.IDMAGASIN = mp.IDMAGASIN
    WHERE mp.ETAT >= 11
      --AND mp.DATY <= TO_DATE('20/07/2026', 'DD-MM-YYYY')
      AND mp.DATY > inv_ref.max_invdaty
    and m.IDPRODUIT='ING000T0108'
    GROUP BY m.MVTSRC, mp.IDMAGASIN, m.IDPRODUIT
) mvt
  ON mvt.IDPRODUIT = inv.invidproduit
 AND mvt.MVTSRC = inv.invmvtsrc
 AND mvt.IDMAGASIN = inv.invIdMagasin
       ) s ON s.MVTSRC = m.id and s.IDMAGASIN=mp.IDMAGASIN
       WHERE  m.ENTREE > 0 --and m.MVTSRC IS NULL
         AND mp.ETAT >= 11
         --AND mp.DATY <= TO_DATE('20/07/2026', 'DD-MM-YYYY')
) ve
LEFT JOIN AS_INGREDIENTS ai ON ai.id = ve.IDPRODUIT
LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id
LEFT JOIN MAGASINPOINT m ON ve.IDMAGASIN = m.id
LEFT JOIN AS_UNITE u ON ai.UNITE = u.id
WHERE
    ve.PU > 0
  and ve.reste !=0;