-- ============================================================================
-- SCRIPT DE MISE A JOUR: FACTUREFOURNISSEURFILLECPL
-- DATE: 28-07-2026
-- OBJECTIF: Ajouter IDPOINT, IDPOINTLIB, IDMAGASIN, IDMAGASINLIB, IDCATEGORIE, IDCATEGORIELIB, MONTANTTOTAL pour l'analyse des achats
-- ============================================================================
CREATE OR REPLACE VIEW FACTUREFOURNISSEURFILLECPL AS
SELECT f.ID,
       f.IDFACTUREFOURNISSEUR,
       f.IDPRODUIT,
       p.LIBELLE                                                         AS IDPRODUITLIB,
       f.QTE,
       f.PU,
       f.REMISES,
       f.IDBCDETAIL,
       f.TVA,
       f.IDDEVISE,
       f2.DATY,

       ----------------------------------------------------------
       -- 1 Montant HT brut
       ----------------------------------------------------------
       CAST(f.QTE * f.PU AS NUMBER(30, 2))                               AS montant,
       CAST(f.QTE * f.PU AS NUMBER(30, 2))                               AS montanttotal,

       ----------------------------------------------------------
       -- 2 Montant remise (appliquee sur HT)
       ----------------------------------------------------------
       CAST((NVL(f.remises, 0) / 100) * (f.QTE * f.PU) AS NUMBER(30, 2)) AS montantRemise,

       ----------------------------------------------------------
       -- 3 Montant HT net apres remise
       ----------------------------------------------------------
       CAST((f.QTE * f.PU) - ((NVL(f.remises, 0) / 100) * (f.QTE * f.PU))
           AS NUMBER(30, 2))                                             AS montantht,

       ----------------------------------------------------------
       -- 4 TVA sur montant HT net
       ----------------------------------------------------------
       CAST(
               ((f.QTE * f.PU) - ((NVL(f.remises, 0) / 100) * (f.QTE * f.PU)))
                   * f.TVA / 100
           AS NUMBER(30, 2)
       )                                                                 AS montanttva,

       ----------------------------------------------------------
       -- 5 Montant TTC net (HT net + TVA)
       ----------------------------------------------------------
       CAST(
               ((f.QTE * f.PU) - ((NVL(f.remises, 0) / 100) * (f.QTE * f.PU)))
                   + (
                   ((f.QTE * f.PU) - ((NVL(f.remises, 0) / 100) * (f.QTE * f.PU)))
                       * f.TVA / 100
                   )
           AS NUMBER(30, 2)
       )                                                                 AS montantttc,

       ----------------------------------------------------------
       -- 6 Frais accessoires
       ----------------------------------------------------------
       NVL(MONTANTPERTEGAIN, 0)                                          AS fraisaccesoire,

       ----------------------------------------------------------
       -- 7 Montant total avec frais (TTC + accessoires)
       ----------------------------------------------------------
       CAST(
               (
                   ((f.QTE * f.PU * f.TAUXDECHANGE) - ((NVL(f.remises, 0) / 100) * (f.QTE * f.PU * f.TAUXDECHANGE)))
                   )
                   + NVL(MONTANTPERTEGAIN, 0)
           AS NUMBER(30, 2)
       )                                                                 AS montantavecfraisaccessoire,

       ----------------------------------------------------------
       -- 8 PU unitaire HT + accessoires
       ----------------------------------------------------------
       CAST(
               (
                   (
                       ((f.QTE * f.PU * f.TAUXDECHANGE) - ((NVL(f.remises, 0) / 100) * (f.QTE * f.PU * f.TAUXDECHANGE)))
                       )
                       + NVL(MONTANTPERTEGAIN, 0)
                   ) / f.QTE
           AS NUMBER(30, 2)
       )                                                                 AS puavecfraisaccessoire,

       ----------------------------------------------------------
       -- Info produit & localisation
       ----------------------------------------------------------
       NVL(p.LIBELLEEXTACTE, p.LIBELLE)                                  AS libelleexacte,
       f.IDPREVISION,
       p2.ID                                                             AS idpoint,
       p2.VAL                                                            AS idpointlib,
       m.ID                                                              AS idmagasin,
       m.VAL                                                             AS idmagasinlib,
       c.ID                                                              AS idcategorie,
       c.VAL                                                             AS idcategorielib

