CREATE OR REPLACE VIEW budget_depense_sum_view_budget as
SELECT * FROM budget_depense_sum_view WHERE mois IS NOT NULL AND ANNEE IS NOT NULL ;

CREATE OR REPLACE VIEW SITUATION_BUDGET_DEPENSES AS
SELECT SQ.ID,SQ.COMPTE,SQ.SERVICE,SQ.MOIS,SQ.ANNEE,SQ.MOISLIB,SQ.BUDGET,SQ.MONTANTFACTURE,SQ.PAIEMENT,SQ.RESTEAPAYER,SQ.ECARTFACTUREBUDGET,SQ.ECARTBUDGETPAIEMENT,
       (NVL(TO_CHAR(ID),'') || ' | ' || NVL(TO_CHAR(COMPTE),'') || ' | ' || NVL(TO_CHAR(SERVICE),'') || ' | ' || NVL(TO_CHAR(MOIS),'') || ' | ' || NVL(TO_CHAR(ANNEE),'') || ' | ' || NVL(TO_CHAR(MOISLIB),'') || ' | ' || NVL(TO_CHAR(BUDGET),'') || ' | ' || NVL(TO_CHAR(MONTANTFACTURE),'') || ' | ' || NVL(TO_CHAR(PAIEMENT),'') || ' | ' || NVL(TO_CHAR(RESTEAPAYER),'') || ' | ' || NVL(TO_CHAR(ECARTFACTUREBUDGET),'') || ' | ' || NVL(TO_CHAR(ECARTBUDGETPAIEMENT),'')) AS MOTSCLESSS
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
                      cross join (select distinct COMPTE from budget_depense_sum_view_budget) bdsv_inner
             where SUBSTR(ffp.compteregr, 1, LENGTH(bdsv_inner.COMPTE)) = bdsv_inner.COMPTE
             group by SUBSTR(compteregr, 1, LENGTH(bdsv_inner.COMPTE)), mois, annee, SERVICE
         ) ffc
                            on ffc.compteregr_groupe like bdsv.COMPTE||'%'
                                and ffc.mois = bdsv.mois
                                and ffc.annee = bdsv.annee
                                and ffc.SERVICE = bdsv.SERVICE
     ) SQ;