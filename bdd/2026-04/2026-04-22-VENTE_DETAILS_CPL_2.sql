create or replace view VENTE_DETAILS_CPL_2 as
SELECT SQ."ID",SQ."IDVENTE",SQ."IDVENTELIB",SQ."IDPRODUIT",SQ."IDPRODUITLIB",SQ."IDORIGINE",SQ."QTE",SQ."PU",SQ."PUTOTAL",SQ."PUTOTALACHAT",SQ."PUREVIENT",SQ."IDCATEGORIE",SQ."IDCATEGORIELIB",SQ."DATY",SQ."IDMAGASIN",SQ."IDMAGASINLIB",SQ."IDPOINT",SQ."IDPOINTLIB",SQ."IDDEVISE",SQ."IDDEVISELIB",SQ."IDRESERVATION",SQ."IDBCFILLE",
       (NVL(TO_CHAR(ID),'') || ' | ' || NVL(TO_CHAR(IDVENTE),'') || ' | ' || NVL(TO_CHAR(IDVENTELIB),'') || ' | ' || NVL(TO_CHAR(IDPRODUIT),'') || ' | ' || NVL(TO_CHAR(IDPRODUITLIB),'') || ' | ' || NVL(TO_CHAR(IDORIGINE),'') || ' | ' || NVL(TO_CHAR(QTE),'') || ' | ' || NVL(TO_CHAR(PU),'') || ' | ' || NVL(TO_CHAR(PUTOTAL),'') || ' | ' || NVL(TO_CHAR(PUTOTALACHAT),'') || ' | ' || NVL(TO_CHAR(PUREVIENT),'') || ' | ' || NVL(TO_CHAR(IDCATEGORIE),'') || ' | ' || NVL(TO_CHAR(IDCATEGORIELIB),'') || ' | ' || NVL(TO_CHAR(DATY,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(IDMAGASIN),'') || ' | ' || NVL(TO_CHAR(IDMAGASINLIB),'') || ' | ' || NVL(TO_CHAR(IDPOINT),'') || ' | ' || NVL(TO_CHAR(IDPOINTLIB),'') || ' | ' || NVL(TO_CHAR(IDDEVISE),'') || ' | ' || NVL(TO_CHAR(IDDEVISELIB),'') || ' | ' || NVL(TO_CHAR(IDRESERVATION),'') || ' | ' || NVL(TO_CHAR(IDBCFILLE),'')) AS MOTSCLESSS
FROM (
         SELECT vd.ID,
                vd.IDVENTE,
                v.DESIGNATION          AS IDVENTELIB,
                vd.IDPRODUIT,
                p.LIBELLE                  AS IDPRODUITLIB,
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
                vd.IDBCFILLE
         FROM VENTE_DETAILS vd
                  LEFT JOIN VENTE v ON v.ID = vd.IDVENTE
                  LEFT JOIN MAGASIN2 m ON m.ID = v.IDMAGASIN
                  LEFT JOIN AS_INGREDIENTS p ON p.ID = vd.IDPRODUIT
                  LEFT JOIN POINT p1 ON p1.ID = m.IDPOINT
                  LEFT JOIN CATEGORIEINGREDIENT c  ON p.CATEGORIEINGREDIENT  = c.ID

     ) SQ;
