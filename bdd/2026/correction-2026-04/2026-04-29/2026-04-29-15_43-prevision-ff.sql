
create or replace view FACTUREFOURNISSEURFILLECPL as
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
                   ON p.ID = f.IDPRODUIT

;


create or replace view PREVISION_COMPLET_CPL as
SELECT
             p.ID,
             p.DESIGNATION,
             p.IDCAISSE,
             p.IDCAISSELIB,
             p.IDVENTEDETAIL,
             p.IDVENTE,
             p.IDVENTELIB,
             p.IDVIREMENT,
             p.DEBIT,
             p.CREDIT,
             p.DATY,
             p.ETAT,
             p.IDOP,
             p.IDOPLIB,
             p.IDORIGINE,
             p.IDDEVISE,
             p.IDDEVISELIB,
             p.TAUX,
             p.IDTIERS,
             t.NOM as IDTIERSLIB,
             p.COMPTE,
             NVL(pe.effectifDeb,0) AS effectifDebit,
             NVL(pe.effectifCred,0) AS effectifCredit,
             p.debit - NVL(pe.effectifDeb,0) AS depenseEcart,
             p.credit - nVL(pe.effectifCred,0) AS recetteEcart,
             p.idfacture,
             COALESCE(v.IDVENTE, f.IDFACTUREFOURNISSEUR) AS idfacturemere
         FROM PREVISION_CPL p
                  LEFT JOIN PrevisionAvecMvtCaisse pe ON pe.id = p.id
                  LEFT JOIN VENTE_DETAILS v ON v.id = p.idfacture
                  LEFT JOIN FACTUREFOURNISSEURFILLE f ON f.id = p.idfacture
                  LEFT JOIN TIERS t ON t.id = p.IDTIERS


;