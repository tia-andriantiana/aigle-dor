--dans menu vente -> analyse -> ajouter 'Analyse des ventes par Type Produit' , lien vente/vente-analyse.jsp&grouper=typeProduitLib

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDN0002709114702', 'Analyse des ventes par Type Produit', 'bar_chart', 'module.jsp?but=vente/vente-analyse.jsp&grouper=typeProduitLib', 11, 3, 'MNDN000000010');

--dans view vente_details_cpl_2
--ampoitra ny p.typeproduit
--ampina left join typeproduit tp on p.typeproduit = tp.id
--ampoitra ny tp.val as typeproduitlib

CREATE OR REPLACE  VIEW VENTE_DETAILS_CPL_2 (ID, IDVENTE, IDVENTELIB, IDPRODUIT, IDPRODUITLIB, IDORIGINE, QTE, PU, PUTOTAL, PUTOTALACHAT, PUREVIENT, IDCATEGORIE, IDCATEGORIELIB, DATY, IDMAGASIN, IDMAGASINLIB, IDPOINT, IDPOINTLIB, IDDEVISE, IDDEVISELIB, IDRESERVATION, IDBCFILLE,typeProduit,typeproduitlib, MOTSCLESSS) AS 
  SELECT SQ.ID,SQ.IDVENTE,SQ.IDVENTELIB,SQ.IDPRODUIT,SQ.IDPRODUITLIB,SQ.IDORIGINE,SQ.QTE,SQ.PU,SQ.PUTOTAL,SQ.PUTOTALACHAT,SQ.PUREVIENT,SQ.IDCATEGORIE,SQ.IDCATEGORIELIB,SQ.DATY,SQ.IDMAGASIN,SQ.IDMAGASINLIB,SQ.IDPOINT,SQ.IDPOINTLIB,SQ.IDDEVISE,SQ.IDDEVISELIB,SQ.IDRESERVATION,SQ.IDBCFILLE,SQ.typeProduit , SQ.typeproduitlib,
	       (NVL(TO_CHAR(ID),'') || ' | ' || NVL(TO_CHAR(IDVENTE),'') || ' | ' || NVL(TO_CHAR(IDVENTELIB),'') || ' | ' || NVL(TO_CHAR(IDPRODUIT),'') || ' | ' || NVL(TO_CHAR(IDPRODUITLIB),'') || ' | ' || NVL(TO_CHAR(IDORIGINE),'') || ' | ' || NVL(TO_CHAR(QTE),'') || ' | ' || NVL(TO_CHAR(PU),'') || ' | ' || NVL(TO_CHAR(PUTOTAL),'') || ' | ' || NVL(TO_CHAR(PUTOTALACHAT),'') || ' | ' || NVL(TO_CHAR(PUREVIENT),'') || ' | ' || NVL(TO_CHAR(IDCATEGORIE),'') || ' | ' || NVL(TO_CHAR(IDCATEGORIELIB),'') || ' | ' || NVL(TO_CHAR(DATY,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(IDMAGASIN),'') || ' | ' || NVL(TO_CHAR(IDMAGASINLIB),'') || ' | ' || NVL(TO_CHAR(IDPOINT),'') || ' | ' || NVL(TO_CHAR(IDPOINTLIB),'') || ' | ' || NVL(TO_CHAR(IDDEVISE),'') || ' | ' || NVL(TO_CHAR(IDDEVISELIB),'') || ' | ' || NVL(TO_CHAR(IDRESERVATION),'') || ' | ' || NVL(TO_CHAR(IDBCFILLE),'')) AS MOTSCLESSS
	FROM (
	         SELECT vd.ID,
	                vd.IDVENTE,
	                v.DESIGNATION          AS IDVENTELIB,
	                vd.IDPRODUIT,
	                p.LIBELLEVENTE                  AS IDPRODUITLIB,
	                vd.IDORIGINE,
	                vd.QTE,
	                nvl(vd.PU, 0)          AS PU,
	                CAST(nvl(vd.PU * vd.QTE*(1-nvl(vd.REMISE,0)/100), 0) +nvl(vd.PU * vd.QTE*(1-nvl(vd.REMISE,0)/100) *(vd.TVA/100), 0) AS number(30,2)) AS puTotal,
	                CAST(nvl(vd.PUACHAT * vd.QTE, 0) AS number(30,2)) AS puTotalAchat,
	                CAST(nvl(vd.PU * vd.QTE, 0) - nvl(vd.PUACHAT * vd.QTE, 0) AS number(30,2)) AS puRevient,
	                c.ID  AS IDCATEGORIE,
	                c.VAL AS IDCATEGORIELIB,
	                v.DATY AS daty,
	                m.ID AS IDMAGASIN,
	                m.VAL AS IDMAGASINLIB,
	                p1.ID AS IDPOINT,
	                p1.VAL AS IDPOINTLIB,
	                vd.IDDEVISE,
	                vd.IDDEVISE AS IDDEVISELIB,
	                v.IDRESERVATION,
	                vd.IDBCFILLE,
	                p.typeProduit , 
	                tp.VAL AS typeproduitlib
	         FROM VENTE_DETAILS vd
	                  LEFT JOIN VENTE v ON v.ID = vd.IDVENTE
	                  LEFT JOIN MAGASIN2 m ON m.ID = v.IDMAGASIN
	                  LEFT JOIN AS_INGREDIENTS p ON p.ID = vd.IDPRODUIT
	                  LEFT JOIN POINT p1 ON p1.ID = m.IDPOINT
	                  LEFT JOIN CATEGORIEINGREDIENT c  ON p.CATEGORIEINGREDIENT  = c.ID
					  LEFT JOIN TYPE_PRODUIT tp ON tp.ID=p.typeProduit
	     ) SQ;


--dans view vente_details_cpl_2_visee
--ampoitra ny typeproduit sy typeproduitlib

CREATE OR REPLACE  VIEW VENTE_DETAILS_CPL_2_VISEE (ID, IDVENTE, IDVENTELIB, IDPRODUIT, IDPRODUITLIB, IDORIGINE, QTE, PU, PUTOTAL, PUTOTALACHAT, PUREVIENT, IDCATEGORIE, IDCATEGORIELIB, DATY, IDMAGASIN, IDMAGASINLIB, IDPOINT, IDPOINTLIB, IDDEVISE, IDDEVISELIB, IDRESERVATION, IDBCFILLE, SUM_QTE, MONTANTTOTAL, MONTANT_TOTAL, IDCLIENT, TOTAL_ACHAT,typeproduit,typeproduitlib) AS 
  SELECT vd.ID, vd.IDVENTE, vd.IDVENTELIB, vd.IDPRODUIT, vd.IDPRODUITLIB, vd.IDORIGINE, vd.QTE, vd.PU, vd.PUTOTAL, vd.PUTOTALACHAT, vd.PUREVIENT, vd.IDCATEGORIE, vd.IDCATEGORIELIB, vd.DATY, vd.IDMAGASIN, vd.IDMAGASINLIB, vd.IDPOINT, vd.IDPOINTLIB, vd.IDDEVISE, vd.IDDEVISELIB, vd.IDRESERVATION, vd.IDBCFILLE,
       SUM(vd.QTE)     OVER ()                            AS SUM_QTE,
    SUM(vd.PUTOTAL) OVER ()                            AS MONTANTTOTAL,
    SUM(vd.PUTOTAL) OVER ()                            AS MONTANT_TOTAL,
    v.IDCLIENT,
       SUM(vd.PUTOTAL) OVER (PARTITION BY v.IDCLIENT) AS TOTAL_ACHAT,
       vd.typeproduit,
       vd.typeproduitlib
FROM VENTE_DETAILS_CPL_2 vd
         LEFT JOIN VENTE v ON v.ID = vd.IDVENTE
WHERE v.ETAT >= 11;


