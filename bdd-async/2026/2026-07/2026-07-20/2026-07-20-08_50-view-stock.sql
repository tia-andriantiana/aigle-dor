    create or replace view MVTSTOCKFILLEVRAISOURCE as
select ms.ID, ms.IDMVTSTOCK, ms.IDPRODUIT, ms.IDVENTEDETAIL, ms.IDTRANSFERTDETAIL,
       case when  (me.MVTSRC is not null and ms.SORTIE>0)
           then me.MVTSRC
           else ms.MVTSRC
        end as mvtsrc
     ,me.MVTSRC as source2
     , ms.DESIGNATION, ms.ENTREE, ms.SORTIE, ms.PU, ms.RESTE, ms.IDINVENTAIREFILLE from MVTSTOCKFILLE ms left  join
(select m.id, m.idmvtstock, m.idproduit, m.idventedetail, m.idtransfertdetail, m.mvtsrc, m.designation, m.entree, m.sortie, m.pu, m.reste, m.idinventairefille
 from MVTSTOCKFILLE m
where m.entree>0 and m.MVTSRC is not null) me
on me.ID=ms.MVTSRC
left join MVTSTOCK m on m.id=ms.IDMVTSTOCK
where m.IDTYPEMVSTOCK!='TPMVST000023';

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
           s.ENTREE as entree,
           s.SORTIE,
           m.IDVENTEDETAIL,
           m.IDTRANSFERTDETAIL,
           m.PU,
           m.MVTSRC,
           mp.DATY,
           NVL(s.ENTREE, 0) - NVL(s.SORTIE, 0) + NVL(s.invquantite, 0)  AS RESTE,
           NVL(s.ENTREE, 0) - NVL(s.SORTIE, 0) + NVL(s.invquantite, 0) AS QUANTITE,
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
    (NVL(inv.invquantite, 0) + NVL(mvt.ENTREE, 0) - NVL(mvt.SORTIE, 0)) AS STOCK_FINAL
FROM (
    SELECT
        invf.QUANTITE AS invquantite,
        invf.IDPRODUIT AS invidproduit,
        invf.MVTSRC AS invmvtsrc,
        im.daty AS invdaty,
        im.IDMAGASIN AS invIdMagasin
    FROM INVENTAIREFILLE invF
    LEFT JOIN inventaire im ON im.ID = invf.IDINVENTAIRE
    WHERE im.ETAT >= 11
      AND im.daty = (
          SELECT MAX(im2.daty)
          FROM INVENTAIREFILLE invf2
          LEFT JOIN inventaire im2 ON im2.id = invf2.IDINVENTAIRE
          WHERE im2.ETAT >= 11
            AND invf2.IDPRODUIT = invf.IDPRODUIT
            AND invf2.MVTSRC = invf.MVTSRC
            AND im2.IDMAGASIN = im.IDMAGASIN
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
        FROM INVENTAIREFILLE invf3
        LEFT JOIN INVENTAIRE im3 ON im3.id = invf3.IDINVENTAIRE
        WHERE im3.ETAT >= 11
        GROUP BY invf3.IDPRODUIT, invf3.MVTSRC, im3.IDMAGASIN
    ) inv_ref ON inv_ref.IDPRODUIT = m.IDPRODUIT
             AND inv_ref.MVTSRC = m.MVTSRC
             AND inv_ref.IDMAGASIN = mp.IDMAGASIN
    WHERE mp.ETAT >= 11
      AND mp.DATY > inv_ref.max_invdaty
    GROUP BY m.MVTSRC, mp.IDMAGASIN, m.IDPRODUIT
) mvt
  ON mvt.IDPRODUIT = inv.invidproduit
 AND mvt.MVTSRC = inv.invmvtsrc
 AND mvt.IDMAGASIN = inv.invIdMagasin
       ) s ON s.MVTSRC = m.id and s.IDMAGASIN=mp.IDMAGASIN
       WHERE  m.ENTREE > 0 --and m.MVTSRC IS NULL
         AND mp.ETAT >= 11
) ve
LEFT JOIN AS_INGREDIENTS ai ON ai.id = ve.IDPRODUIT
LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id
LEFT JOIN MAGASINPOINT m ON ve.IDMAGASIN = m.id
LEFT JOIN AS_UNITE u ON ai.UNITE = u.id
WHERE
    ve.PU > 0
  and ve.reste !=0
;

