UPDATE SOCOBISPROD0122.AS_INGREDIENTS SET ID = 'TVAAPAYER', LIBELLE = 'TVA à payer', SEUIL = 0.00, UNITE = 'UNT00005', QUANTITEPARPACK = 0.00, PU = 1.00, ACTIF = 0, PHOTO = null, CALORIE = 0.00, DURRE = null, COMPOSE = 0, CATEGORIEINGREDIENT = null, IDFOURNISSEUR = 'non', DATY = DATE '2026-02-10', QTELIMITE = 0.00, PV = 0.00, LIBELLEVENTE = null, SEUILMIN = null, SEUILMAX = null, PUACHATUSD = null, PUACHATEURO = null, PUACHATAUTREDEVISE = null, PUVENTEUSD = 0.00, PUVENTEEURO = 0.00, PUVENTEAUTREDEVISE = null, ISVENTE = null, ISACHAT = null, COMPTE_VENTE = '445400', COMPTE_ACHAT = '445400', LIBELLEEXTACTE = null, TVA = 0.00, FILEPATH = null, RESTE = 0.00, TYPESTOCK = 'CUMP', REFPOST = null, REFQUALIFICATION = null, IDCHAMBRE = null, ISPERISHABLE = null, PV2 = null, IDFAMILLE = null, IDMAGASIN = null, PARFUMS = null;


create or replace view COMPTASOUSECRITUREND as
SELECT cse.ID,
       cse.NUMERO,
       cse.COMPTE,
       cse.JOURNAL,
       cse.IDJOURNAL,
       cse.ECRITURE,
       cse.DATY,
       cse.CREDIT,
       cse.DEBIT,
       cse.DATECOMPTABLE,
       cse.EXERCICE,
       cse.REMARQUE,
       cse.ETAT,
       cse.IDMERE,
       cse.HORSEXERCICE,
       cse.OD,
       cse.ORIGINE,
       cse.TIERS,
       cse.LIBELLEPIECE,
       cse.COMPTE_AUX,
       cse.RAISONSOCIAL,
       cse.FOLIO,
       cse.LETTRAGE,
       cse.ANALYTIQUE
FROM COMPTA_SOUSECRITURE_LIB cse
         LEFT JOIN SOUSECRITUREDECLARER csed
                   ON cse.id = csed.idSousEcriture
WHERE csed.idSousEcriture IS NULL
  and COMPTE like '445%';



INSERT INTO FACTUREDECLARATION
(
    ID,
    IDFOURNISSEUR,
    IDMODEPAIEMENT,
    DATY,
    DESIGNATION,
    DATEECHEANCEPAIEMENT,
    ETAT,
    REFERENCE,
    IDBC,
    DEVISE,
    TAUX,
    IDMAGASIN,
    IDDEVISE,
    ESTPREVU,
    DATYPREVU,
    NUMERO,
    TYPEACHAT,
    IDTYPEFACTURE,
    IDOBJET,
    IDREF,
    IDDMDACHAT
)
VALUES
    (
        'FD00001',
        'FRN000010',
        '0002',
        TO_DATE('2026-02-10', 'YYYY-MM-DD'),
        'Achat de matériels informatiques',
        TO_DATE('2026-03-10', 'YYYY-MM-DD'),
        1,
        'REF-FD-2026-001',
        'BC00012',
        'AR',
        1.00,
        'MAG0001',
        'AR',
        0,
        NULL,
        'FACT-2026-001',
        'LOCAL',
        'TPF0001',
        'OBJ0001',
        'REFEXT001',
        'DMDA000257'
    );

CREATE OR REPLACE VIEW FACTUREDECLARATIONCPL AS
SELECT
    f.ID,
    f.IDFOURNISSEUR,
    f2.NOM AS IDFOURNISSEURLIB,

    f.IDMODEPAIEMENT,
    m.VAL AS IDMODEPAIEMENTLIB,

    f.DATY,
    f.DESIGNATION,
    f.DATEECHEANCEPAIEMENT,

    f.ETAT,
    CASE
        WHEN f.ETAT = 1  THEN 'CREE'
        WHEN f.ETAT = 0  THEN 'ANNULEE'
        WHEN f.ETAT = 11 THEN 'VISEE'
        END AS ETATLIB,

    f.REFERENCE,
    f.IDBC,
    f.IDMAGASIN,
    f.DEVISE,
    f2.COMPTE,

    NVL(NULLIF(f.TAUX,0),1) AS TAUX,

    p.VAL AS IDMAGASINLIB,

    f.IDDEVISE,

    CAST(NVL(f3.MONTANTTVA,0) AS NUMBER(30,2)) AS MONTANTTVA,
    CAST(NVL(f3.MONTANTTTC,0) - NVL(f3.MONTANTTVA,0) AS NUMBER(30,2)) AS MONTANTHT,
    CAST(NVL(f3.MONTANTTTC,0) AS NUMBER(30,2)) AS MONTANTTTC,

    CAST(
            NVL(f3.MONTANTTTC,0) * NVL(f3.tauxdechange,1)
        AS NUMBER(30,2)
    ) AS MONTANTTTCAR,

    CAST(NVL(mv.debit,0) AS NUMBER(30,2)) AS MONTANTPAYE,
    CAST(NVL(f3.MONTANTTTC,0) - NVL(mv.debit,0) AS NUMBER(30,2)) AS MONTANTRESTE,

    CAST(NVL(f3.tauxdechange,1) AS NUMBER(30,2)) AS TAUXDECHANGE,

    prev.ID AS IDPREVISION,

    CASE
        WHEN f.estprevu = 0 THEN 'NON'
        ELSE 'OUI'
        END AS ESTPREVULIB,

    f.IDOBJET,
    f.IDREF,
    f.IDTYPEFACTURE,
    tf.VAL AS TYPEFACTURE,
    f.NUMERO,
    f.TYPEACHAT

