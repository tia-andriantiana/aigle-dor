CREATE OR REPLACE  VIEW BC_CLIENT_FILLE_CPL_LIB (ID, PRODUIT, IDBC, QUANTITE, PU, MONTANT, TVA, REMISE, IDDEVISE, UNITE, PRODUITLIB, COMPTE, QTERESTE, UNITELIB, MONTANTTOTAL, MONTANTDELAREMISE, MONTANTRISTOURNE, MONTANTREMISE, MONTANTTVA, MONTANTTTC, RISTOURNE, FRAISTRANSPORT, POIDSTOTAL) AS 
  SELECT bcf.ID,
	       bcf.PRODUIT,
	       bcf.IDBC,
	       bcf.QUANTITE,
	       bcf.PU,
	       bcf.MONTANT,
	       bcf.TVA,
	       bcf.REMISE,
	       bcf.IDDEVISE,
	       bcf.UNITE,
	       i.LIBELLEVENTE                                                                                                                                      AS PRODUITlib,
	       i.compte_vente                                                                                                                                 AS compte,
	       NVL(bcf.quantite, 0)    - NVL(vdbc.qte, 0)    AS qtereste,   -- nanova qte reste : atao moins qte vendu  avy aminy vente_details_qte_grp                                                                                   
	       au.val                                                                                                                                         AS UNITELIB,
	       cast(NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0) as Number(30, 2))                                                                                   AS MONTANTTOTAL,
	       cast(((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) * (bcf.REMISE / 100)) as number(30, 2))                                                          as montantdelaremise,
	       cast((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0) - ((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) * (bcf.REMISE / 100))) *
	            (bcf.ristourne / 100) as number(30, 2))                                                                                                   as montantristourne,
	       cast(NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0) - ((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) * (bcf.REMISE / 100)) -
	            ((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0) - ((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) * (bcf.REMISE / 100))) *
	             (bcf.ristourne / 100)) -
	            nvl(i.CALORIE * bcf.QUANTITE * bc.fraislivraison, 0) as number(30, 2))                                                                    as montantremise,
	       CAST(
	               (((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) -
	                 (((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) * (bcf.REMISE / 100)) +
	                  ((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0) -
	                    ((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) * (bcf.REMISE / 100))) * (bcf.ristourne / 100))) -
	                 nvl(i.CALORIE * bcf.QUANTITE * bc.fraislivraison, 0)) *
	                (nvl(bcf.TVA, 0) / 100))
	           AS NUMBER(30, 2)
	       )                                                                                                                                              AS MONTANTTVA,
	       cast((cast((bcf.quantite * bcf.PU) - ((bcf.quantite * bcf.PU) * NVL(bcf.remise, 0)) / 100 as NUMBER(30, 2)) -
	             (cast((bcf.quantite * bcf.PU) - ((bcf.quantite * bcf.PU) * NVL(bcf.remise, 0)) / 100 as NUMBER(30, 2)) *
	              nvl(bcf.ristourne, 0) /
	              100) - nvl(i.CALORIE * bcf.QUANTITE * bc.fraislivraison, 0)) + (nvl(bcf.TVA, 0) / 100) *
	                                                                             (cast((bcf.quantite * bcf.PU) -
	                                                                                   ((bcf.quantite * bcf.PU) * NVL(bcf.remise, 0)) /
	                                                                                   100 as NUMBER(30, 2)) -
	                                                                              (cast((bcf.quantite * bcf.PU) -
	                                                                                    ((bcf.quantite * bcf.PU) * NVL(bcf.remise, 0)) /
	                                                                                    100 as NUMBER(30, 2)) *
	                                                                               nvl(bcf.ristourne, 0) / 100) -
	                                                                              nvl(i.CALORIE * bcf.QUANTITE * bc.fraislivraison, 0)) as number(30, 2)) AS MONTANTTTC,
	       bcf.ristourne,
	       nvl(i.CALORIE * bcf.QUANTITE * bc.fraislivraison, 0)                                                                                           as fraistransport,
	       CAST(NVL(i.CALORIE * bcf.QUANTITE,0) AS NUMBER(30,2)) AS poidstotal
	FROM bondecommande_client_fille bcf
	         left JOIN as_ingredients i ON i.id = bcf.PRODUIT
	         LEFT JOIN vente_details_qte_grp vdbc ON bcf.id = vdbc.idbcfille
	         LEFT JOIN AS_UNITE au ON au.id = i.unite
	         LEFT JOIN BONDECOMMANDE_CLIENT bc on bc.id = bcf.IDBC
 
 ;



