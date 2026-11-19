 
 CREATE OR REPLACE  VIEW BONDECOMMANDE_CLIENT_FILLE_V AS 
  select p.ID,
	       p.PRODUIT,
	       p.IDBC,
	       p.QUANTITE,
	       p.PU,
	       p.MONTANT,
	       p.TVA,
	       p.REMISE,
	       p.IDDEVISE,
	       p.UNITE,
	       p.DESIGNATION,
	       uni.val as unitelib,
	       0  as punet,
	       0  as montantht,
	       0  as montantttc,
	       p.RISTOURNE,
	       ing.calorie
	from BONDECOMMANDE_CLIENT_FILLE p
		LEFT JOIN as_unite uni ON p.unite = uni.id
		LEFT JOIN  AS_INGREDIENTS ing ON p.PRODUIT = ing.ID
	 
 ;