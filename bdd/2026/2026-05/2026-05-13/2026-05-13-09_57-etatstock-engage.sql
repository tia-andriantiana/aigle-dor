create or replace view V_ETATSTOCK_ING_GP as
select id,idProduitLib,sum(reste) as reste
from V_ETATSTOCK_ING where CATEGORIEINGREDIENT = 'CAT008'
group by idProduitLib, id;

create or replace view STOCK_ENGAGE_FILLE_GP as
select IDPRODUIT, sum(SORTIE) as sortie
from STOCK_ENGAGE_FILLE
group by IDPRODUIT;

create or replace view V_ETATSTOCK_ING_Eng as
select
    v.id,
    v.idProduitLib,
    v.reste,
    NVL(s.SORTIE, 0) as SORTIE,
    v.RESTE - NVL(s.SORTIE, 0) as entree
from V_ETATSTOCK_ING_GP v
         left join STOCK_ENGAGE_FILLE_GP s
                   on v.id = s.IDPRODUIT;