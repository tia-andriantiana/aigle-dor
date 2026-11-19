CREATE OR REPLACE VIEW SOLDE_OUVERTURE AS
SELECT
    rep.id,
    rep.IDCAISSE,
    rep.TYPEREPORT,
    rep.MONTANT,
    rep.MONTANTTHEORIQUE,
    rep.DATY,
    rep.etat,
    rep.REMARQUE,
    rep.heure,
    cai.IDPOINT as idPoint
FROM REPORTCAISSE rep
         LEFT JOIN CAISSE cai ON cai.id = rep.IDCAISSE order by DATY and HEURE ASC;


INSERT INTO CAISSE (ID, VAL, DESCE, IDTYPECAISSE, IDPOINT, IDPOMPISTE, ETAT, IDCATEGORIECAISSE, COMPTE,
                    IDMAGASIN, IDDEVISE, IDTYPEBANQUE, ESTRIB)
VALUES ('CAIBO0045', 'Caisse Carte Cadeau', 'Caisse Carte Cadeau', 'TCA004', 'PNTB0001', null, 11, 'CTC0010',
        '530001', null, 'AR', null, 0);



create or replace view AS_INGREDIENT_VENTE_LIB
            (ID, LIBELLE, SEUIL, UNITE, QUANTITEPARPACK, PU, ACTIF, PHOTO, CALORIE, DURRE, COMPOSE, CATEGORIEINGREDIENT,
             IDFOURNISSEUR, DATY, QTELIMITE, PV, LIBELLEVENTE, SEUILMIN, SEUILMAX, PUACHATUSD, PUACHATEURO,
             PUACHATAUTREDEVISE, PUVENTEUSD, PUVENTEEURO, PUVENTEAUTREDEVISE, ISVENTE, ISACHAT, COMPTE_VENTE,
             COMPTE_ACHAT, LIBELLEEXTACTE, TVA, FILEPATH, RESTE, TYPESTOCK, REFPOST, REFQUALIFICATION, IDCHAMBRE,
             ISPERISHABLE, PV2, IDMAGASIN, PRIXUNITAIRE, IDTYPECLIENT, IDTYPECLIENTLIB, IDUNITE, IDUNITELIB, POIDS, QTE,
             TARIFMAGASIN, UNITE2)
as
select ing.ID,
       --concat(concat(ing.LIBELLE, ' '), ing.PARFUMS) as LIBELLE,
       ing.LIBELLEVENTE as LIBELLE,
       CAST(ing.SEUIL AS NUMBER(10,5)) AS  SEUIL,
       ing.UNITE,
       CAST(ing.QUANTITEPARPACK AS NUMBER(10,5)) AS QUANTITEPARPACK ,
       CAST(ing.PU AS NUMBER(30,5)) AS PU,
       ing.ACTIF,
       ing.PHOTO,
       ing.CALORIE,
       ing.DURRE,
       ing.COMPOSE,
       ing.CATEGORIEINGREDIENT,
       ing.IDFOURNISSEUR,
       ing.DATY,
       CAST(ing.QTELIMITE AS NUMBER(30,5)) AS QTELIMITE,
       CAST(ing.PV AS NUMBER(30,5)) AS PV,
       ing.LIBELLEVENTE,
       CAST(COALESCE(ing.SEUILMIN,0) AS NUMBER(30,5)) AS SEUILMIN,
       CAST(COALESCE(ing.SEUILMAX,0) AS NUMBER(30,5)) AS SEUILMAX,
       CAST(COALESCE(ing.PUACHATUSD,0) AS NUMBER(30,5)) AS PUACHATUSD,
       CAST(COALESCE(ing.PUACHATEURO,0) AS NUMBER(30,5)) AS PUACHATEURO,
       CAST(COALESCE(ing.PUACHATAUTREDEVISE,0) AS NUMBER(30,5)) AS PUACHATAUTREDEVISE,
       CAST(COALESCE(ing.PUVENTEUSD,0) AS NUMBER(30,5)) AS PUVENTEUSD,
       CAST(COALESCE(ing.PUVENTEEURO,0) AS NUMBER(30,5)) AS PUVENTEEURO,
       CAST(COALESCE(ing.PUVENTEAUTREDEVISE,0) AS NUMBER(30,5)) AS PUVENTEAUTREDEVISE,
       ing.ISVENTE,
       ing.ISACHAT,
       ing.COMPTE_VENTE,
       ing.COMPTE_ACHAT,
       ing.LIBELLEEXTACTE,
       CAST(ing.TVA AS NUMBER(10,5)) AS TVA,
       ing.FILEPATH,
       CAST(ing.RESTE AS NUMBER(20,5)) AS RESTE,
       ing.TYPESTOCK,
       ing.REFPOST,
       ing.REFQUALIFICATION,
       ing.IDCHAMBRE,
       ing.ISPERISHABLE,
       ing.PV2,
       ing.IDMAGASIN,
       CAST(nvl(ting.PRIXUNITAIRE,ing.PV)  AS NUMBER(30,5)) AS PRIXUNITAIRE,
       tc.ID as IDTYPECLIENT,
       tc.VAL as idtypeclientlib,
       nvl(un.id,un2.id) as idunite,
       nvl(un.VAL,un2.val) as idunitelib,
       CAST(eq.POIDS  AS NUMBER(30,5)) AS POIDS,
       CAST(eq.QUANTITE AS NUMBER(20,5)) AS QUANTITE,
       ting.IDMAGASIN as TARIFMAGASIN,
       UNITE2,
       ing.MARQUE as pointure,
       pt.VAL as pointureLib,


