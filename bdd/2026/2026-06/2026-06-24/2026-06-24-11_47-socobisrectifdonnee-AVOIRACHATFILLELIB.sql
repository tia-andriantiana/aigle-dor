create or replace view AVOIRACHATFILLELIB AS
SELECT
    af.ID,
    af.IDMERE,
    af.IDPRODUIT,
    af.QTE,
    af.PU,
    af.REMISE,
    af.TVA,
    af.IDDEVISE,
    af.TAUX,
    af.DESIGNATION,
    af.IDFACTUREDETAILS,
    p.id AS idproduitLib,
    d.id AS iddeviseLib
FROM AVOIRACHATFILLE af
	LEFT JOIN AS_INGREDIENTS p ON af.IDPRODUIT = p.ID
	LEFT JOIN DEVISE d ON af.IDDEVISE = d.ID;