CREATE OR REPLACE VIEW VENTE_DETAILS_VIDE (ID, IDVENTE, IDPRODUIT, IDORIGINE, QTE, PU, REMISE, TVA, PUACHAT, PUVENTE, IDDEVISE, TAUXDECHANGE, DESIGNATION, COMPTE, PUREVIENT, IDBCFILLE, UNITE, UNITELIB, PUNET, FRAIS, MONTANTHT, MONTANTTTC, MONTANTTVA, MONTANTREMISE, MONTANT, RISTOURNE, IDCLIENTLIB, DATY, DATYPREVU, IDPRODUITLIB, IDCATEGORIELIB, CATEGORIEPRODUITLIB, POIDS, IDPREVISION, CALORIE, IDRESERVATION, FRAISLIVRAISON) AS 
  select p.ID,
       p.IDVENTE,
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
       p.IDBCFILLE,
       p.UNITE,
       u.VAL                                                                                                   as unitelib,
       cast(p.pu - (p.pu * remise / 100) + ((p.pu * p.tva / 100)) as number(30, 5))                                                   as punet,
       cast(nvl(v.fraislivraison, 0) * NVL(ing.CALORIE, 0) * NVL(p.QTE, 0) as number(30, 5))                                          as frais,
       cast(((p.pu - (p.pu * remise / 100)) * qte - nvl(v.fraislivraison, 0) * NVL(ing.CALORIE, 0) *
                                                    NVL(p.QTE, 0)) as number(30, 5))                                                  as montantht,
       cast(((p.pu - (p.pu * remise / 100)) * qte - nvl(v.fraislivraison, 0) * NVL(ing.CALORIE, 0) * NVL(p.QTE, 0)) +
            ((((p.pu * qte) - (p.pu * remise / 100) * qte) -
              nvl(v.fraislivraison, 0) * NVL(ing.CALORIE, 0) * NVL(p.QTE, 0)) * p.tva /
             100) as number(30, 5))                                                                                                   as montantttc,
       cast(((((p.pu * qte) - (p.pu * remise / 100) * qte) - nvl(v.fraislivraison, 0) * NVL(ing.CALORIE, 0) *
                                                             NVL(p.QTE, 0)) * p.tva / 100) as number(30, 5))                                            as montanttva,
       cast((p.pu * remise / 100) * qte as number(30, 5))                                                                             as montantremise,
       cast((p.pu) * qte as number(30, 5))                                                                                            as montant,
       p.ristourne,
       cl.nom                                                                                                  as idclientlib,
       v.DATY,
       v.DATYPREVU,
       ing.LIBELLEVENTE                                                                                             AS IDPRODUITLIB,
       c.VAL                                                                                                   AS IDCATEGORIELIB,
       c.VAL                                                                                                   AS CATEGORIEPRODUITLIB,
       cast(NVL(ing.CALORIE, 0) * NVL(p.QTE, 0) as number(30, 5))                                                                     as poids,
       p.idprevision,
       ing.calorie,
       v.IDRESERVATION,
       nvl(v.fraislivraison, 0) AS fraislivraison
from VENTE_DETAILS p
         left join AS_UNITE u on u.id = p.unite
         left join vente v on v.id = p.IDVENTE
         LEFT JOIN AS_INGREDIENTS ing
                   ON ing.ID = p.IDPRODUIT
         LEFT JOIN CLIENT cl
                   ON v.IDCLIENT = cl.ID
         LEFT JOIN CATEGORIEINGREDIENT c
                   ON ing.CATEGORIEINGREDIENT = c.ID
                       
 
 ;