create or replace view v_etatstock_ing as
SELECT
    --'invdaty' as invdaty,
    cast(sum(invquantite) as number(30,2)) as invquantite,
    '' as id,
   ai.id AS IDPRODUIT,
   ai.LIBELLE AS idproduitlib,
   ai.CATEGORIEINGREDIENT,
   c.VAL AS idtypeproduitlib,
   ve.IDMAGASIN, ai.typeStock,
   m.VAL AS idmagasinlib,
   sum(ve.QUANTITE) as quantite,
   CAST(sum(ve.ENTREE) AS NUMBER(30,2)) AS ENTREE,
   CAST(sum(ve.SORTIE) AS NUMBER(30,2)) AS SORTIE,
   CAST(sum(ve.RESTE) AS NUMBER(30,2)) AS RESTE,
   cast(sum(ve.reste)* avg(ve.pu) as number(30,2)) as montantReste,
   ai.UNITE,
   u.VAL AS idunitelib,
   avg(ve.PU) as pu,
   max(ve.DATY) as daty,
   '' as IDFOURNISSEUR,
   '' as IDFOURNISSEURLIB
FROM (
       SELECT
            s.invdaty,
            s.invquantite,
           m.ID,
           m.IDMVTSTOCK,
           m.IDPRODUIT,
           s.ENTREE as entree,
           s.SORTIE,
           m.IDVENTEDETAIL,
           m.IDTRANSFERTDETAIL,
           m.PU,
           m.MVTSRC,
           mp.DATY,
           NVL(s.ENTREE, 0) - NVL(s.SORTIE, 0) + NVL(s.invquantite, 0)  AS RESTE,
           NVL(s.ENTREE, 0) - NVL(s.SORTIE, 0) + NVL(s.invquantite, 0) AS QUANTITE,
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
    (NVL(inv.invquantite, 0) + NVL(mvt.ENTREE, 0) - NVL(mvt.SORTIE, 0)) AS STOCK_FINAL
FROM (
    SELECT
        invf.QUANTITE AS invquantite,
        invf.IDPRODUIT AS invidproduit,
        invf.MVTSRC AS invmvtsrc,
        im.daty AS invdaty,
        im.IDMAGASIN AS invIdMagasin
    FROM INVENTAIREFILLE invF
    LEFT JOIN inventaire im ON im.ID = invf.IDINVENTAIRE
    WHERE im.ETAT >= 11
      AND im.daty = (
          SELECT MAX(im2.daty)
          FROM INVENTAIREFILLE invf2
          LEFT JOIN inventaire im2 ON im2.id = invf2.IDINVENTAIRE
          WHERE im2.ETAT >= 11
            AND invf2.IDPRODUIT = invf.IDPRODUIT
            AND invf2.MVTSRC = invf.MVTSRC
            AND im2.IDMAGASIN = im.IDMAGASIN
            --AND im2.daty <= TO_DATE('18/07/2026', 'DD-MM-YYYY')
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
        FROM INVENTAIREFILLE invf3
        LEFT JOIN INVENTAIRE im3 ON im3.id = invf3.IDINVENTAIRE
        WHERE im3.ETAT >= 11
         -- AND im3.DATY <= TO_DATE('18/07/2026', 'DD-MM-YYYY')
        GROUP BY invf3.IDPRODUIT, invf3.MVTSRC, im3.IDMAGASIN
    ) inv_ref ON inv_ref.IDPRODUIT = m.IDPRODUIT
             AND inv_ref.MVTSRC = m.MVTSRC
             AND inv_ref.IDMAGASIN = mp.IDMAGASIN
    WHERE mp.ETAT >= 11
      --AND mp.DATY <= TO_DATE('18/07/2026', 'DD-MM-YYYY')
      AND mp.DATY > inv_ref.max_invdaty
    GROUP BY m.MVTSRC, mp.IDMAGASIN, m.IDPRODUIT
) mvt
  ON mvt.IDPRODUIT = inv.invidproduit
 AND mvt.MVTSRC = inv.invmvtsrc
 AND mvt.IDMAGASIN = inv.invIdMagasin
       ) s ON s.MVTSRC = m.id and s.IDMAGASIN=mp.IDMAGASIN
       WHERE  m.ENTREE > 0 --and m.MVTSRC IS NULL
         AND mp.ETAT >= 11
         --AND mp.DATY <= TO_DATE('18/07/2026', 'DD-MM-YYYY')
) ve
LEFT JOIN AS_INGREDIENTS ai ON ai.id = ve.IDPRODUIT
LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id
LEFT JOIN MAGASINPOINT m ON ve.IDMAGASIN = m.id
LEFT JOIN AS_UNITE u ON ai.UNITE = u.id
WHERE
    ve.PU > 0
  and ve.reste !=0 group by ai.id, ai.LIBELLE, ai.CATEGORIEINGREDIENT, c.VAL, ve.IDMAGASIN, ai.typeStock, m.VAL, ai.UNITE, u.VAL;