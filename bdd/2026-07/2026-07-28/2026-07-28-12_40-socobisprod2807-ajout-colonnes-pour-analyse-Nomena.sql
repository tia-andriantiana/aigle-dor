-- Lien menu
UPDATE MENUDYNAMIQUE
SET HREF='module.jsp?but=vente/vente-analyse.jsp&grouper=idprovincelib'
WHERE ID = 'MNDN0002708114702'
  AND LIBELLE = 'Analyse des ventes par zone';

--Analyse: Ajout ID Province et ID ProvinceLib
CREATE OR REPLACE VIEW VENTE_DETAILS_CPL_2 AS
SELECT SQ.ID,
       SQ.IDVENTE,
       SQ.IDVENTELIB,
       SQ.IDPRODUIT,
       SQ.IDPRODUITLIB,
       SQ.IDORIGINE,
       SQ.QTE,
       SQ.PU,
       SQ.PUTOTAL,
       SQ.PUTOTALACHAT,
       SQ.PUREVIENT,
       SQ.IDCATEGORIE,
       SQ.IDCATEGORIELIB,
       SQ.DATY,
       SQ.IDMAGASIN,
       SQ.IDMAGASINLIB,
       SQ.IDPOINT,
       SQ.IDPOINTLIB,
       SQ.IDDEVISE,
       SQ.IDDEVISELIB,
       SQ.IDRESERVATION,
       SQ.IDBCFILLE,
       SQ.TYPEPRODUIT,
       SQ.TYPEPRODUITLIB,
       SQ.IDPROVINCE,
       SQ.IDPROVINCELIB,
       (NVL(TO_CHAR(SQ.ID), '') || ' | ' ||
        NVL(TO_CHAR(SQ.IDVENTE), '') || ' | ' ||
        NVL(TO_CHAR(SQ.IDVENTELIB), '') || ' | ' ||
        NVL(TO_CHAR(SQ.IDPRODUIT), '') || ' | ' ||
        NVL(TO_CHAR(SQ.IDPRODUITLIB), '') || ' | ' ||
        NVL(TO_CHAR(SQ.IDORIGINE), '') || ' | ' ||
        NVL(TO_CHAR(SQ.QTE), '') || ' | ' ||
        NVL(TO_CHAR(SQ.PU), '') || ' | ' ||
        NVL(TO_CHAR(SQ.PUTOTAL), '') || ' | ' ||
        NVL(TO_CHAR(SQ.PUTOTALACHAT), '') || ' | ' ||
        NVL(TO_CHAR(SQ.PUREVIENT), '') || ' | ' ||
        NVL(TO_CHAR(SQ.IDCATEGORIE), '') || ' | ' ||
        NVL(TO_CHAR(SQ.IDCATEGORIELIB), '') || ' | ' ||
        NVL(TO_CHAR(SQ.DATY, 'YYYY-MM-DD HH24:MI:SS'), '') || ' | ' ||
        NVL(TO_CHAR(SQ.IDMAGASIN), '') || ' | ' ||
        NVL(TO_CHAR(SQ.IDMAGASINLIB), '') || ' | ' ||
        NVL(TO_CHAR(SQ.IDPOINT), '') || ' | ' ||
        NVL(TO_CHAR(SQ.IDPOINTLIB), '') || ' | ' ||
        NVL(TO_CHAR(SQ.IDDEVISE), '') || ' | ' ||
        NVL(TO_CHAR(SQ.IDDEVISELIB), '') || ' | ' ||
        NVL(TO_CHAR(SQ.IDRESERVATION), '') || ' | ' ||
        NVL(TO_CHAR(SQ.IDBCFILLE), '') || ' | ' ||
        NVL(TO_CHAR(SQ.TYPEPRODUIT), '') || ' | ' ||
        NVL(TO_CHAR(SQ.TYPEPRODUITLIB), '') || ' | ' ||
        NVL(TO_CHAR(SQ.IDPROVINCE), '') || ' | ' ||
        NVL(TO_CHAR(SQ.IDPROVINCELIB), '')) AS MOTSCLESSS

