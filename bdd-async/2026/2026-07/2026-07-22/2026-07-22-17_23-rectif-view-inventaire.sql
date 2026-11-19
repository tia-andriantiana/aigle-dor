CREATE OR REPLACE VIEW inventairefilleupdate AS
SELECT
	inf.id,
	inf.idinventaire,
	inf.idproduit,
	ai.LIBELLE ||' - '|| inf.explication AS explication,
	inf.idjauge,
	inf.quantitetheorique,
	inf.quantite,
	inf.mvtsrc,
	inf.pu,
	inf.idfournisseur,
	inf.daty
FROM inventairefille inf
LEFT JOIN AS_INGREDIENTS ai ON ai.id=inf.idproduit;