create or replace view V_ETATSTOCK_ENTREE as
SELECT SQ."ID",SQ."IDPRODUIT",SQ."IDPRODUITLIB",SQ."CATEGORIEINGREDIENT",SQ."IDTYPEPRODUITLIB",SQ."IDMAGASIN",SQ."IDMAGASINLIB",CAST(SQ."QUANTITE" AS NUMBER(30,2)) AS quantite,cast(SQ."ENTREE" as number(30,2)) as entree,cast(SQ."SORTIE" as number(30,2)) as sortie,CAST(SQ."RESTE" AS NUMBER(30,2)) AS reste,SQ."UNITE",SQ."IDUNITELIB",SQ."PU",SQ."DATY",SQ."IDFOURNISSEUR",SQ."IDFOURNISSEURLIB",SQ."DATEACHAT",SQ."PUVENTE",SQ."IDPOINT",SQ."IDTYPEMAGASIN",SQ."SEUILMIN",SQ."SEUILMAX",SQ."MONTANTENTREE",SQ."MONTANTSORTIE",SQ."MONTANTRESTE",
  (NVL(TO_CHAR(ID),'') || ' | ' || NVL(TO_CHAR(IDPRODUIT),'') || ' | ' || NVL(TO_CHAR(IDPRODUITLIB),'') || ' | ' || NVL(TO_CHAR(CATEGORIEINGREDIENT),'') || ' | ' || NVL(TO_CHAR(IDTYPEPRODUITLIB),'') || ' | ' || NVL(TO_CHAR(IDMAGASIN),'') || ' | ' || NVL(TO_CHAR(IDMAGASINLIB),'') || ' | ' || NVL(TO_CHAR(QUANTITE),'') || ' | ' || NVL(TO_CHAR(ENTREE),'') || ' | ' || NVL(TO_CHAR(SORTIE),'') || ' | ' || NVL(TO_CHAR(RESTE),'') || ' | ' || NVL(TO_CHAR(UNITE),'') || ' | ' || NVL(TO_CHAR(IDUNITELIB),'') || ' | ' || NVL(TO_CHAR(PU),'') || ' | ' || NVL(TO_CHAR(DATY,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(IDFOURNISSEUR),'') || ' | ' || NVL(TO_CHAR(IDFOURNISSEURLIB),'') || ' | ' || NVL(TO_CHAR(DATEACHAT,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(PUVENTE),'') || ' | ' || NVL(TO_CHAR(IDPOINT),'') || ' | ' || NVL(TO_CHAR(IDTYPEMAGASIN),'') || ' | ' || NVL(TO_CHAR(SEUILMIN),'') || ' | ' || NVL(TO_CHAR(SEUILMAX),'') || ' | ' || NVL(TO_CHAR(MONTANTENTREE),'') || ' | ' || NVL(TO_CHAR(MONTANTSORTIE),'') || ' | ' || NVL(TO_CHAR(MONTANTRESTE),'')) AS MOTSCLESSS
FROM (
  SELECT DISTINCT
    ve.id,
    ai.id AS idproduit,
    ai.libelle AS idproduitlib,
    ai.categorieingredient,
    c.val AS idtypeproduitlib,
    ve.idmagasin,
    m.val AS idmagasinlib,
    CAST(ve.quantite AS NUMBER(30,2)) AS quantite,
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

  WHERE ve.PU > 0 AND CAST(ve.reste AS NUMBER(30,2)) != 0
) SQ


;


create or replace view PREVISION_COMPLET_CPL as
SELECT
             p.ID,
             p.DESIGNATION,
             p.IDCAISSE,
             p.IDCAISSELIB,
             p.IDVENTEDETAIL,
             p.IDVENTE,
             p.IDVENTELIB,
             p.IDVIREMENT,
             p.DEBIT,
             p.CREDIT,
             p.DATY,
             p.ETAT,
             p.IDOP,
             p.IDOPLIB,
             p.IDORIGINE,
             p.IDDEVISE,
             p.IDDEVISELIB,
             p.TAUX,
             p.IDTIERS,
             t.NOM as IDTIERSLIB,
             p.COMPTE,
             NVL(pe.effectifDeb,0) AS effectifDebit,
             NVL(pe.effectifCred,0) AS effectifCredit,
              NVL(pe.effectifDeb,0) - p.debit AS depenseEcart,
             nVL(pe.effectifCred,0) - p.credit AS recetteEcart,
             p.idfacture,
             COALESCE(v.IDVENTE, f.IDFACTUREFOURNISSEUR) AS idfacturemere
         FROM PREVISION_CPL p
                  LEFT JOIN PrevisionAvecMvtCaisse pe ON pe.id = p.id
                  LEFT JOIN VENTE_DETAILS v ON v.id = p.idfacture
                  LEFT JOIN FACTUREFOURNISSEURFILLE f ON f.id = p.idfacture
                  LEFT JOIN TIERS t ON t.id = p.IDTIERS


;