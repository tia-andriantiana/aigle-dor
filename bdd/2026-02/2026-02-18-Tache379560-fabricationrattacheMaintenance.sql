ALTER TABLE AS_INGREDIENTS
ADD ISPETRI NUMBER(1,0) DEFAULT 0;

CREATE OR REPLACE VIEW FabricationRattache as
select 
    r.idreleve as idcompteur,
    f.id as idFabrication,
    r.daty,
    ff.IDINGREDIENTS AS idproduit,
    ai.libelle AS nomProduit,
    ff.qte,
    a.quantite AS qtePetri,
    l.id AS idligne,
    l.val AS ligne
FROM
	ReleveFab r 
    left join Fabrication f on f.id = r.idFab
    left join Offille o on f.idOffille = o.id
	LEFT JOIN FABRICATIONFILLE ff ON ff.IDMERE =f.ID 
    LEFT JOIN AS_INGREDIENTS ai ON ai.id=ff.IDINGREDIENTS 
    left join AS_RECETTEOFFFABTABLE a on o.id = a.IDPRODUITS
	LEFT JOIN AS_INGREDIENT_MAINTENANCE m ON m.id=ff.IDMACHINE 
	LEFT JOIN ligne l ON l.id=m.idligne
    where ai.ispetri=0;

