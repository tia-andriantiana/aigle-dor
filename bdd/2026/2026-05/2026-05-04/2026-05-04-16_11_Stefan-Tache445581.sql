-- SOCOBISRECTIFDONNEE.V_ETATSTOCK_ENTREE source

CREATE OR REPLACE VIEW "V_ETATSTOCK_ENTREE" ("ID", "IDPRODUIT", "IDPRODUITLIB", "CATEGORIEINGREDIENT", "IDTYPEPRODUITLIB", "IDMAGASIN", "IDMAGASINLIB", "QUANTITE", "ENTREE", "SORTIE", "RESTE", "UNITE", "IDUNITELIB", "PU", "DATY", "IDFOURNISSEUR", "IDFOURNISSEURLIB", "DATEACHAT", "PUVENTE", "IDPOINT", "IDTYPEMAGASIN", "SEUILMIN", "SEUILMAX", "MONTANTENTREE", "MONTANTSORTIE", "MONTANTRESTE", "MOTSCLESSS") AS
SELECT SQ.ID,SQ.IDPRODUIT,SQ.IDPRODUITLIB,SQ.CATEGORIEINGREDIENT,SQ.IDTYPEPRODUITLIB,SQ.IDMAGASIN,SQ.IDMAGASINLIB,CAST(COALESCE(SQ.QUANTITE,0) AS NUMBER(30,5)) AS quantite,cast(COALESCE(SQ.ENTREE,0) as number(30,5)) as entree,cast(COALESCE(SQ.SORTIE,0) as number(30,5)) as sortie,CAST(COALESCE(SQ.RESTE,0) AS NUMBER(30,5)) AS reste,SQ.UNITE,SQ.IDUNITELIB,SQ.PU,SQ.DATY,SQ.IDFOURNISSEUR,SQ.IDFOURNISSEURLIB,SQ.DATEACHAT,CAST(COALESCE(SQ.PUVENTE,0) AS NUMBER(30,5)) AS PUVENTE,SQ.IDPOINT,SQ.IDTYPEMAGASIN,CAST(COALESCE(SQ.SEUILMIN,0) AS NUMBER(30,5)) AS SEUILMIN,CAST(COALESCE(SQ.SEUILMAX,0) AS NUMBER(30,5)) AS SEUILMAX ,CAST(COALESCE(SQ.MONTANTENTREE,0) AS NUMBER(30,5)) AS MONTANTENTREE,CAST(COALESCE(SQ.MONTANTSORTIE,0) AS NUMBER(30,5)) AS MONTANTSORTIE ,CAST(COALESCE(SQ.MONTANTRESTE,0) AS NUMBER(30,5)) AS MONTANTRESTE,
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
             CAST(ve.quantite AS NUMBER(30,5)) AS quantite,
             CAST(ve.entree AS NUMBER(30,5)) AS entree,
             CAST(ve.sortie AS NUMBER(30,5)) AS sortie,
             CAST(ve.reste AS NUMBER(30,5)) AS reste,
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
                                        CAST(NVL(mf.ENTREE, 0) - NVL(s.SORTIE, 0)  + NVL(s.ENTREE, 0) AS NUMBER(30,5)) * mf.PU AS MONTANTRESTE

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
                                      AND (ms.IDCATEGORIESTOCK IS NULL
                                        OR ms.IDCATEGORIESTOCK <> 'CTGST000003')
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

         WHERE ve.PU > 0 AND CAST(ve.reste AS NUMBER(30,5)) != 0
     ) SQ;

CREATE OR REPLACE VIEW "MONTANT_STOCK_ENG" AS
SELECT
    mf.IDPRODUIT,
    SUM(NVL(mf.ENTREE,0)) AS ENTREE,
    SUM(NVL(mf.SORTIE,0)) AS SORTIE,
    SUM(NVL(mf.ENTREE,0)) - SUM(NVL(mf.SORTIE,0)) AS quantite,
    cast(sum(mf.montantEntree) as number(30,2))  AS montantEntree,
    cast(sum(mf.montantSortie) as number(30,2))  AS montantSortie,
    CAST(NVL(ai.PU, 0) * (SUM(NVL(mf.ENTREE,0)) - SUM(NVL(mf.SORTIE,0))) AS NUMBER(30,2)) AS montant,
    m.IDMAGASIN,
    MAX(mf.IDMVTSTOCK) AS IDMVTSTOCK
FROM
    mvtStockFilleMontant_eng mf
        JOIN MVTstock_eng m ON m.id = mf.IDMVTSTOCK
        JOIN AS_INGREDIENTS ai ON ai.ID = mf.IDPRODUIT
WHERE
    m.ETAT >= 11
  AND mf.IDPRODUIT IS NOT NULL
GROUP BY
    mf.IDPRODUIT,
    ai.PU,m.IDMAGASIN
;


CREATE OR REPLACE VIEW V_ETATSTOCK_ING_ENG AS
SELECT
    p.ID,
    p.LIBELLE AS idproduitLib,
    p.CATEGORIEINGREDIENT,
    tp.DESCE AS idtypeproduitlib,
    ms.IDMAGASIN,
    mag.VAL AS idmagasinlib,
    TO_DATE('01-01-2001', 'DD-MM-YYYY') AS dateDernierMouvement,
    CAST(ms.quantite AS NUMBER(30,5)) AS QUANTITE,
    CAST(NVL(ms.entree, 0) AS NUMBER(30,5)) AS ENTREE,
    CAST(NVL(ms.sortie, 0) AS NUMBER(30,5)) AS SORTIE,
    CAST(NVL(ms.quantite, 0) AS NUMBER(30,5)) AS reste,
    p.UNITE,
    u.DESCE AS idunitelib,
    CAST(NVL(p.PV, 0) AS NUMBER(30,5)) AS PUVENTE,
    mag.IDPOINT,
    mag.IDTYPEMAGASIN,
    CAST(COALESCE(p.SEUILMIN,0) AS NUMBER(30,5)) AS SEUILMIN,
    CAST(COALESCE(p.SEUILMAX,0) AS NUMBER(30,5)) AS SEUILMAX,
    CAST(ms.montantEntree AS NUMBER(30,5)) AS montantEntree,
    CAST(ms.montantSortie AS NUMBER(30,5)) AS montantSortie,
    CAST(p.pu AS NUMBER(30,5)) AS pu,
    CAST(ms.montant AS NUMBER(30,5)) AS montantReste
FROM AS_INGREDIENTS p
         LEFT JOIN MONTANT_STOCK_eng ms ON ms.IDPRODUIT = p.ID
         LEFT JOIN MVTSTOCK mvt ON mvt.ID = ms.IDMVTSTOCK
         LEFT JOIN CATEGORIEINGREDIENT tp ON p.CATEGORIEINGREDIENT = tp.ID
         LEFT JOIN MAGASINPOINT mag ON ms.IDMAGASIN = mag.ID
         LEFT JOIN AS_UNITE u ON p.UNITE = u.ID
WHERE
    (NVL(ms.ENTREE, 0) > 0 OR NVL(ms.SORTIE, 0) > 0)
  AND (
    mvt.IDCATEGORIESTOCK IS NULL
        OR mvt.IDCATEGORIESTOCK <> 'CTGST000003'
    );



