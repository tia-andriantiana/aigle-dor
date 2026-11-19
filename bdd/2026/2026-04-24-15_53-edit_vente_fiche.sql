create or replace view VENTE_DETAILS_POIDS as
SELECT SQ."ID",SQ."IDVENTE",SQ."IDPRODUIT",SQ."IDORIGINE",SQ."QTE",SQ."PU",SQ."REMISE",SQ."TVA",SQ."PUACHAT",SQ."PUVENTE",SQ."IDDEVISE",SQ."TAUXDECHANGE",SQ."DESIGNATION",SQ."COMPTE",SQ."PUREVIENT",SQ."IDBCFILLE",SQ."UNITE",SQ."UNITELIB",SQ."PUNET",SQ."MONTANTHT",SQ."MONTANTTTC",SQ."MONTANTTVA",SQ."MONTANTREMISE",SQ."MONTANT",SQ."POIDS",SQ."RESTE",SQ."FRAIS",SQ."IDPRODUITLIB",SQ."DATY",SQ."DATYPREVU",SQ."IDDEVISELIB",SQ."IDCATEGORIELIB",SQ."CATEGORIEPRODUITLIB",SQ."PUTOTAL",SQ."IDCLIENTLIB",SQ."RISTOURNE",SQ."IDPREVISION",
  (NVL(TO_CHAR(ID),'') || ' | ' || NVL(TO_CHAR(IDVENTE),'') || ' | ' || NVL(TO_CHAR(IDPRODUIT),'') || ' | ' || NVL(TO_CHAR(IDORIGINE),'') || ' | ' || NVL(TO_CHAR(QTE),'') || ' | ' || NVL(TO_CHAR(PU),'') || ' | ' || NVL(TO_CHAR(REMISE),'') || ' | ' || NVL(TO_CHAR(TVA),'') || ' | ' || NVL(TO_CHAR(PUACHAT),'') || ' | ' || NVL(TO_CHAR(PUVENTE),'') || ' | ' || NVL(TO_CHAR(IDDEVISE),'') || ' | ' || NVL(TO_CHAR(TAUXDECHANGE),'') || ' | ' || NVL(TO_CHAR(DESIGNATION),'') || ' | ' || NVL(TO_CHAR(COMPTE),'') || ' | ' || NVL(TO_CHAR(PUREVIENT),'') || ' | ' || NVL(TO_CHAR(IDBCFILLE),'') || ' | ' || NVL(TO_CHAR(UNITE),'') || ' | ' || NVL(TO_CHAR(UNITELIB),'') || ' | ' || NVL(TO_CHAR(PUNET),'') || ' | ' || NVL(TO_CHAR(MONTANTHT),'') || ' | ' || NVL(TO_CHAR(MONTANTTTC),'') || ' | ' || NVL(TO_CHAR(MONTANTTVA),'') || ' | ' || NVL(TO_CHAR(MONTANTREMISE),'') || ' | ' || NVL(TO_CHAR(MONTANT),'') || ' | ' || NVL(TO_CHAR(POIDS),'') || ' | ' || NVL(TO_CHAR(RESTE),'') || ' | ' || NVL(TO_CHAR(FRAIS),'') || ' | ' || NVL(TO_CHAR(IDPRODUITLIB),'') || ' | ' || NVL(TO_CHAR(DATY,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(DATYPREVU,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(IDDEVISELIB),'') || ' | ' || NVL(TO_CHAR(IDCATEGORIELIB),'') || ' | ' || NVL(TO_CHAR(CATEGORIEPRODUITLIB),'') || ' | ' || NVL(TO_CHAR(PUTOTAL),'') || ' | ' || NVL(TO_CHAR(IDCLIENTLIB),'') || ' | ' || NVL(TO_CHAR(RISTOURNE),'') || ' | ' || NVL(TO_CHAR(IDPREVISION),'')) AS MOTSCLESSS
FROM (
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
       v.idprevision
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
 
) SQ
/

