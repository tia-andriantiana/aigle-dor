alter table AS_INGREDIENTS add COMPTE_TVA varchar(100);

create or replace view FACTUREFOURNISSEUR_FILLE_ECR as
select ff.COMPTE,
       ff.IDFACTUREFOURNISSEUR,
       ff.etat,
       cast(sum(pu * QTE) as number(30, 2))                            as montantht,
       cast(sum(pu * QTE * (tva / 100)) as number(30, 2))              as montanttva,
       cast(sum((pu * QTE) + pu * QTE * (tva / 100)) as number(30, 2)) as montantttc,
       ff.iddevise,
       ff.tauxdechange,
       IDPRODUIT
from FACTUREFOURNISSEUR_FILLECPL ff
group by COMPTE, IDFACTUREFOURNISSEUR, ff.etat,ff.iddevise,ff.tauxdechange, IDPRODUIT;

create or replace view LIAISONCODESAISIE as
SELECT
    id,
    idCodeImpot,
    idCompte,
    ' ' AS valeur,
    FORMULE,
    TAXABLE
FROM LiaisonCodeImpot;