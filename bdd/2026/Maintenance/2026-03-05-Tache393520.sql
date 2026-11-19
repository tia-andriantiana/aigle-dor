UPDATE AS_INGREDIENTS
SET ISPETRI = 1
WHERE LIBELLE LIKE '%Petri%';

CREATE OR REPLACE VIEW OFNONRATTACHE AS 
SELECT
	offille.id AS idoffille,
	f.daty AS daty,
	ffille.IDINGREDIENTS AS idproduit,
	ai.LIBELLE AS idproduitLib,
	ffille.qte AS qte,
	ffille.qte AS qtepetri,
	l.id AS idligne,
	l.VAL AS ligne
FROM 
ofab o 
LEFT join offille offille ON o.id=offille.idmere
LEFT JOIN FABRICATIONCPL f ON f.idoffille=offille.id
LEFT JOIN FABRICATIONFILLE ffille ON f.ID =FFILLE.IDMERE
LEFT JOIN AS_INGREDIENTS ai ON ai.id=ffille.IDINGREDIENTS
LEFT JOIN AS_INGREDIENT_MAINTENANCE aim ON aim.id=ffille.IDMACHINE
LEFT JOIN LIGNE l ON l.id=aim.IDLIGNE
LEFT JOIN RELEVEFAB rfab ON RFAB.IDFAB = f.id
where ai.ispetri=1;