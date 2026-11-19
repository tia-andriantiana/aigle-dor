create or replace view BUDGET_RECETTE_SUM_VIEW as
SELECT SQ.COMPTE,
       SQ.MOIS,
       SQ.ANNEE,
       SQ.MOISLIB,
       SQ.DEPENSES,
       SQ.IDSERVICELIB,
       SQ.SERVICE
FROM (
     select COMPTE,
            mois,
            annee,
            moislib,
            sum(credit) as depenses,
            IDSERVICELIB,
            SERVICE
     from PREVISION_CPL
     group by COMPTE, mois, annee, moislib, IDSERVICELIB, SERVICE
 ) SQ;

create or replace view VENTE_DETAILS_PAYE as
SELECT
    VD.ID,
    VD.IDVENTE,
    VD.IDPRODUIT,
    VD.IDORIGINE,
    VD.QTE,
    VD.PU,
    VD.REMISE,
    VD.TVA,
    VD.PUACHAT,
    VD.PUVENTE,
    VD.IDDEVISE,
    VD.TAUXDECHANGE,
    VD.DESIGNATION,
    VD.COMPTE,
    VD.PUREVIENT,
    VD.IDBCFILLE,
    VD.UNITE,
    VD.POIDS,
    VD.RISTOURNE,
    VD.IDPREVISION,
    V.MOIS,
    V.ANNEE,
    V.MONTANTPAYE * 100 / NULLIF(V.MONTANTTTC,0) AS  pourcentagepaye,
    (V.MONTANTPAYE / NULLIF(V.MONTANTTTC, 0)) * (VD.QTE * VD.PU) AS MontantFillePaye,
    (VD.QTE * VD.PU) - ((V.MONTANTPAYE / NULLIF(V.MONTANTTTC, 0)) * (VD.QTE * VD.PU))   AS resteapayerfille,
    ((V.MONTANTPAYE / NULLIF(V.MONTANTTTC, 0)) * (VD.QTE * VD.PU)) * VD.TAUXDECHANGE AS MontantFillePayeAr,
    (VD.QTE * VD.PU) AS montantfille
FROM VENTE_DETAILS VD
    LEFT JOIN VENTE_CPL V ON V.ID = VD.IDVENTE;


create OR REPLACE view SITUATION_BUDGET_RECETTES as
SELECT SQ.ID,
       SQ.COMPTE,
       SQ.SERVICE,
       SQ.MOIS,
       SQ.ANNEE,
       SQ.MOISLIB,
       SQ.BUDGET,
       SQ.MONTANTFACTURE,
       SQ.PAIEMENT,
       SQ.RESTEAPAYER,
       SQ.ECARTFACTUREBUDGET,
       SQ.ECARTBUDGETPAIEMENT
FROM (
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
from BUDGET_RECETTE_SUM_VIEW bdsv
    left join (
        select
            SUBSTR(ffp.compte, 1, LENGTH(bdsv_inner.COMPTE)) as compteregr_groupe,
            mois,
            annee,
            sum(montantfille * TAUXDECHANGE)     as montant,
            sum(MontantFillePaye * TAUXDECHANGE) as montantpaye,
            sum(resteapayerfille * TAUXDECHANGE) as resteapayer
        from VENTE_DETAILS_PAYE ffp
        cross join (select distinct COMPTE from BUDGET_RECETTE_SUM_VIEW) bdsv_inner
        where SUBSTR(ffp.compte, 1, LENGTH(bdsv_inner.COMPTE)) = bdsv_inner.COMPTE
        group by SUBSTR(ffp.compte, 1, LENGTH(bdsv_inner.COMPTE)), mois, annee
    ) ffc
    on ffc.compteregr_groupe like bdsv.COMPTE||'%'
        and ffc.mois = bdsv.mois
        and ffc.annee = bdsv.annee
) SQ;

create or replace view SITUATION_BUDGET_RECETTES_VIDE as
SELECT SQ.ID,
       SQ.COMPTE,
       SQ.SERVICE,
       SQ.ANNEE,
       SQ.MOISDEBUT,
       SQ.MOISDEBUTLIB,
       SQ.MOISFIN,
       SQ.MOISFINLIB,
       SQ.BUDGET,
       SQ.MONTANTFACTURE,
       SQ.PAIEMENT,
       SQ.RESTEAPAYER,
       SQ.ECARTFACTUREBUDGET,
       SQ.ECARTBUDGETPAIEMENT
FROM (
select id, compte, service, annee, 6 as moisdebut,moisdebutlib, 8 as moisfin,moisfinlib, budget, montantfacture, paiement, resteapayer, ECARTFACTUREBUDGET, ECARTBUDGETPAIEMENT from
(select ID,
    COMPTE,
    SERVICE,
    ANNEE,
    sum(nvl(BUDGET, 0)) as budget,
    sum(nvl(MONTANTFACTURE, 0)) as montantfacture,
    sum(nvl(PAIEMENT, 0)) as paiement,
    SUM(nvl(RESTEAPAYER, 0)) as resteapayer,
    SUM(nvl(ECARTFACTUREBUDGET, 0)) as ECARTFACTUREBUDGET,
    SUM(nvl(ECARTBUDGETPAIEMENT, 0)) as ECARTBUDGETPAIEMENT,
    TO_CHAR(
        TO_DATE(TO_CHAR(6, 'FM00'), 'MM'),
        'FMMonth',
        'NLS_DATE_LANGUAGE=FRENCH'
    ) AS moisdebutlib,
    TO_CHAR(
        TO_DATE(TO_CHAR(8, 'FM00'), 'MM'),
        'FMMonth',
        'NLS_DATE_LANGUAGE=FRENCH'
    ) AS moisfinlib
    from SITUATION_BUDGET_RECETTES where mois between 6 and 8 group by ID, COMPTE, SERVICE, ANNEE)
) SQ;


INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MENUDYANN007', 'Situation recette', 'view_list', 'module.jsp?but=budget/budget-recettes-liste.jsp', 6, 2, 'MENUDYN003');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MENUDYANN1607007', 'Situation recette annuelle', 'view_list', 'module.jsp?but=budget/budget-recettes-annuel.jsp', 7, 2, 'MENUDYN003');