FROM (SELECT VD.ID,
             VD.IDVENTE,
             V.DESIGNATION                                                                                  AS IDVENTELIB,
             VD.IDPRODUIT,
             P.LIBELLEVENTE                                                                                 AS IDPRODUITLIB,
             VD.IDORIGINE,
             VD.QTE,
             NVL(VD.PU, 0)                                                                                  AS PU,
             CAST(NVL(VD.PU * VD.QTE * (1 - NVL(VD.REMISE, 0) / 100), 0) +
                  NVL(VD.PU * VD.QTE * (1 - NVL(VD.REMISE, 0) / 100) * (VD.TVA / 100), 0) AS NUMBER(30, 2)) AS PUTOTAL,
             CAST(NVL(VD.PUACHAT * VD.QTE, 0) AS NUMBER(30, 2))                                             AS PUTOTALACHAT,
             CAST(NVL(VD.PU * VD.QTE, 0) - NVL(VD.PUACHAT * VD.QTE, 0) AS NUMBER(30, 2))                    AS PUREVIENT,
             C.ID                                                                                           AS IDCATEGORIE,
             C.VAL                                                                                          AS IDCATEGORIELIB,
             V.DATY                                                                                         AS DATY,
             M.ID                                                                                           AS IDMAGASIN,
             M.VAL                                                                                          AS IDMAGASINLIB,
             P1.ID                                                                                          AS IDPOINT,
             P1.VAL                                                                                         AS IDPOINTLIB,
             VD.IDDEVISE,
             VD.IDDEVISE                                                                                    AS IDDEVISELIB,
             V.IDRESERVATION,
             VD.IDBCFILLE,
             P.TYPEPRODUIT,
             TP.VAL                                                                                         AS TYPEPRODUITLIB,
             CLI.IDPROVINCE,
             PRO.VAL                                                                                        AS IDPROVINCELIB

      FROM VENTE_DETAILS VD
               LEFT JOIN VENTE V ON V.ID = VD.IDVENTE
               LEFT JOIN MAGASIN2 M ON M.ID = V.IDMAGASIN
               LEFT JOIN AS_INGREDIENTS P ON P.ID = VD.IDPRODUIT
               LEFT JOIN POINT P1 ON P1.ID = M.IDPOINT
               LEFT JOIN CATEGORIEINGREDIENT C ON P.CATEGORIEINGREDIENT = C.ID
               LEFT JOIN TYPE_PRODUIT TP ON TP.ID = P.TYPEPRODUIT
               LEFT JOIN CLIENT CLI
                         ON CLI.ID = V.IDCLIENT
               LEFT JOIN PROVINCE PRO ON PRO.ID = CLI.IDPROVINCE) SQ;


CREATE OR REPLACE VIEW VENTE_DETAILS_CPL_2_VISEE AS
SELECT VD.ID,
       VD.IDVENTE,
       VD.IDVENTELIB,
       VD.IDPRODUIT,
       VD.IDPRODUITLIB,
       VD.IDORIGINE,
       VD.QTE,
       VD.PU,
       VD.PUTOTAL,
       VD.PUTOTALACHAT,
       VD.PUREVIENT,
       VD.IDCATEGORIE,
       VD.IDCATEGORIELIB,
       VD.DATY,
       VD.IDMAGASIN,
       VD.IDMAGASINLIB,
       VD.IDPOINT,
       VD.IDPOINTLIB,
       VD.IDDEVISE,
       VD.IDDEVISELIB,
       VD.IDRESERVATION,
       VD.IDBCFILLE,
       SUM(VD.QTE) OVER ()                            AS SUM_QTE,
       SUM(VD.PUTOTAL) OVER ()                        AS MONTANTTOTAL,
       SUM(VD.PUTOTAL) OVER ()                        AS MONTANT_TOTAL,
       V.IDCLIENT,
       SUM(VD.PUTOTAL) OVER (PARTITION BY V.IDCLIENT) AS TOTAL_ACHAT,
       VD.TYPEPRODUIT,
       VD.TYPEPRODUITLIB,
       VD.IDPROVINCE,
       VD.IDPROVINCELIB
FROM VENTE_DETAILS_CPL_2 VD
         LEFT JOIN VENTE V ON V.ID = VD.IDVENTE
WHERE V.ETAT >= 11;


