-- Ajout réduction frais de livraison
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
FROM (
         SELECT vd.ID,
                vd.IDVENTE,
                v.DESIGNATION                                                      AS IDVENTELIB,
                vd.IDPRODUIT,
                p.LIBELLEVENTE                                                     AS IDPRODUITLIB,
                vd.IDORIGINE,
                vd.QTE,
                NVL(vd.PU, 0)                                                      AS PU,
                -- Formule de PUTOTAL alignée sur le MONTANTTTC de la vue détaillée
                CAST(
                    -- Partie HT avec déduction des frais
                        ((NVL(vd.PU, 0) * (1 - NVL(vd.REMISE, 0) / 100)) * vd.QTE
                            - NVL(v.FRAISLIVRAISON, 0) * NVL(p.CALORIE, 0) * NVL(vd.QTE, 0))
                            +
                            -- Partie TVA appliquée sur cette même base HT modifiée
                        (((NVL(vd.PU, 0) * (1 - NVL(vd.REMISE, 0) / 100)) * vd.QTE
                            - NVL(v.FRAISLIVRAISON, 0) * NVL(p.CALORIE, 0) * NVL(vd.QTE, 0)) * NVL(vd.TVA, 0) / 100)
                    AS NUMBER(30,2)
                )                                                                  AS PUTOTAL,
                CAST(NVL(vd.PUACHAT * vd.QTE, 0) AS NUMBER(30, 2))                  AS PUTOTALACHAT,
                CAST(NVL(vd.PU * vd.QTE, 0) - NVL(vd.PUACHAT * vd.QTE, 0) AS NUMBER(30, 2)) AS PUREVIENT,
                cat.ID                                                             AS IDCATEGORIE,
                cat.VAL                                                            AS IDCATEGORIELIB,
                v.DATY                                                             AS DATY,
                m.ID                                                               AS IDMAGASIN,
                m.VAL                                                              AS IDMAGASINLIB,
                p1.ID                                                              AS IDPOINT,
                p1.VAL                                                             AS IDPOINTLIB,
                vd.IDDEVISE,
                vd.IDDEVISE                                                        AS IDDEVISELIB,
                v.IDRESERVATION,
                vd.IDBCFILLE,
                p.TYPEPRODUIT,
                tp.VAL                                                             AS TYPEPRODUITLIB,
                cli.IDPROVINCE,
                pro.VAL                                                            AS IDPROVINCELIB
         FROM VENTE_DETAILS vd
                  LEFT JOIN VENTE v ON v.ID = vd.IDVENTE
                  LEFT JOIN MAGASIN2 m ON m.ID = v.IDMAGASIN
                  LEFT JOIN AS_INGREDIENTS p ON p.ID = vd.IDPRODUIT
                  LEFT JOIN POINT p1 ON p1.ID = m.IDPOINT
                  LEFT JOIN CATEGORIEINGREDIENT cat ON p.CATEGORIEINGREDIENT = cat.ID
                  LEFT JOIN TYPE_PRODUIT tp ON tp.ID = p.TYPEPRODUIT
                  LEFT JOIN CLIENT cli ON cli.ID = v.IDCLIENT
                  LEFT JOIN PROVINCE pro ON pro.ID = cli.IDPROVINCE
     ) SQ;


/*
 -- BACKUP

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
*/