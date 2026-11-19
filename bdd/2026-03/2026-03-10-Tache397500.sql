CREATE OR REPLACE FORCE VIEW OFNONRATTACHE AS 
SELECT
	offille.id AS idoffille,
	o.daty AS daty,
	offille.IDINGREDIENTS AS idproduit,
	ai.LIBELLE AS idproduitLib,
	offille.qte AS qte,
	ofabrecet.quantite AS qtepetri,
	ofabrecet.qteav AS qteav,
	tp.idligne AS idligne,
	l.VAL AS ligne
FROM 
ofab o 
LEFT join offille offille ON o.id=offille.idmere
LEFT JOIN AS_RECETTEOFFFABTABLE ofabrecet ON ofabrecet.idingredients=offille.idingredients
LEFT JOIN AS_INGREDIENTS ai ON ai.id=offille.IDINGREDIENTS
LEFT JOIN TYPE_PRODUIT tp ON tp.ID=ai.typeProduit
LEFT JOIN LIGNE l ON l.id=tp.IDLIGNE;