-- Détails
CREATE OR REPLACE VIEW ETAT_VENTE_DETAILS_POIDS AS
SELECT V.ID,
       V.IDVENTE,
       V.IDPRODUIT,
       V.IDORIGINE,
       CAST(V.QTE AS NUMBER(38, 2))        AS QTE,
       V.PU,
       V.REMISE,
       V.TVA,
       V.PUACHAT,
       V.PUVENTE,
       V.IDDEVISE,
       V.TAUXDECHANGE,
       V.DESIGNATION,
       V.COMPTE,
       V.PUREVIENT,
       V.IDBCFILLE,
       V.UNITE,
       V.UNITELIB,
       V.PUNET,
       V.MONTANTHT,
       CAST(V.MONTANTTTC AS NUMBER(30, 2)) AS MONTANTTTC,
       CAST(V.MONTANTTVA AS NUMBER(30, 2)) AS MONTANTTVA,
       V.MONTANTREMISE,
       V.MONTANT,
       V.POIDS,
       VC.RESTE                            AS RESTE,
       V.FRAIS                             AS FRAIS,
       V.IDPRODUITLIB,
       V.DATY,
       V.DATYPREVU                         AS DATYPREVU,
       V.IDDEVISE                          AS IDDEVISELIB,
       V.IDCATEGORIELIB,
       V.CATEGORIEPRODUITLIB,
       MONTANTTTC                          AS PUTOTAL,
       V.IDCLIENTLIB,
       V.RISTOURNE                         AS RISTOURNE,
       V.IDPREVISION,
       VE.IDCLIENT,
       C.IDPROVINCE,
       VE.ETAT,
       PRO.VAL                             AS IDPROVINCELIB,

       M.ID                                AS IDMAGASIN,
       M.VAL                               AS IDMAGASINLIB,

       P1.ID                               AS IDPOINT,
       P1.VAL                              AS IDPOINTLIB,

       TP.ID                               AS TYPEPRODUIT,
       TP.VAL                              AS TYPEPRODUITLIB

FROM VENTE_DETAILS_VIDE V
         LEFT JOIN EQUIVALENCE E
                   ON E.IDPRODUIT = V.IDPRODUIT
                       AND E.IDUNITE = V.UNITE

         LEFT JOIN VENTE_DETAILS_RESTE VC
                   ON VC.ID = V.ID

         LEFT JOIN VENTE VE
                   ON VE.ID = V.IDVENTE

         LEFT JOIN VENTE_DETAILS VDC
                   ON VDC.IDVENTE = VE.ID

         LEFT JOIN AS_INGREDIENTS P ON P.ID = VDC.IDPRODUIT

         LEFT JOIN CLIENT C
                   ON C.ID = VE.IDCLIENT
         LEFT JOIN PROVINCE PRO ON PRO.ID = C.IDPROVINCE
         LEFT JOIN MAGASIN2 M ON M.ID = VE.IDMAGASIN
         LEFT JOIN POINT P1 ON P1.ID = M.IDPOINT
         LEFT JOIN TYPE_PRODUIT TP ON TP.ID = P.TYPEPRODUIT
;

