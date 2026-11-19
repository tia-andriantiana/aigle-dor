create or replace view AVOIRACHATFILLELIB as
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
    p.LIBELLE AS idproduitLib,
    d.val AS iddeviseLib,
    ----------------------------------------------------------
    -- 1 Montant HT brut
    ----------------------------------------------------------
    CAST(af.QTE * af.PU AS NUMBER(30, 2)) AS montant,
    ----------------------------------------------------------
    -- 2 Montant remise (appliquee sur HT)
    ----------------------------------------------------------
    CAST((NVL(af.REMISE, 0) / 100) * (af.QTE * af.PU) AS NUMBER(30, 2)) AS montantRemise,
    ----------------------------------------------------------
    -- 3 Montant HT net apres remise
    ----------------------------------------------------------
    CAST((af.QTE * af.PU) - ((NVL(af.REMISE, 0) / 100) * (af.QTE * af.PU)) AS NUMBER(30, 2)) AS montantht,
    ----------------------------------------------------------
    -- 4 TVA sur montant HT net
    ----------------------------------------------------------
    CAST(((af.QTE * af.PU) - ((NVL(af.REMISE, 0) / 100) * (af.QTE * af.PU))) * af.TVA / 100 AS NUMBER(30, 2))AS montanttva,
    ----------------------------------------------------------
    -- 5 Montant TTC net (HT net + TVA)
    ----------------------------------------------------------
    CAST( ((af.QTE * af.PU) - ((NVL(af.REMISE, 0) / 100) * (af.QTE * af.PU))) + ( ((af.QTE * af.PU) - ((NVL(af.REMISE, 0) / 100) * (af.QTE * af.PU)))  * af.TVA / 100  ) AS NUMBER(30, 2)) AS montantttc
FROM AVOIRACHATFILLE af
    LEFT JOIN AS_INGREDIENTS p ON af.IDPRODUIT = p.ID
    LEFT JOIN DEVISE d ON af.IDDEVISE = d.ID;