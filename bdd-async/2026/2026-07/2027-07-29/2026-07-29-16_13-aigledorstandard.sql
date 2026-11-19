INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1785330745792186', 'Analyse des ventes dynamique', 'bar_chart', 'module.jsp?but=vente/vente-analyse.jsp', 12, 3, 'MNDN000000010');


CREATE OR REPLACE VIEW VENTE_DETAILS_CPL_2 (ID, IDVENTE, IDVENTELIB, IDPRODUIT, IDPRODUITLIB, IDORIGINE, QTE, PU, PUTOTAL, PUTOTALACHAT, PUREVIENT, IDCATEGORIE, IDCATEGORIELIB, DATY, IDMAGASIN, IDMAGASINLIB, IDPOINT, IDPOINTLIB, IDDEVISE, IDDEVISELIB, IDRESERVATION, IDBCFILLE, TYPEPRODUIT, TYPEPRODUITLIB, IDPROVINCE, IDPROVINCELIB, MOTSCLESSS, IDMODELE, IDMODELELIB,IDCATEGORIEMODELE,IDSOUSCATEGORIE,IDCATEGORIEMODELLIB,IDSOUSCATEGORIELIB) AS 
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
		SQ.IDSOUSCATEGORIELIB
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
                pro.VAL                                                            AS IDPROVINCELIB,
                P.IDMODELE,
                MOD.libelle AS IDMODELELIB,
                MOD.IDCATEGORIE AS IDCATEGORIEMODELE,
                MOD.IDSOUSCATEGORIE,
                CM.VAL AS IDCATEGORIEMODELLIB,
                SC.VAL AS IDSOUSCATEGORIELIB
         FROM VENTE_DETAILS vd
                  LEFT JOIN VENTE v ON v.ID = vd.IDVENTE
                  LEFT JOIN MAGASIN2 m ON m.ID = v.IDMAGASIN
                  LEFT JOIN AS_INGREDIENTS p ON p.ID = vd.IDPRODUIT
                  LEFT JOIN MODELE MOD ON MOD.ID = P.IDMODELE
                  LEFT JOIN POINT p1 ON p1.ID = m.IDPOINT
                  LEFT JOIN CATEGORIEINGREDIENT cat ON p.CATEGORIEINGREDIENT = cat.ID
                  LEFT JOIN TYPE_PRODUIT tp ON tp.ID = p.TYPEPRODUIT
                  LEFT JOIN CLIENT cli ON cli.ID = v.IDCLIENT
                  LEFT JOIN PROVINCE pro ON pro.ID = cli.IDPROVINCE
                  LEFT JOIN categorieModele cm on MOD.idcategorie =cm.id
                  LEFT JOIN sousCategorie sc on MOD.idSousCategorie =sc.id
     ) SQ
;


CREATE OR REPLACE VIEW VENTE_DETAILS_CPL_2_VISEE (ID, IDVENTE, IDVENTELIB, 
IDPRODUIT, IDPRODUITLIB, IDORIGINE, QTE, PU, PUTOTAL, PUTOTALACHAT, PUREVIENT, IDCATEGORIE,
IDCATEGORIELIB, DATY, IDMAGASIN, IDMAGASINLIB, IDPOINT, IDPOINTLIB, IDDEVISE, IDDEVISELIB, 
IDRESERVATION, IDBCFILLE, SUM_QTE, MONTANTTOTAL, MONTANT_TOTAL, IDCLIENT, TOTAL_ACHAT, TYPEPRODUIT
, TYPEPRODUITLIB, IDPROVINCE, IDPROVINCELIB, IDMODELE, IDMODELELIB,
IDCATEGORIEMODELE,IDSOUSCATEGORIE,IDCATEGORIEMODELLIB,IDSOUSCATEGORIELIB
) AS 
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
       VD.IDPROVINCELIB,
       VD.IDMODELE,
       VD.IDMODELELIB,
       VD.IDCATEGORIEMODELE,
       VD.IDSOUSCATEGORIE,
       VD.IDCATEGORIEMODELLIB,
       VD.IDSOUSCATEGORIELIB
FROM VENTE_DETAILS_CPL_2 VD
         LEFT JOIN VENTE V ON V.ID = VD.IDVENTE
WHERE V.ETAT >= 11
 
 ;
