create OR REPLACE view VENTE_DETAILS_CPL1 as
SELECT
    x.ID,
    x.IDVENTE,
    x.IDVENTELIB,
    x.IDPRODUIT,
    x.IDPRODUITLIB,
    x.IDORIGINE,
    x.QTE,
    x.PU,
    x.MONTANTREMISE,
    x.MONTANT,
    x.IDDEVISE,
    x.TAUXDECHANGE,
    x.TVA,
    x.IDCLIENT,
    x.IDCLIENTLIB,
    x.DESIGNATION,
    x.PUREVIENT,
    x.MONTANTREVIENT,
    x.IDUNITELIB,
    CAST(x.QTE * x.PU AS NUMBER(30,2)) AS PUTOTAL,
    x.magasin,
    x.reference,
    x.daty,
    x.RISTOURNE,
    x.idModeleLib,
    x.idCategorieModele,
    x.IDCATEGORIE,
    x.IDMODELE
FROM (
         SELECT
             vd.ID,
             vd.IDVENTE,
             v.DESIGNATION AS IDVENTELIB,
             vd.IDPRODUIT,
             p.LIBELLE AS IDPRODUITLIB,
             v.IDORIGINE,
             vd.QTE,
             vd.PU,
             CASE
                 WHEN vd.remiseMontant IS NOT NULL AND vd.remiseMontant > 0 THEN
                     NVL(vd.remiseMontant, 0)
                 ELSE
                     CAST((NVL(vd.remise / 100, 0)) * NVL((vd.QTE * vd.PU), 0) AS NUMBER(30, 2))
                 END AS MONTANTREMISE,
             CASE
                 WHEN vd.remiseMontant IS NOT NULL AND vd.remiseMontant > 0 THEN
                     (vd.QTE * vd.PU) - vd.remiseMontant
                 ELSE
                     CAST((1 - NVL(vd.remise / 100, 0)) * (vd.QTE * vd.PU) AS NUMBER(30, 2))
                 END AS MONTANT,
             vd.iddevise AS iddevise,
             vd.tauxDeChange AS tauxDeChange,
             vd.tva AS tva,
             v.idclient,
             v.idclientlib,
             p.LIBELLE AS designation,
             vd.PUREVIENT,
             CAST(vd.QTE * vd.PUREVIENT AS NUMBER(20, 2)) AS montantRevient,
             au.val AS idunitelib,
             pt.val as magasin,
             p.reference,
             v.daty,
             vd.RISTOURNE,
             p.IDModele,
             modele.LIBELLE as idModeleLib,
             modele.IDCATEGORIE,
             categ.val as idCategorieModele
         FROM VENTE_DETAILS vd
                  LEFT JOIN VENTE_LIB v ON v.ID = vd.IDVENTE
                  LEFT JOIN AS_INGREDIENTS p ON p.ID = vd.IDPRODUIT
                  LEFT JOIN AS_UNITE au ON au.id = p.unite
                  LEFT JOIN POINT pt ON pt.id = v.idmagasin
                  LEFT JOIN MODELE modele ON modele.id = p.IDMODELE
                  LEFT JOIN CATEGORIEMODELE categ ON categ.id = modele.IDCATEGORIE
     ) x;


create or replace view VENTE_DETAILS_CAT as
select v."ID", v."IDVENTE", v."IDVENTELIB", v."IDPRODUIT",
       v."IDPRODUITLIB", v."IDORIGINE", v."QTE", v."PU",
       v."MONTANTREMISE", v."MONTANT", v."MONTANT" AS "MONTANTTTC",
       v."IDDEVISE", v."TAUXDECHANGE", v."TVA", v."IDCLIENT",
       v."IDCLIENTLIB", v."DESIGNATION", v."PUREVIENT",
       v."MONTANTREVIENT", v."IDUNITELIB", v."PUTOTAL",
       v."MAGASIN", v."REFERENCE", v."DATY", v."RISTOURNE",
       ing.categorieingredient, 1 AS nb, v.MAGASIN as idMagasinLib, v.idModeleLib,
       v.idCategorieModele, v.IDCATEGORIE, v.IDMODELE
from VENTE_DETAILS_CPL1 v
         LEFT JOIN AS_INGREDIENTS_LIB ing on ing.ID = v.IDPRODUIT;

