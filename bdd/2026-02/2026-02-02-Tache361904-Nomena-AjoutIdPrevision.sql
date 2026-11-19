
create or replace view UPDATEVENTEDETAILS as
SELECT
    vd.ID,
    vd.IDVENTE,
    vd.IDPRODUIT,
    p.LIBELLE AS idProduitLib,
    vd.IDORIGINE,
    vd.QTE,
    vd.PU,
    vd.REMISE,
    vd.TVA,
    vd.PUACHAT,
    vd.PUVENTE,
    vd.IDDEVISE,
    vd.TAUXDECHANGE,
    vd.DESIGNATION,
    vd.COMPTE,
    vd.idprevision
FROM
    VENTE_DETAILS vd
        LEFT JOIN AS_INGREDIENTS p ON
        p.ID = vd.IDPRODUIT;
