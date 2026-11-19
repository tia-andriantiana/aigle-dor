CREATE OR REPLACE  VIEW avoirfcfille_grp_viseee  AS 
  SELECT
IDVENTEDETAILS,
SUM(qte) AS qte
FROM
AvoirFCFille abcf
left join AvoirFC b on b.id=abcf.idAvoirFC
where b.ETAT>=11
GROUP BY IDVENTEDETAILS
 ;


CREATE OR REPLACE  VIEW VENTE_DETAILS_RESTE (ID, IDPRODUIT, IDUNITE, UNITELIB, QTE, RESTE, IDVENTE) AS 
  SELECT
    vd.id AS id,
    vd.idProduit,
    vd.UNITE as idunite,
    u.VAL AS unitelib,
    vd.qte AS QTE,
    (nvl(vd.QTE,0) - nvl(bl.QUANTITE,0))- nvl(avcf.qte,0) AS reste,
    vd.IDVENTE AS IDVENTE
FROM
    VENTE_DETAILS vd LEFT JOIN
    BL_CLIENT_FILLE_grp_vente bl ON vd.ID = bl.idventedetail
                     LEFT JOIN AS_INGREDIENTS p ON
        p.id = vd.IDPRODUIT
                     left join AS_UNITE u on u.id = vd.unite
      LEFT JOIN
    avoirfcfille_grp_viseee avcf ON vd.ID = avcf.idventedetails
 ;
