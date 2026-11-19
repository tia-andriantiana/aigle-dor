create or replace view FACTUREFOURNISSEURCPL as
SELECT
    f.ID,
    f.IDFOURNISSEUR,
    f2.NOM  AS IDFOURNISSEURLIB,
    f.IDMODEPAIEMENT,
    m.VAL   AS IDMODEPAIEMENTLIB,
    f.DATY,
    f.DESIGNATION,
    f.DATEECHEANCEPAIEMENT,
    f.ETAT,
    CASE
        WHEN f.ETAT = 1
            THEN 'CR&Eacute;&Eacute;E'
        WHEN f.ETAT = 0
            THEN 'ANNUL&Eacute;E'
        WHEN f.ETAT = 11
            THEN 'VIS&Eacute;E'
        END AS ETATLIB,
    reff.reference,
    f.IDBC,
    f.IDMAGASIN,
    f.DEVISE,
    case
        when f.TAUX=0 then 1
        else f.TAUX
        end as taux,
    p.VAL   AS idMagasinLib,
    f3.IDDEVISE,
    cast(f3.MONTANTTVA as number(30,2)) as MONTANTTVA,
    CAST(f3.MONTANTTTC-f3.MONTANTTVA as number(30,2)) AS MONTANTHT,
    cast(f3.MONTANTTTC as number(30,2)) as montantttc,
    cast(f3.MONTANTTTC*f3.tauxdechange as number(30,2)) as MONTANTTTCAR,
    cast(nvl(mv.debit,0) AS NUMBER(30,2)) AS montantpaye,
    cast(f3.MONTANTTTC-nvl(mv.debit,0) AS NUMBER(30,2)) AS montantreste,
    cast(nvl(f3.tauxdechange,0) AS  NUMBER(30,2)) AS tauxdechange,
    prev.id as idPrevision,
    CASE
        WHEN f.estprevu=0 THEN 'NON'
        ELSE 'OUI'
        END
        AS estprevulib,
    f.IDOBJET,
    f.IDREF,
    f.IDTYPEFACTURE,
    tf.VAL as typefacture,
    f.numero,
    f.typeachat,
    f.idfactureprincipale,
    s.libelle AS idServiceLib,
    f.SERVICE
FROM FACTUREFOURNISSEUR f
         LEFT JOIN FOURNISSEUR f2 ON f2.ID = f.IDFOURNISSEUR
         LEFT JOIN MODEPAIEMENT m ON m.ID = f.IDMODEPAIEMENT
         LEFT JOIN MAGASIN p ON p.ID = f.IDMAGASIN
         JOIN FACTUREFOURNISSEURMONTANT f3 ON f.ID = f3.id
         LEFT JOIN mouvementcaisseGroupeFacture mv ON f.id=mv.IDORIGINE
         LEFT JOIN prevision prev ON prev.idfacture=f.id
         left join type_facture tf on tf.id = f.IDTYPEFACTURE
         LEFT JOIN SERVICE s ON f.SERVICE = s.COMPTE
         LEFT JOIN referencefacture reff ON f.id=reff.idfacture

create or replace view FACTUREFOURNISSEURFILLE_PAYE as
SELECT FFF.ID,
       FFF.IDFACTUREFOURNISSEUR,
       FFF.IDPRODUIT,
       FFF.QTE,
       FFF.PU,
       FFF.REMISES,
       FFF.IDBCDETAIL,
       FFF.TVA,
       FFF.PRODUITLIB,
       FFF.COMPTE,
       FFF.COMPTE                                                               AS compteregr,
       FFF.ETAT,
       FFF.IDDEVISE,
       FFF.TAUXDECHANGE,
       FF.MONTANTTTC,
       FFF.MOIS,
       FFF.ANNEE,
       FF.DATY,
       FF.MONTANTPAYE * 100 / NULLIF(FF.MONTANTTTC, 0)                                                     AS pourcentagepaye,
       (FF.MONTANTPAYE / NULLIF(FF.MONTANTTTC, 0)) * (FFF.QTE * FFF.PU)                                    AS MontantFillePaye,
       (FFF.QTE * FFF.PU) - ((FF.MONTANTPAYE / NULLIF(FF.MONTANTTTC, 0)) * (FFF.QTE * FFF.PU))             AS resteapayerfille,
       ((FF.MONTANTPAYE / NULLIF(FF.MONTANTTTC, 0)) * (FFF.QTE * FFF.PU)) * FFF.TAUXDECHANGE               AS MontantFillePayeAr,
       (FFF.QTE * FFF.PU)                                                                                   AS montantfille,
       FF.SERVICE