FROM FACTUREFOURNISSEURFILLE f
         LEFT JOIN FACTUREFOURNISSEUR f2
                   ON f2.ID = f.IDFACTUREFOURNISSEUR
         LEFT JOIN MAGASIN m
                   ON m.ID = f2.IDMAGASIN
         LEFT JOIN POINT p2
                   ON p2.ID = m.IDPOINT
         LEFT JOIN AS_INGREDIENTS p
                   ON p.ID = f.IDPRODUIT
         LEFT JOIN CATEGORIEINGREDIENT c
                   ON c.ID = p.CATEGORIEINGREDIENT;

/*
============================================================================
 BACKUP COMMENTE DE LA VUE ORIGINALE
============================================================================
CREATE VIEW FACTUREFOURNISSEURFILLECPL AS
SELECT f.ID,
       f.IDFACTUREFOURNISSEUR,
       f.IDPRODUIT,
       p.LIBELLE                                                         AS IDPRODUITLIB,
       f.QTE,
       f.PU,
       f.REMISES,
       f.IDBCDETAIL,
       f.TVA,
       f.IDDEVISE,
       f2.DATY,

       ----------------------------------------------------------
       -- 1 Montant HT brut
       ----------------------------------------------------------
       CAST(f.QTE * f.PU AS NUMBER(30, 2))                               AS montant,

       ----------------------------------------------------------
       -- 2 Montant remise (appliquee sur HT)
       ----------------------------------------------------------
       CAST((NVL(f.remises, 0) / 100) * (f.QTE * f.PU) AS NUMBER(30, 2)) AS montantRemise,

       ----------------------------------------------------------
       -- 3 Montant HT net apres remise
       ----------------------------------------------------------
       CAST((f.QTE * f.PU) - ((NVL(f.remises, 0) / 100) * (f.QTE * f.PU))
           AS NUMBER(30, 2))                                             AS montantht,

       ----------------------------------------------------------
       -- 4 TVA sur montant HT net
       ----------------------------------------------------------
       CAST(
               ((f.QTE * f.PU) - ((NVL(f.remises, 0) / 100) * (f.QTE * f.PU)))
                   * f.TVA / 100
           AS NUMBER(30, 2)
       )                                                                 AS montanttva,

       ----------------------------------------------------------
       -- 5 Montant TTC net (HT net + TVA)
       ----------------------------------------------------------
       CAST(
               ((f.QTE * f.PU) - ((NVL(f.remises, 0) / 100) * (f.QTE * f.PU)))
                   + (
                   ((f.QTE * f.PU) - ((NVL(f.remises, 0) / 100) * (f.QTE * f.PU)))
                       * f.TVA / 100
                   )
           AS NUMBER(30, 2)
       )                                                                 AS montantttc,

       ----------------------------------------------------------
       -- 6 Frais accessoires
       ----------------------------------------------------------
       NVL(MONTANTPERTEGAIN, 0)                                          AS fraisaccesoire,

       ----------------------------------------------------------
       -- 7 Montant total avec frais (TTC + accessoires)
       ----------------------------------------------------------
       CAST(
               (
                   ((f.QTE * f.PU * f.TAUXDECHANGE) - ((NVL(f.remises, 0) / 100) * (f.QTE * f.PU * f.TAUXDECHANGE)))
                   )
                   + NVL(MONTANTPERTEGAIN, 0)
           AS NUMBER(30, 2)
       )                                                                 AS montantavecfraisaccessoire,

       ----------------------------------------------------------
       -- 8 PU unitaire HT + accessoires
       ----------------------------------------------------------
       CAST(
               (
                   (
                       ((f.QTE * f.PU * f.TAUXDECHANGE) - ((NVL(f.remises, 0) / 100) * (f.QTE * f.PU * f.TAUXDECHANGE)))
                       )
                       + NVL(MONTANTPERTEGAIN, 0)
                   ) / f.QTE
           AS NUMBER(30, 2)
       )                                                                 AS puavecfraisaccessoire,

       ----------------------------------------------------------
       -- Info produit
       ----------------------------------------------------------
       NVL(p.LIBELLEEXTACTE, p.LIBELLE)                                  AS libelleexacte,
       f.IDPREVISION
FROM FACTUREFOURNISSEURFILLE f
         LEFT JOIN FACTUREFOURNISSEUR f2
                   ON f2.ID = f.IDFACTUREFOURNISSEUR
         LEFT JOIN AS_INGREDIENTS p
                   ON p.ID = f.IDPRODUIT;
*/
