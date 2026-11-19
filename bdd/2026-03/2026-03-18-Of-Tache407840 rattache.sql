CREATE OR REPLACE VIEW OFRattache AS (
SELECT
	r.IDRELEVE AS idcompteur,
	fab.id AS idfabrication,
	r.daty AS daty,
	o.idingredients AS idproduit,
	ai.libelle AS nomproduit,
	o.qte AS qte,
	COALESCE (o.qte*e.nbcarton,0) AS qtepetri,
	ai.IDLIGNE AS idLigne,
	l.VAL AS ligne
FROM
	OFFILLE o
	LEFT JOIN fabrication fab ON fab.idoffille = o.id
	LEFT JOIN RELEVEFAB r ON r.IDFAB =fab.id
	LEFT JOIN AS_INGREDIENT_MAINTENANCE ai ON ai.IDINGREDIENT= o.IDINGREDIENTS
	LEFT JOIN EQUIVALENCECARTON e ON e.IDPETRIS =o.IDINGREDIENTS
	LEFT JOIN LIGNE l ON l.id=ai.IDLIGNE );