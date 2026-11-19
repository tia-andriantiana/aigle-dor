  CREATE OR REPLACE  VIEW PROFORMA_DETAILS_VIDE AS
  select p.ID,
	       p.IDPROFORMA,
	       p.IDPRODUIT,
	       p.IDORIGINE,
	       p.QTE,
	       p.PU,
	       p.REMISE,
	       p.TVA,
	       p.PUACHAT,
	       p.PUVENTE,
	       p.IDDEVISE,
	       p.TAUXDECHANGE,
	       p.DESIGNATION,
	       p.COMPTE,
	       p.PUREVIENT,
	       p.IDDEMANDEPRIXFILLE,
	       p.UNITE,
	       p.DATEDEBUT,
	       u.val as unitelib,
	       0  as punet,
	       0  as montantht,
	       0  as montantttc,
	       p.RISTOURNE,
	       ing.CALORIE 
	from PROFORMA_DETAILS p
		LEFT JOIN as_unite u ON p.unite=u.id
		LEFT JOIN  AS_INGREDIENTS ing ON p.IDPRODUIT = ing.ID
	 
 ;