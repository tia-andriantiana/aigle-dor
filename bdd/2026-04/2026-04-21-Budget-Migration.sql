ALTER TABLE PREVISION ADD
MOIS    NUMBER;

ALTER TABLE PREVISION ADD
ANNEE    NUMBER;

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
    ) AS moisLib
from PREVISION p
         left join caisse c on p.idcaisse = c.id
         left join VENTE_DETAILS v on p.IDVENTEDETAIL=v.ID
         left join vente v2 on v2.id=v.IDVENTE
         left join ORDONNERPAIEMENT o on o.id=p.IDOP
         left join devise d on d.id=p.IDDEVISE;

create or replace view BUDGET_DEPENSE_SUM_VIEW as
select COMPTE,
       mois,
       annee,
       moislib,
       sum(debit) as depenses
from PREVISION_CPL
group by COMPTE, mois, annee, moislib;


create or replace view FACTUREFOURNISSEUR_FILLECPL as
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
       ff.tauxdechange,
       ff.MOIS,
       ff.ANNEE
from FACTUREFOURNISSEURFILLE ff
    left join PRODUIT_LIBCPL p on p.id = ff.idproduit
    left join FACTUREFOURNISSEUR F on F.ID = ff.IDFACTUREFOURNISSEUR;

create or replace view FACTUREFOURNISSEURFILLE_PAYE as
select FFF.ID,
       FFF.IDFACTUREFOURNISSEUR,
       FFF.IDPRODUIT,
       FFF.QTE,
       FFF.PU,
       FFF.REMISES,
       FFF.IDBCDETAIL,
       FFF.TVA,
       FFF.PRODUITLIB,
       FFF.COMPTE,
       substr(FFF.COMPTE, 1, 2)                                                                   as compteregr,
       FFF.ETAT,
       FFF.IDDEVISE,
       FFF.TAUXDECHANGE,
       FF.MONTANTTTC,
       --extract(month from FF.DATY) as mois,
       --extract(year from FF.daty) as annee,
       fff.mois,
       fff.annee,
       ff.daty,
       FF.MONTANTPAYE * 100 / FF.MONTANTTTC                                                       as pourcentagepaye,
       ((FF.MONTANTPAYE * 100 / FF.MONTANTTTC) / 100) * (FFF.QTE * FFF.PU)                        as MontantFillePaye,
       (FFF.QTE * FFF.PU) - (((FF.MONTANTPAYE * 100 / FF.MONTANTTTC) / 100) * (FFF.QTE * FFF.PU)) as resteapayerfille,
       (((FF.MONTANTPAYE * 100 / FF.MONTANTTTC) / 100) * (FFF.QTE * FFF.PU)) * FFF.TAUXDECHANGE   as MontantFillePayeAr,
       (FFF.QTE * FFF.PU)                                                                         as montantfille
from FACTUREFOURNISSEUR_FILLECPL FFF
         LEFT JOIN FACTUREFOURNISSEURCPL FF ON FF.ID = FFF.IDFACTUREFOURNISSEUR;

create or replace view FACTUREFOURNISSEUR_COMPTEREGR as
select compteregr,
       mois,
       annee,
       sum(montantfille * TAUXDECHANGE)     as montant,
       sum(MontantFillePaye * TAUXDECHANGE) as montantpaye,
       sum(resteapayerfille * TAUXDECHANGE) as resteapayer
from facturefournisseurfille_paye
group by compteregr, mois, annee;

create table SERVICE
(
    ID      VARCHAR2(100)  primary key,
    LIBELLE VARCHAR2(255),
    CODE    VARCHAR2(255),
    COMPTE  VARCHAR2(255)
);

CREATE SEQUENCE SEQ_service INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE OR REPLACE FUNCTION getseqservice
    RETURN NUMBER IS
    retour NUMBER;
BEGIN
    SELECT SEQ_service.nextval INTO retour FROM dual;
    return retour;
END;

create or replace  view SITUATION_BUDGET_DEPENSES as
select '-' as id,
       bdsv.COMPTE,
       s.LIBELLE as service,
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
         left join facturefournisseur_compteregr ffc
                   on ffc.compteregr = bdsv.COMPTE and ffc.mois = bdsv.mois and ffc.annee = bdsv.annee
         left join service s on s.compte = bdsv.COMPTE;
