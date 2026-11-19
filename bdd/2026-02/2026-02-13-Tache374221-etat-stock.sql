
CREATE OR REPLACE VIEW V_ETATSTOCK_ENTREE AS 
  SELECT DISTINCT
    ve.id,
    ai.id AS idproduit,
    ai.libelle AS idproduitlib,
    ai.categorieingredient,
    c.val AS idtypeproduitlib,
    ve.idmagasin,
    m.val AS idmagasinlib,
    ve.quantite,
    CAST(ve.entree AS NUMBER(30,2)) AS entree,
    CAST(ve.sortie AS NUMBER(30,2)) AS sortie,
    CAST(ve.reste AS NUMBER(30,2)) AS reste,
    ai.unite,
    u.val AS idunitelib,
    ve.pu,
    ve.daty,
    ve.idfournisseur,
    f.NOM AS idfournisseurlib,
    ve.dateAchat,
    CAST(NVL(ai.PV, 0) AS NUMBER(30, 5)) AS PUVENTE,
    m.IDPOINT,
    m.IDTYPEMAGASIN,
    ai.SEUILMIN,
    ai.SEUILMAX,
    MONTANTENTREE,
    MONTANTSORTIE,
    MONTANTRESTE
  FROM (
      SELECT
          x.*,
           COALESCE(b.idfournisseur, invf.idfournisseur, bb.IDFOURNISSEUR,trs.idfournisseur) AS idfournisseur,
          f.DATY as dateAchat

      FROM (
          SELECT
              ID,
              IDMVTSTOCK,
              IDPRODUIT,
              ENTREE,
              SORTIE,
              IDVENTEDETAIL,
              IDTRANSFERTDETAIL,
              PU,
              MVTSRC,
              DATY,
              RESTE,
              QUANTITE,
              IDMAGASIN,
              IDINVENTAIREFILLE,
              MONTANTENTREE,
              MONTANTSORTIE,
              MONTANTRESTE
          FROM (
              SELECT
                mf.ID,
                mf.IDMVTSTOCK,
                mf.IDPRODUIT,
                nvl(mf.ENTREE,0)+nvl(s.ENTREE,0) as entree,
                s.SORTIE,
                mf.IDVENTEDETAIL,
                mf.IDTRANSFERTDETAIL,
                mf.PU,
                mf.MVTSRC,
                ms.DATY,
                NVL(mf.ENTREE, 0) - NVL(s.SORTIE, 0)  + NVL(s.ENTREE, 0) AS RESTE,
                NVL(mf.ENTREE, 0) - NVL(s.SORTIE, 0) +  NVL(s.ENTREE, 0) AS QUANTITE,
                ms.IDMAGASIN,
                mf.idinventairefille,
                cast((mf.PU*mf.ENTREE) as number(30,5)) AS MONTANTENTREE,
                cast((mf.PU*s.SORTIE) as number(30,5)) AS MONTANTSORTIE,
                CAST(NVL(mf.ENTREE, 0) - NVL(s.SORTIE, 0)  + NVL(s.ENTREE, 0) AS NUMBER(30,2)) * mf.PU AS MONTANTRESTE
    
              FROM MVTSTOCKFILLE mf
              LEFT JOIN MVTSTOCK ms ON ms.id = mf.IDMVTSTOCK
              LEFT JOIN (
                  SELECT mf2.MVTSRC, SUM(mf2.SORTIE) AS SORTIE,SUM(mf2.ENTREE) AS ENTREE
                  FROM MVTSTOCKFILLE mf2
                  LEFT JOIN MVTSTOCK ms2 ON ms2.id = mf2.IDMVTSTOCK
                  WHERE ms2.ETAT >= 11
                    AND mf2.MVTSRC IS NOT NULL
                  GROUP BY mf2.MVTSRC
              ) s ON s.MVTSRC = mf.id
              WHERE mf.ENTREE > 0 and (mf.MVTSRC is null or mf.MVTSRC=mf.id)
                AND ms.ETAT >= 11
          )
      ) x
      LEFT JOIN MVTSTOCK ms  ON ms.id = x.IDMVTSTOCK
      LEFT JOIN AS_BONDELIVRAISON b ON b.ID = ms.IDOBJET
      LEFT JOIN AS_BONDELIVRAISON bb ON b.ID = ms.IDTRANSFERT
      LEFT JOIN FACTUREFOURNISSEUR f on f.id=b.IDFACTUREFOURNISSEUR
      LEFT JOIN INVENTAIREFILLE invf ON invf.id = x.IDINVENTAIREFILLE
      LEFT JOIN TRANSFERTSTOCKDETAILS trs ON trs.id = x.IDTRANSFERTDETAIL
 WHERE b.IDFOURNISSEUR IS NOT NULL OR invf.IDFOURNISSEUR IS NOT NULL or bb.IDFOURNISSEUR IS NOT NULL OR trs.idfournisseur is not null

  ) ve

  LEFT JOIN AS_INGREDIENTS ai ON ai.id = ve.IDPRODUIT
  LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id
  LEFT JOIN MAGASINPOINT m ON ve.IDMAGASIN = m.id
  LEFT JOIN AS_UNITE u ON ai.UNITE = u.id

  LEFT JOIN FOURNISSEUR f ON f.ID = ve.idfournisseur

  WHERE ve.PU > 0;

create or replace view V_ETATSTOCK_ING as 
SELECT 
    ve.idproduit as id ,
    ve.idproduitlib,
    ve.categorieingredient,
    ve.idtypeproduitlib,
    ve.idmagasin,
    ve.idmagasinlib,
    TO_DATE('01-01-2001', 'DD-MM-YYYY') AS dateDernierMouvement,
    SUM(ve.quantite) AS quantite,
    SUM(ve.entree) AS entree,
    SUM(ve.sortie) AS sortie,
    SUM(ve.reste) AS reste,
    ve.unite,
    ve.idunitelib,
    ve.puvente,
    ve.IDPOINT,
    ve.IDTYPEMAGASIN,
    ve.SEUILMIN,
    ve.SEUILMAX,
    SUM(ve.PU * ve.MONTANTENTREE) AS MONTANTENTREE,
    SUM(ve.PU * ve.MONTANTSORTIE) AS MONTANTSORTIE,
    ve.PU,
    SUM(ve.PU * ve.MONTANTRESTE) AS MONTANTRESTE
FROM V_ETATSTOCK_ENTREE ve
WHERE ve.PU > 0
GROUP BY 
    ve.idproduit,
    ve.idproduitlib,
    ve.categorieingredient,
    ve.idtypeproduitlib,
    ve.idmagasin,
    ve.idmagasinlib,
    ve.unite,
    ve.idunitelib,
    ve.puvente,
    ve.IDPOINT,
    ve.IDTYPEMAGASIN,
    ve.SEUILMIN,
    ve.SEUILMAX,
    ve.PU
ORDER BY ve.idproduit, ve.PU;