/*
 --BACKUP
CREATE OR REPLACE VIEW VENTE_DETAILS_CPL_2 AS
SELECT SQ.ID,SQ.IDVENTE,SQ.IDVENTELIB,SQ.IDPRODUIT,SQ.IDPRODUITLIB,SQ.IDORIGINE,SQ.QTE,SQ.PU,SQ.PUTOTAL,SQ.PUTOTALACHAT,SQ.PUREVIENT,SQ.IDCATEGORIE,SQ.IDCATEGORIELIB,SQ.DATY,SQ.IDMAGASIN,SQ.IDMAGASINLIB,SQ.IDPOINT,SQ.IDPOINTLIB,SQ.IDDEVISE,SQ.IDDEVISELIB,SQ.IDRESERVATION,SQ.IDBCFILLE,SQ.typeProduit , SQ.typeproduitlib,
	       (NVL(TO_CHAR(ID),'') || ' | ' || NVL(TO_CHAR(IDVENTE),'') || ' | ' || NVL(TO_CHAR(IDVENTELIB),'') || ' | ' || NVL(TO_CHAR(IDPRODUIT),'') || ' | ' || NVL(TO_CHAR(IDPRODUITLIB),'') || ' | ' || NVL(TO_CHAR(IDORIGINE),'') || ' | ' || NVL(TO_CHAR(QTE),'') || ' | ' || NVL(TO_CHAR(PU),'') || ' | ' || NVL(TO_CHAR(PUTOTAL),'') || ' | ' || NVL(TO_CHAR(PUTOTALACHAT),'') || ' | ' || NVL(TO_CHAR(PUREVIENT),'') || ' | ' || NVL(TO_CHAR(IDCATEGORIE),'') || ' | ' || NVL(TO_CHAR(IDCATEGORIELIB),'') || ' | ' || NVL(TO_CHAR(DATY,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(IDMAGASIN),'') || ' | ' || NVL(TO_CHAR(IDMAGASINLIB),'') || ' | ' || NVL(TO_CHAR(IDPOINT),'') || ' | ' || NVL(TO_CHAR(IDPOINTLIB),'') || ' | ' || NVL(TO_CHAR(IDDEVISE),'') || ' | ' || NVL(TO_CHAR(IDDEVISELIB),'') || ' | ' || NVL(TO_CHAR(IDRESERVATION),'') || ' | ' || NVL(TO_CHAR(IDBCFILLE),'')) AS MOTSCLESSS
	FROM (
	         SELECT vd.ID,
	                vd.IDVENTE,
	                v.DESIGNATION          AS IDVENTELIB,
	                vd.IDPRODUIT,
	                p.LIBELLEVENTE                  AS IDPRODUITLIB,
	                vd.IDORIGINE,
	                vd.QTE,
	                nvl(vd.PU, 0)          AS PU,
	                CAST(nvl(vd.PU * vd.QTE*(1-nvl(vd.REMISE,0)/100), 0) +nvl(vd.PU * vd.QTE*(1-nvl(vd.REMISE,0)/100) *(vd.TVA/100), 0) AS number(30,2)) AS puTotal,
	                CAST(nvl(vd.PUACHAT * vd.QTE, 0) AS number(30,2)) AS puTotalAchat,
	                CAST(nvl(vd.PU * vd.QTE, 0) - nvl(vd.PUACHAT * vd.QTE, 0) AS number(30,2)) AS puRevient,
	                c.ID  AS IDCATEGORIE,
	                c.VAL AS IDCATEGORIELIB,
	                v.DATY AS daty,
	                m.ID AS IDMAGASIN,
	                m.VAL AS IDMAGASINLIB,
	                p1.ID AS IDPOINT,
	                p1.VAL AS IDPOINTLIB,
	                vd.IDDEVISE,
	                vd.IDDEVISE AS IDDEVISELIB,
	                v.IDRESERVATION,
	                vd.IDBCFILLE,
	                p.typeProduit ,
	                tp.VAL AS typeproduitlib
	         FROM VENTE_DETAILS vd
	                  LEFT JOIN VENTE v ON v.ID = vd.IDVENTE
	                  LEFT JOIN MAGASIN2 m ON m.ID = v.IDMAGASIN
	                  LEFT JOIN AS_INGREDIENTS p ON p.ID = vd.IDPRODUIT
	                  LEFT JOIN POINT p1 ON p1.ID = m.IDPOINT
	                  LEFT JOIN CATEGORIEINGREDIENT c  ON p.CATEGORIEINGREDIENT  = c.ID
					  LEFT JOIN TYPE_PRODUIT tp ON tp.ID=p.typeProduit
	     ) SQ
/




CREATE OR REPLACE VIEW ETAT_VENTE_DETAILS_POIDS AS
SELECT v.ID,
       v.IDVENTE,
       v.IDPRODUIT,
       v.IDORIGINE,
       CAST(v.QTE AS NUMBER(38, 2)) AS QTE,
       v.PU,
       v.REMISE,
       v.TVA,
       v.PUACHAT,
       v.PUVENTE,
       v.IDDEVISE,
       v.TAUXDECHANGE,
       v.DESIGNATION,
       v.COMPTE,
       v.PUREVIENT,
       v.IDBCFILLE,
       v.UNITE,
       v.UNITELIB,
       v.PUNET,
       v.MONTANTHT,
       cast(v.MONTANTTTC as number(30,2)) as MONTANTTTC,
       cast(v.MONTANTTVA as number(30,2)) as montanttva,
       v.MONTANTREMISE,
       v.MONTANT,
       v.poids,
       vc.RESTE                     AS RESTE,
       v.frais                      AS FRAIS,
       v.IDPRODUITLIB,
       v.DATY,
       v.DATYPREVU                  AS DATYPREVU,
       v.IDDEVISE                   AS IDDEVISELIB,
       v.IDCATEGORIELIB,
       v.CATEGORIEPRODUITLIB,
       montantttc                   AS PUTOTAL,
       v.idclientlib,
       v.RISTOURNE                  AS RISTOURNE,
       v.idprevision,
       ve.IDCLIENT,
       c.IDPROVINCE,
       ve.ETAT
FROM VENTE_DETAILS_VIDE v
         LEFT JOIN EQUIVALENCE e
                   ON e.IDPRODUIT = v.IDPRODUIT
                       AND e.IDUNITE = v.UNITE
         LEFT JOIN VENTE_DETAILS_RESTE vc
                   ON vc.ID = v.ID
         LEFT JOIN Vente ve
                   ON ve.ID = v.IDVENTE
         LEFT JOIN VENTE_DETAILS vdc
                   ON vdc.ID = ve.ID
         left join client c
                   on c.id = ve.idclient;
 */