from AS_INGREDIENTS ing
         cross join TYPECLIENT tc
         left join TARIF_INGREDIENTS_MAX ting on ing.ID = TING.IDINGREDIENT AND ting.IDTYPECLIENT=tc.id
         left join AS_UNITE un on un.ID = TING.UNITE
         left join AS_UNITE un2 on un2.ID = ing.UNITE
         left join EQUIVALENCEVENTE eq on eq.IDPRODUIT2 = ting.IDINGREDIENT
         left join POINTURE pt ON pt.id = ing.MARQUE
WHERE (ing.CATEGORIEINGREDIENT = 'CAT008' OR ing.ISVENTE = 1);


INSERT INTO CAISSE (ID, VAL, DESCE, IDTYPECAISSE, IDPOINT, IDPOMPISTE, ETAT, IDCATEGORIECAISSE, COMPTE,
                    IDMAGASIN, IDDEVISE, IDTYPEBANQUE, ESTRIB)
VALUES ('CAIBO0046', 'Caisse Bon d`achat', 'Caisse Bon d`achat', 'TCA004', 'PNTB0001', null, 11, 'CTC0011', '530001',
        null, 'AR', null, 0);




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
                categMod.VAL AS IDCATEGORIEMODELLIB,
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
                  LEFT JOIN zone pro ON pro.ID = cli.IDZONE
                  LEFT JOIN categorieModele cm on MOD.idcategorie =cm.id
                  LEFT JOIN SOUSCATEGORIEMODELE sc on MOD.idSousCategorie =sc.id
                  LEFT JOIN CATEGORIEMODELE categMod On categMod.id = MOD.IDCATEGORIE
     ) SQ;




create or replace view VENTE_DETAILS_CPL_2_VISEE
            (ID, IDVENTE, IDVENTELIB, IDPRODUIT, IDPRODUITLIB, IDORIGINE, QTE, PU, PUTOTAL, PUTOTALACHAT, PUREVIENT,
             IDCATEGORIE, IDCATEGORIELIB, DATY, IDMAGASIN, IDMAGASINLIB, IDPOINT, IDPOINTLIB, IDDEVISE, IDDEVISELIB,
             IDRESERVATION, IDBCFILLE, SUM_QTE, MONTANTTOTAL, MONTANT_TOTAL, IDCLIENT, TOTAL_ACHAT, TYPEPRODUIT,
             TYPEPRODUITLIB, IDPROVINCE, IDPROVINCELIB, IDMODELE, IDMODELELIB, IDCATEGORIEMODELE, IDSOUSCATEGORIE,
             IDCATEGORIEMODELLIB, IDSOUSCATEGORIELIB)
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
       VD.IDSOUSCATEGORIELIB
FROM VENTE_DETAILS_CPL_2 VD
         LEFT JOIN VENTE V ON V.ID = VD.IDVENTE
WHERE V.ETAT >= 11;