FROM FACTUREDECLARATION f
         LEFT JOIN FOURNISSEUR f2 ON f2.ID = f.IDFOURNISSEUR
         LEFT JOIN MODEPAIEMENT m ON m.ID = f.IDMODEPAIEMENT
         LEFT JOIN MAGASIN p ON p.ID = f.IDMAGASIN
         LEFT JOIN FACTUREFOURNISSEURMONTANT f3 ON f.ID = f3.ID
         LEFT JOIN MOUVEMENTCAISSEGROUPEFACTURE mv ON f.ID = mv.IDORIGINE
         LEFT JOIN PREVISION prev ON prev.IDFACTURE = f.ID
         LEFT JOIN TYPE_FACTURE tf ON tf.ID = f.IDTYPEFACTURE;

create view FACTUREDECLARATIONFILLECPL as
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

       CAST(f.QTE * f.PU AS NUMBER(30, 2))                               AS montant,
       CAST((NVL(f.remises, 0) / 100) * (f.QTE * f.PU) AS NUMBER(30, 2)) AS montantRemise,
       CAST((f.QTE * f.PU) - ((NVL(f.remises, 0) / 100) * (f.QTE * f.PU))
           AS NUMBER(30, 2))                                             AS montantht,
       CAST(
               ((f.QTE * f.PU) - ((NVL(f.remises, 0) / 100) * (f.QTE * f.PU)))
                   * f.TVA / 100
           AS NUMBER(30, 2)
       )                                                                 AS montanttva,
       CAST(
               ((f.QTE * f.PU) - ((NVL(f.remises, 0) / 100) * (f.QTE * f.PU)))
                   + (
                   ((f.QTE * f.PU) - ((NVL(f.remises, 0) / 100) * (f.QTE * f.PU)))
                       * f.TVA / 100
                   )
           AS NUMBER(30, 2)
       )                                                                 AS montantttc,

       NVL(MONTANTPERTEGAIN, 0)                                          AS fraisaccesoire,

       CAST(
               (
                   ((f.QTE * f.PU * f.TAUXDECHANGE) - ((NVL(f.remises, 0) / 100) * (f.QTE * f.PU * f.TAUXDECHANGE)))
                   )
                   + NVL(MONTANTPERTEGAIN, 0)
           AS NUMBER(30, 2)
       )                                                                 AS montantavecfraisaccessoire,
       CAST(
               (
                   (
                       ((f.QTE * f.PU * f.TAUXDECHANGE) - ((NVL(f.remises, 0) / 100) * (f.QTE * f.PU * f.TAUXDECHANGE)))
                       )
                       + NVL(MONTANTPERTEGAIN, 0)
                   ) / f.QTE
           AS NUMBER(30, 2)
       )                                                                 AS puavecfraisaccessoire,

       NVL(p.LIBELLEEXTACTE, p.LIBELLE)                                  AS libelleexacte
FROM FACTUREDECLARATIONFILLE f
         LEFT JOIN FACTUREFOURNISSEUR f2
                   ON f2.ID = f.IDFACTUREFOURNISSEUR
         LEFT JOIN AS_INGREDIENTS p
                   ON p.ID = f.IDPRODUIT


                       /


create view FACTUREDECLARATION_FILLECOMPTE as
select ff.COMPTE,
       ff.IDFACTUREFOURNISSEUR,
       ff.etat,
       cast(sum(pu * QTE) as number(30, 2))                            as montantht,
       cast(sum(pu * QTE * (tva / 100)) as number(30, 2))              as montanttva,
       cast(sum((pu * QTE) + pu * QTE * (tva / 100)) as number(30, 2)) as montantttc,
       ff.iddevise,
       ff.tauxdechange
from FACTUREDECLARATION_FILLECPL ff
group by COMPTE, IDFACTUREFOURNISSEUR, ff.etat,ff.iddevise,ff.tauxdechange


    /

create or replace view FACTUREDECLARATION_FILLECPL as
select ff.ID,
       ff.IDFACTUREFOURNISSEUR,
       ff.IDPRODUIT,
       ff.QTE,
       ff.PU,
       ff.REMISES,
       ff.IDBCDETAIL,
       ff.TVA,
       p.LIBELLE as produitlib,
       ff.compte,
       f.ETAT,
       ff.iddevise,
       ff.tauxdechange
from FACTUREDECLARATIONFILLE ff
         left join PRODUIT_LIBCPL p on p.id = ff.idproduit
         left join FACTUREDECLARATION F on F.ID = ff.IDFACTUREFOURNISSEUR


    /


create or replace view FACTUREDECLARATION_FILLECOMPTE as
select ff.COMPTE,
       ff.IDFACTUREFOURNISSEUR,
       ff.etat,
       cast(sum(pu * QTE) as number(30, 2))                            as montantht,
       cast(sum(pu * QTE * (tva / 100)) as number(30, 2))              as montanttva,
       cast(sum((pu * QTE) + pu * QTE * (tva / 100)) as number(30, 2)) as montantttc,
       ff.iddevise,
       ff.tauxdechange
from FACTUREDECLARATION_FILLECPL ff
group by COMPTE, IDFACTUREFOURNISSEUR, ff.etat,ff.iddevise,ff.tauxdechange


    /


create or replace view FACTUREDECLARATION_FILLE_VISE as
select COMPTE,IDFACTUREFOURNISSEUR,ETAT,MONTANTHT,MONTANTTVA,MONTANTTTC,iddevise,tauxdechange
from FACTUREDECLARATION_FILLECOMPTE
where etat = 11


    /


