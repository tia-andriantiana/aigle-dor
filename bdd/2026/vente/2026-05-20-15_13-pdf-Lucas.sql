
CREATE OR REPLACE  VIEW V_ETATSTOCK_ING_GP_PDF (ID, IDPRODUITLIB, RESTE,IDTYPEPRODUITLIB,PU,montantreste) AS
  select ving.id,ving.idProduitLib,sum(ving.reste) as reste,tp.val as IDTYPEPRODUITLIB ,sum(ving.pu),sum(ving.montantreste)
from V_ETATSTOCK_ING ving
LEFT JOIN as_ingredients aig ON aig.id=ving.id
LEFT JOIN type_produit tp ON aig.typeproduit=tp.id
where ving.CATEGORIEINGREDIENT = 'CAT008'
group by ving.idProduitLib, ving.id,tp.val;


CREATE OR REPLACE  VIEW V_ETATSTOCK_ING_ENG_PDF (ID, IDPRODUITLIB, RESTE, SORTIE, ENTREE,IDTYPEPRODUITLIB,PU,montantreste) AS 
  select
    v.id,
    v.idProduitLib,
    v.reste,
    NVL(s.SORTIE, 0) as SORTIE,
    v.RESTE - NVL(s.SORTIE, 0) as entree,
    v.IDTYPEPRODUITLIB,
    v.pu,
    v.montantreste
from V_ETATSTOCK_ING_GP_PDF v
         left join STOCK_ENGAGE_FILLE_GP s
                   on v.id = s.IDPRODUIT;