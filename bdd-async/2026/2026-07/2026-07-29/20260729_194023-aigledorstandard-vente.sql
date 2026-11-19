create or replace view ETAT_VENTE_DETAILS_POINT as
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

       M.ID                               AS IDPOINT,
       M.VAL                              AS IDPOINTLIB,

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

         LEFT JOIN AS_INGREDIENTS P
                   ON P.ID = V.IDPRODUIT

         LEFT JOIN CLIENT C
                   ON C.ID = VE.IDCLIENT
         LEFT JOIN PROVINCE PRO ON PRO.ID = C.IDPROVINCE
         LEFT JOIN POINT M ON M.ID = VE.IDMAGASIN
         LEFT JOIN TYPE_PRODUIT TP ON TP.ID = P.TYPEPRODUIT;


INSERT INTO POINT (ID, VAL, DESCE, IDZONE)
VALUES ('PNTSG001', 'SIEGE', 'SIEGE', 'ZONE0044');


