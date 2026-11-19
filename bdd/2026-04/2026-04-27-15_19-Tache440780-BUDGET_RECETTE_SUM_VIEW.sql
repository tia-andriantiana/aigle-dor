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
    where mois is not null and ANNEE is not null
    group by COMPTE, mois, annee, moislib, IDSERVICELIB, SERVICE
) SQ;