CREATE OR REPLACE VIEW BONDECOMMANDE_CLIENT_FILLE_CPL AS
SELECT SQ."ID",SQ."IDBC",SQ."IDDEVISE",SQ."MONTANT",SQ."PRODUIT",SQ."PU",SQ."QUANTITE",SQ."REMISE",SQ."TVA",SQ."UNITE",SQ."QTEOF",SQ."QTEOFRESTANTE",SQ."QTEFAB",SQ."QTEFABRESTANTE",SQ."QTELIVRE",SQ."QTENONLIVRE",SQ."LIBELLEPRODUIT",SQ."ETAT",SQ."DATY",SQ."IDCLIENT",
       (NVL(TO_CHAR("ID"),'') || ' | ' || NVL(TO_CHAR(IDBC),'') || ' | ' || NVL(TO_CHAR(IDDEVISE),'') || ' | ' || NVL(TO_CHAR(MONTANT),'') || ' | ' || NVL(TO_CHAR(PRODUIT),'') || ' | ' || NVL(TO_CHAR(PU),'') || ' | ' || NVL(TO_CHAR(QUANTITE),'') || ' | ' || NVL(TO_CHAR(REMISE),'') || ' | ' || NVL(TO_CHAR(TVA),'') || ' | ' || NVL(TO_CHAR(UNITE),'') || ' | ' || NVL(TO_CHAR(QTEOF),'') || ' | ' || NVL(TO_CHAR(QTEOFRESTANTE),'') || ' | ' || NVL(TO_CHAR(QTEFAB),'') || ' | ' || NVL(TO_CHAR(QTEFABRESTANTE),'') || ' | ' || NVL(TO_CHAR(QTELIVRE),'') || ' | ' || NVL(TO_CHAR(QTENONLIVRE),'') || ' | ' || NVL(TO_CHAR(LIBELLEPRODUIT),'')) AS MOTSCLESSS
FROM (
         SELECT
             bcf.id,
             bcf.IDBC,
             bcf.IDDEVISE,
             avg(bcf.MONTANT) as montant,
             bcf.PRODUIT,
             avg(bcf.PU) as pu,
             avg(bcf.QUANTITE) as quantite,
             avg(bcf.REMISE) as remise,
             avg(bcf.TVA) as tva,
             ing.UNITE as unite,

             nvl(avg(o.QTE),0) AS QTEOF,
             NVL(sum(bcf.QUANTITE) - nvl(avg(o.QTE),0), 0) AS QTEOFRESTANTE,

             nvl(avg(f.QTE),0) AS QTEFAB,
             NVL(sum(bcf.QUANTITE) - nvl(avg(f.QTE),0), 0) AS QTEFABRESTANTE,

             AVG(NVL(abcf.QUANTITE, 0)) AS QTELIVRE,
             NVL(avg(bcf.QUANTITE) - AVG(NVL(abcf.QUANTITE,0)), 0) AS QTENONLIVRE,
             ing.LIBELLE as libelleProduit,
             bccli.ETAT,
             bccli.daty,
             bccli.idclient

         FROM BONDECOMMANDE_CLIENT_FILLE bcf



                  LEFT JOIN BONDECOMMANDE_CLIENT bccli ON bccli.id = bcf.IDBC
                  LEFT JOIN OfGroupByIdbc o ON o.IDBCFILLE = bcf.ID


                  LEFT JOIN fabrGroupByIdbc f ON f.IDBCFILLE = bcf.ID

                  LEFT JOIN BLGroupByIdbc abcf ON abcf.IDBC_FILLE = bcf.ID

                  left join AS_INGREDIENTS ing on ing.id=bcf.PRODUIT

         GROUP BY
             bcf.IDBC,
             bcf.id,
             bcf.IDDEVISE,
             bcf.PRODUIT,
             ing.LIBELLE, ing.UNITE,
             bccli.ETAT,
             bccli.DATY,
             bccli.idclient
     ) SQ
;

CREATE OR REPLACE FORCE VIEW VENTE_DETAILS_CPL_2_VISEE AS
SELECT vd.ID, vd.IDVENTE, vd.IDVENTELIB, vd.IDPRODUIT, vd.IDPRODUITLIB, vd.IDORIGINE, vd.QTE, vd.PU, vd.PUTOTAL, vd.PUTOTALACHAT, vd.PUREVIENT, vd.IDCATEGORIE, vd.IDCATEGORIELIB, vd.DATY, vd.IDMAGASIN, vd.IDMAGASINLIB, vd.IDPOINT, vd.IDPOINTLIB, vd.IDDEVISE, vd.IDDEVISELIB, vd.IDRESERVATION, vd.IDBCFILLE,
       SUM(vd.QTE)     OVER ()                            AS SUM_QTE,
    SUM(vd.PUTOTAL) OVER ()                            AS MONTANTTOTAL,
    SUM(vd.PUTOTAL) OVER ()                            AS MONTANT_TOTAL,
    v.IDCLIENT,
       SUM(vd.PUTOTAL) OVER (PARTITION BY v.IDCLIENT) AS TOTAL_ACHAT
FROM VENTE_DETAILS_CPL_2 vd
         LEFT JOIN VENTE v ON v.ID = vd.IDVENTE
WHERE v.ETAT >= 11;

