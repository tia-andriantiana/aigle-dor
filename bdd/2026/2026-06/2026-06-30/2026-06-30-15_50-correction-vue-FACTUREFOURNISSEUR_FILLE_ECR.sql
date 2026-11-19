CREATE OR REPLACE VIEW FACTUREFOURNISSEUR_FILLE_ECR AS
select ff.COMPTE,
       ff.IDFACTUREFOURNISSEUR,
       ff.etat,
       cast(sum(ff.pu * ff.QTE) as number(30, 2))                            as montantht,
       cast(sum(ff.pu * ff.QTE * (ff.tva / 100)) as number(30, 2))              as montanttva,
       cast(sum((ff.pu * ff.QTE) + ff.pu * ff.QTE * (ff.tva / 100)) as number(30, 2)) as montantttc,
       ff.iddevise,
       ff.tauxdechange,
       ing.ID as IDPRODUIT
from FACTUREFOURNISSEUR_FILLECPL ff left join AS_INGREDIENTS ing on ing.id=ff.IDPRODUIT
group by COMPTE, IDFACTUREFOURNISSEUR, ff.etat,ff.iddevise,ff.tauxdechange, ing.ID
;