
CREATE OR REPLACE  VIEW COMMANDEFILLE_CPL_LIB (ID, PRODUIT, IDC, QUANTITE, PU, MONTANT, TVA, REMISE, IDDEVISE, UNITE, PRODUITLIB, COMPTE, QTERESTE, UNITELIB, MONTANTTOTAL, MONTANTDELAREMISE, MONTANTRISTOURNE, MONTANTREMISE, MONTANTTVA, MONTANTTTC, RISTOURNE, FRAISTRANSPORT, POIDSTOTAL) AS 
  SELECT bcf.ID,
	       bcf.PRODUIT,
	       bcf.IDC,
	       bcf.QUANTITE,
	       bcf.PU,
	       bcf.MONTANT,
	       bcf.TVA,
	       bcf.REMISE,
	       bcf.IDDEVISE,
	       bcf.UNITE,
	       i.LIBELLEVENTE                                                                                                                                      AS PRODUITlib,
	       i.compte_vente                                                                                                                                 AS compte,
	       NVL(bcf.quantite, 0) - NVL(vdbc.qte, 0)                                                                                                        AS qtereste,
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
	FROM COMMANDEFILLE bcf
	         left JOIN as_ingredients i ON i.id = bcf.PRODUIT
	         LEFT JOIN vente_details_qte_grp vdbc ON bcf.id = vdbc.idbcfille
	         LEFT JOIN AS_UNITE au ON au.id = i.unite
	         LEFT JOIN COMMANDE bc on bc.id = bcf.IDC
 ;