CREATE OR REPLACE VIEW OFFILLELIBSTOCKIA AS
SELECT SQ.ID,SQ.IDPRODUIT,SQ.LIBELLE,SQ.REMARQUE,SQ.IDMERE,SQ.DATYBESOIN,SQ.QTE,SQ.IDUNITE,SQ.QTEFABRIQUE,SQ.QTERESTE,SQ.LIBELLEEXACTE,SQ.PV,SQ.MONTANTENTREE,SQ.MONTANTSORTIE,SQ.POURC, SQ.IDPRODUITLIB,
       (NVL(TO_CHAR("ID"),'') || ' | ' || NVL(TO_CHAR(IDPRODUIT),'') || ' | ' || NVL(TO_CHAR(LIBELLE),'') || ' | ' || NVL(TO_CHAR(REMARQUE),'') || ' | ' || NVL(TO_CHAR(IDMERE),'') || ' | ' || NVL(TO_CHAR(DATYBESOIN,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(QTE),'') || ' | ' || NVL(TO_CHAR(IDUNITE),'') || ' | ' || NVL(TO_CHAR(QTEFABRIQUE),'') || ' | ' || NVL(TO_CHAR(QTERESTE),'') || ' | ' || NVL(TO_CHAR(LIBELLEEXACTE),'') || ' | ' || NVL(TO_CHAR(PV),'') || ' | ' || NVL(TO_CHAR(MONTANTENTREE),'') || ' | ' || NVL(TO_CHAR(MONTANTSORTIE),'') || ' | ' || NVL(TO_CHAR(POURC),'')) AS MOTSCLESSS,daty
FROM (
         SELECT
             ofll.ID,
             ofll.IDINGREDIENTS AS IDPRODUIT,
             nvl(ofll.LIBELLE,ai.LIBELLE)  AS LIBELLE,
             ofll.REMARQUE,
             ofll.IDMERE,
             ob.daty AS  DATYBESOIN,
             ofll.QTE,
             nvl(au.VAL, 'unite') AS IDUNITE,
             cast(nvl(mv.entree,0) as number(30,5)) as qteFabrique,
             cast(ofll.QTE-nvl(mv.ENTREE,0)as number(30,5)) as qteReste,
             nvl(ofll.LIBELLE,nvl(ai.LIBELLEEXTACTE, ai.LIBELLE)) AS libelleexacte,
             ai.pv,
             cast(nvl(mv.ENTREE,0)*ai.pv as number(30,2)) as montantEntree,
             cast(nvl(mvt.montantSortie,0) as number(30,5)) as montantSortie,
             CASE
                 WHEN (nvl(mv.ENTREE,0)=0 or ai.pv=0) THEN 0
                 ELSE (1-(mvt.montantSortie/(nvl(mv.ENTREE,0)*ai.pv)))*100
                 END AS pourc,
             ob.daty,
             ai.libelle AS IDPRODUITLIB
         FROM
             OFFILLE ofll
                 LEFT JOIN AS_INGREDIENTS ai ON
                 ai.ID = ofll.IDINGREDIENTS
                 LEFT JOIN AS_UNITE au ON
                 au.ID = ofll.IDUNITE
                 left join MVTSTFILLEOFFCATVISEGROUPEDEP mvt on ofll.id=mvt.IDOFf
                 left join mvtStockFilleOfEntreePrFini mv on mv.idoff=ofll.id and mv.IDPRODUIT=ofll.IDINGREDIENTS
                 LEFT JOIN OFAB ob ON ob.id =  ofll.idmere

     ) SQ
;


create view V_RAPPROCHEMENT_OF_IA as
SELECT SQ."IDOBJET",SQ."SORTIE",SQ."PU",SQ."MONTANTSORTIE",SQ."QTETH",SQ."PUTH",SQ."MONTTH",SQ."ECARTQTE",SQ."ECARTMONTANT",SQ."ECARTPU",SQ.IDPRODUIT,
       (NVL(TO_CHAR(IDOBJET),'') || ' | ' || NVL(TO_CHAR(SORTIE),'') || ' | ' || NVL(TO_CHAR(PU),'') || ' | ' || NVL(TO_CHAR(MONTANTSORTIE),'') || ' | ' || NVL(TO_CHAR(QTETH),'') || ' | ' || NVL(TO_CHAR(PUTH),'') || ' | ' || NVL(TO_CHAR(MONTTH),'') || ' | ' || NVL(TO_CHAR(ECARTQTE),'') || ' | ' || NVL(TO_CHAR(ECARTMONTANT),'') || ' | ' || NVL(TO_CHAR(ECARTPU),'')) AS MOTSCLESSS
FROM (
         SELECT
             IDOBJET,
             IDPRODUIT,
             CAST(SUM(SORTIE) AS NUMBER(30,5)) AS sortie,
             CAST(SUM(PU) AS NUMBER(30,2)) AS pu,
             CAST(SUM(MONTANTSORTIE) AS NUMBER(30,5)) AS montantsortie,
             CAST(SUM(QTETH) AS NUMBER(30,5)) AS qteth,
             CAST(SUM(PUTH) AS NUMBER(30,2)) AS puth,
             CAST(SUM(MONTTH) AS NUMBER(30,2)) AS montth,
             CAST(SUM(SORTIE - QTETH) AS NUMBER(30,5)) AS ecartqte,
             CAST(SUM(MONTANTSORTIE - MONTTH) AS NUMBER(30,2)) AS ecartmontant,
             CAST(SUM(PU - PUTH) AS NUMBER(30,2)) AS ecartpu
         FROM
             STOCKETDEPENSEOFFABTHE
         GROUP BY
             IDOBJET,
             IDPRODUIT
     ) SQ;