CREATE OR REPLACE VIEW AS_BONLIVRFILLE_CLIENT_CPL (ID, PRODUIT, NUMBL, QUANTITE, IDVENTEDETAIL, UNITE, IDBC_FILLE, IDPRODUITLIB, IDVENTE, IDBC, QTELIVREE, QTERESTEALIVRER, UNITELIB, PU, QTEVENTE) AS 
  SELECT
	abcf.ID,
	abcf.PRODUIT,
	abcf.NUMBL,
	abcf.QUANTITE,
	abcf.IDVENTEDETAIL,
	abcf.UNITE,
	abcf.IDBC_FILLE,
	p.LIBELLEVENTE AS idproduitlib,
	vd.idvente,
	abc.idbc,
	CAST(nvl(s.qtelivree ,0)AS NUMBER(30,2)) AS qtelivree,
	CAST(nvl(abcf.QUANTITE - CAST(nvl(s.qtelivree ,0)AS NUMBER(30,2))  ,0)AS NUMBER(30,2)) AS qteResteALivrer,
	u.val AS uniteLib,
	vd.PU,
	vd.qte as qtevente
FROM AS_BONDELIVRAISON_CLIENT_FILLE abcf
LEFT JOIN as_ingredients p ON p.id = abcf.produit
LEFT JOIN VENTE_DETAILS vd ON vd.id = abcf.IDVENTEDETAIL and vd.IDPRODUIT = abcf.PRODUIT
LEFT JOIN AS_BONDELIVRAISON_CLIENT abc ON abc.id = abcf.numbl
LEFT JOIN sortiestockfille s ON s.IDPRODUIT = abcf.produit AND s.IDVENTEDETAIL =abcf.IDVENTEDETAIL
LEFT JOIN AS_UNITE u ON u.id = abcf.UNITE
 ;


CREATE OR REPLACE VIEW RISTOURNEDETAILS_LIB (ID, IDRISTOURNE, IDPRODUIT, TAUX1, TAUX2, IDORIGINE, IDPRODUITLIB, QTE, PU) AS 
  SELECT
    r.Id,
    r.idristourne,
    r.idproduit,
    r.taux1,
    r.taux2,
    r.idorigine,
    ai.libellevente AS idproduitlib,
    r.QTE,
    r.PU
FROM RISTOURNEDETAILS r
         LEFT JOIN AS_INGREDIENTS ai ON ai.id=r.idproduit
 ;


CREATE OR REPLACE VIEW AVOIRFCFILLELIB (ID, IDAVOIRFC, IDPRODUIT, IDORIGINE, QTE, PU, REMISE, TVA, PUACHAT, PUVENTE, IDDEVISE, TAUXDECHANGE, DESIGNATION, IDVENTEDETAILS, IDPRODUITLIB, CALORIE, POIDS, PTHT, MONTANTTVA) AS 
  SELECT
    AF.ID,
    AF.IDAVOIRFC,
    AF.IDPRODUIT,
    AF.IDORIGINE,
    AF.QTE,
    AF.PU,
    AF.REMISE,
    AF.TVA,
    AF.PUACHAT,
    AF.PUVENTE,
    AF.IDDEVISE,
    AF.TAUXDECHANGE,
    AF.DESIGNATION,
    AF.IDVENTEDETAILS,
    P.libellevente AS IDPRODUITLIB,
    P.CALORIE,
    P.CALORIE * AF.QTE AS POIDS,
    AF.PU * AF.QTE AS PTHT,
    (NVL(AF.pu,0) * NVL(AF.QTE,0)) * NVL(AF.TVA,0) / 100 AS montantTVA
FROM
    AVOIRFCFILLE AF
        LEFT JOIN as_ingredients P ON
        P.id = AF.IDPRODUIT
 ;