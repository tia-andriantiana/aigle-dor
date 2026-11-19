  
  CREATE OR REPLACE  VIEW MVTSTOCKENTREEAVECRESTE AS 
  SELECT
	m.ID,
	m.IDMVTSTOCK,
	m.IDPRODUIT,
	m.ENTREE,
	s.SORTIE,
	m.IDVENTEDETAIL,
	m.IDTRANSFERTDETAIL,
	m.PU,
	m.MVTSRC,
	mp.DATY,
	NVL(m.entree,0)- NVL(s.sortie, 0) AS reste,
	NVL(m.entree,0)- NVL(s.sortie, 0) AS quantite,
	--ity no reste miasa any
 mp.IDMAGASIN,
 m.IDINVENTAIREFILLE,
 mp.IDOBJET,
 mp.IDTRANSFERT
FROM
	MVTSTOCKFILLE m
LEFT JOIN MVTSTOCK mp ON
	mp.id = m.IDMVTSTOCK
LEFT JOIN sortieEntree s ON
	s.MVTSRC = m.id 
WHERE
	m.ENTREE >0
	AND mp.ETAT >= 11
 
 ;
  
  
  CREATE OR REPLACE  VIEW V_ETATSTOCK_ENTREE AS 
  SELECT
    ve.id,
    ai.id AS IDPRODUIT ,
    ai.LIBELLE AS idproduitlib,
    ai.CATEGORIEINGREDIENT ,
    c.VAL AS idtypeproduitlib,
    ve.IDMAGASIN,
    m.VAL AS idmagasinlib,
    CAST(ve.QUANTITE AS number(30,5)) AS QUANTITE ,
    CAST(ve.ENTREE AS number(30,5)) AS ENTREE ,
    CAST(ve.SORTIE AS number(30,5)) AS SORTIE ,
    CAST(ve.RESTE AS number(30,5)) AS RESTE ,
    ai.UNITE ,
    u.VAL AS idunitelib,
    CAST(ve.PU AS number(30,5)) AS PU,
    ve.DATY,
    b.IDFOURNISSEUR as idFournisseur,
    af.nom as idFournisseurLib,
    ve.daty as dateAchat
FROM
    MVTSTOCKENTREEAVECRESTE ve
        LEFT JOIN AS_INGREDIENTS ai ON
        ai.id = ve.IDPRODUIT
        LEFT JOIN CATEGORIEINGREDIENT c ON
        ai.CATEGORIEINGREDIENT = c.id
        LEFT JOIN MAGASIN2 m ON
        ve.IDMAGASIN = m.id
        LEFT JOIN UNITE u ON ai.UNITE = u.id
        LEFT JOIN AS_BONDELIVRAISON b ON b.ID = ve.IDOBJET
        LEFT JOIN AS_BONDELIVRAISON bb ON b.ID = ve.IDTRANSFERT
        LEFT JOIN FACTUREFOURNISSEUR f on f.id=b.IDFACTUREFOURNISSEUR
        LEFT JOIN INVENTAIREFILLE invf ON invf.id = ve.IDINVENTAIREFILLE
        LEFT Join FOURNISSEUR af ON af.id = f.idfournisseur
WHERE ve.RESTE > 0 and ve.pu > 0
 
 ;
