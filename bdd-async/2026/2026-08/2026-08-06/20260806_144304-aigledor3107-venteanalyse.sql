

create or replace view V_REFCOULEUR_AVECCODE as
SELECT
    c.REFERENCECOULEUR,
    LISTAGG(cc.val , ' - ') WITHIN GROUP (ORDER BY c.REFERENCECOULEUR) || '-' || c.REFERENCECOULEUR AS nomcouleur,
    LISTAGG(cc.desce , ' - ') WITHIN GROUP (ORDER BY c.REFERENCECOULEUR) AS codecouleur
FROM
    COMBINAISONCOULEUR c
    left join couleur cc on c.idcouleur = cc.id

GROUP BY
    c.REFERENCECOULEUR;


create or replace view VENTE_DETAILS_CPL_2 as
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
        NVL(TO_CHAR(SQ.IDPROVINCELIB), '')) AS MOTSCLESSS,
       SQ.IDMODELE,
       SQ.IDMODELELIB,
       SQ.IDCATEGORIEMODELE,
       SQ.IDSOUSCATEGORIE,
       SQ.IDCATEGORIEMODELLIB,
       SQ.IDSOUSCATEGORIELIB,
       SQ.idCategModele,
       SQ.idCategModeleLib,
       SQ.pointure,
       SQ.idPointureLib,
       SQ.idCouleurLib
FROM (
         SELECT vd.ID,
                vd.IDVENTE,
                v.DESIGNATION                                                      AS IDVENTELIB,
                vd.IDPRODUIT,
                p.LIBELLEVENTE                                                     AS IDPRODUITLIB,
                vd.IDORIGINE,
                vd.QTE,
                NVL(vd.PU, 0)                                                      AS PU,
                -- Formule de PUTOTAL aligne?e sur le MONTANTTTC de la vue de?taille?e
                CAST(
                    -- Partie HT avec de?duction des frais
                        ((NVL(vd.PU, 0) * (1 - NVL(vd.REMISE, 0) / 100)) * vd.QTE
                            - NVL(v.FRAISLIVRAISON, 0) * NVL(p.CALORIE, 0) * NVL(vd.QTE, 0))
                            +
                            -- Partie TVA applique?e sur cette me?me base HT modifie?e
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
                pro.VAL                                                            AS IDPROVINCELIB,
                P.IDMODELE,
                MOD.libelle AS IDMODELELIB,
                MOD.IDCATEGORIE AS IDCATEGORIEMODELE,
                MOD.IDSOUSCATEGORIE,
                CM.VAL AS IDCATEGORIEMODELLIB,
                SC.VAL AS IDSOUSCATEGORIELIB,
                categMod.id as idCategModele,
                categMod.val as idCategModeleLib,
                p.MARQUE as pointure,
                pt.val as idPointureLib,
                vrc.NOMCOULEUR as idCouleurLib
         FROM VENTE_DETAILS vd
                  LEFT JOIN VENTE v ON v.ID = vd.IDVENTE
                  LEFT JOIN MAGASIN2 m ON m.ID = v.IDMAGASIN
                  LEFT JOIN AS_INGREDIENTS p ON p.ID = vd.IDPRODUIT
                  LEFT JOIN MODELE MOD ON MOD.ID = P.IDMODELE
                  LEFT JOIN POINT p1 ON p1.ID = m.IDPOINT
                  LEFT JOIN CATEGORIEINGREDIENT cat ON p.CATEGORIEINGREDIENT = cat.ID
                  LEFT JOIN TYPE_PRODUIT tp ON tp.ID = p.TYPEPRODUIT
                  LEFT JOIN CLIENT cli ON cli.ID = v.IDCLIENT
                  LEFT JOIN zone pro ON pro.ID = p1.IDZONE
                  LEFT JOIN categorieModele cm on MOD.idcategorie =cm.id
                  LEFT JOIN SOUSCATEGORIEMODELE sc on MOD.idSousCategorie =sc.id
                  LEFT JOIN CATEGORIEMODELE categMod On categMod.id = p.id
                  LEFT JOIN POINTURE pt ON pt.id = p.MARQUE
                  LEFT JOIN V_REFCOULEUR_AVECCODE vrc ON vrc.REFERENCECOULEUR = p.COULEUR
     ) SQ;



create or replace view VENTE_DETAILS_CPL_2_VISEE
            (ID, IDVENTE, IDVENTELIB, IDPRODUIT, IDPRODUITLIB, IDORIGINE, QTE, PU, PUTOTAL, PUTOTALACHAT, PUREVIENT,
             IDCATEGORIE, IDCATEGORIELIB, DATY, IDMAGASIN, IDMAGASINLIB, IDPOINT, IDPOINTLIB, IDDEVISE, IDDEVISELIB,
             IDRESERVATION, IDBCFILLE, SUM_QTE, MONTANTTOTAL, MONTANT_TOTAL, IDCLIENT, TOTAL_ACHAT, TYPEPRODUIT,
             TYPEPRODUITLIB, IDPROVINCE, IDPROVINCELIB, IDMODELE, IDMODELELIB, IDCATEGORIEMODELE, IDSOUSCATEGORIE,
             IDCATEGORIEMODELLIB, IDSOUSCATEGORIELIB, POINTURE, IDPOINTURELIB, IDCOULEURLIB)
as
SELECT VD.ID,
       VD.IDVENTE,
       VD.IDVENTELIB,
       VD.IDPRODUIT,
       VD.IDPRODUITLIB,
       VD.IDORIGINE,
       VD.QTE,
       CAST(VD.PU AS NUMBER(30,5)),
       CAST( VD.PUTOTAL  AS NUMBER(30,2)),
       CAST( VD.PUTOTALACHAT  AS NUMBER(30,2)),
       CAST( VD.PUREVIENT  AS NUMBER(30,2)),
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
    CAST(SUM(VD.PUTOTAL) OVER () AS NUMBER(30,2))                        AS MONTANTTOTAL,
       CAST(SUM(VD.PUTOTAL) OVER () AS NUMBER(30,2))                        AS MONTANT_TOTAL,
       V.IDCLIENT,
       CAST(SUM(VD.PUTOTAL)  OVER (PARTITION BY V.IDCLIENT) AS NUMBER(30,2))  AS TOTAL_ACHAT,
       VD.TYPEPRODUIT,
       VD.TYPEPRODUITLIB,
       VD.IDPROVINCE,
       VD.IDPROVINCELIB,
       VD.IDMODELE,
       VD.IDMODELELIB,
       VD.IDCATEGORIEMODELE,
       VD.IDSOUSCATEGORIE,
       VD.IDCATEGORIEMODELLIB,
       VD.IDSOUSCATEGORIELIB,
       VD.pointure,
       VD.idPointureLib,
       VD.idCouleurLib
FROM VENTE_DETAILS_CPL_2 VD
         LEFT JOIN VENTE V ON V.ID = VD.IDVENTE
WHERE V.ETAT >= 11;