FROM FACTUREFOURNISSEUR_FILLECPL FFF
         LEFT JOIN FACTUREFOURNISSEURCPL FF ON FF.ID = FFF.IDFACTUREFOURNISSEUR

create or replace view PREVISION_CPL as
select
    p.id,
    p.designation,
    p.idcaisse,
    c.val as idcaisselib,
    p.idventedetail,
    v.IDVENTE,
    v2.designation as idventelib,
    p.idvirement,
    p.debit,
    p.credit,
    p.daty,
    p.etat,
    p.idop,
    o.DESIGNATION as idoplib ,
    p.idorigine,
    p.iddevise,
    p.designation as iddeviselib,
    p.taux,
    p.idtiers,
    p.compte,
    p.idfacture,
    v2.IDRESERVATION,
    p.dateinitial,
    p.dureeretard,
    p.mois,
    p.annee,
    TO_CHAR(
            TO_DATE(TO_CHAR(p.mois, 'FM00'), 'MM'),
            'FMMonth',
            'NLS_DATE_LANGUAGE=FRENCH'
    ) AS moisLib,
    p.SERVICE,
    s.libelle AS idServiceLib
from PREVISION p
         left join caisse c on p.idcaisse = c.id
         left join VENTE_DETAILS v on p.IDVENTEDETAIL=v.ID
         left join vente v2 on v2.id=v.IDVENTE
         left join ORDONNERPAIEMENT o on o.id=p.IDOP
         LEFT JOIN SERVICE s ON p.SERVICE = s.COMPTE
         left join devise d on d.id=p.IDDEVISE;

create or replace view BUDGET_DEPENSE_SUM_VIEW as
select COMPTE,
       mois,
       annee,
       moislib,
       sum(debit) as depenses,
       IDSERVICELIB,
       SERVICE
from PREVISION_CPL
group by COMPTE, mois, annee, moislib, IDSERVICELIB, SERVICE;

CREATE OR REPLACE VIEW SITUATION_BUDGET_DEPENSES AS
select
    '-' as id,
    bdsv.COMPTE,
    IDSERVICELIB as service,
    bdsv.mois,
    bdsv.annee,
    bdsv.moislib,
    bdsv.depenses as budget,
    ffc.montant as montantfacture,
    ffc.montantpaye as paiement,
    ffc.resteapayer,
    bdsv.depenses - ffc.montant as ecartfacturebudget,
    bdsv.depenses - ffc.montantpaye as ecartbudgetpaiement
from budget_depense_sum_view bdsv
    left join (
        select
            SUBSTR(compteregr, 1, LENGTH(bdsv_inner.COMPTE)) as compteregr_groupe,
            mois,
            annee,
            SERVICE,
            sum(montantfille * TAUXDECHANGE)     as montant,
            sum(MontantFillePaye * TAUXDECHANGE) as montantpaye,
            sum(resteapayerfille * TAUXDECHANGE) as resteapayer
        from facturefournisseurfille_paye ffp
        cross join (select distinct COMPTE from budget_depense_sum_view) bdsv_inner
        where SUBSTR(ffp.compteregr, 1, LENGTH(bdsv_inner.COMPTE)) = bdsv_inner.COMPTE
        group by SUBSTR(compteregr, 1, LENGTH(bdsv_inner.COMPTE)), mois, annee, SERVICE
    ) ffc
    on ffc.compteregr_groupe like bdsv.COMPTE||'%'
        and ffc.mois = bdsv.mois
        and ffc.annee = bdsv.annee
        and ffc.SERVICE = bdsv.SERVICE;

