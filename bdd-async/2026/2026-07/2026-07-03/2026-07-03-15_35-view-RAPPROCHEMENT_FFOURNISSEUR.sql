  create or replace view AS_BONDELIVRAISON_LIBCPL as 
  SELECT
	    bl.ID,
	    bl.PRODUIT,
	    bl.NUMBL,
	    bl.QUANTITE,
	    bl.IDDETAILSFACTUREFOURNISSEUR,
	    bl.UNITE,
	    bl.IDBC_FILLE,
	    AB.REMARQUE,
	    AB.IDBC,
	    AB.DATY,
	    AB.ETAT,
	    AB.MAGASIN,
	    p.libelle AS PRODUITlib,
	    u.VAL AS UNITElib,
	    m.VAL AS magasinlib,
	    p.LIBELLEEXTACTE,
	    bl.pu,
	    bl.DESIGNATION,
	    cast(nvl(bl.QUANTITE*bl.PU,0) AS  NUMBER(30,2)) AS MONTANT,
	    cast(nvl(bl.tauxdechange*bl.PU,0) AS  NUMBER(30,2)) AS PUAR,
	    bl.tauxdechange,
        AB.IDFACTUREFOURNISSEUR -- nanampy colonne IDFACTUREFOURNISSEUR pour rapprochement BL - FF
	FROM
	    As_BonDeLivraison_Fille bl
	        LEFT JOIN AS_BONDELIVRAISON AB ON
	        AB.ID = bl.NUMBL
	        LEFT JOIN AS_INGREDIENTS p ON
	        bl.PRODUIT = p.ID
	        LEFT JOIN AS_UNITE  u ON
	        bl.UNITE = u.ID
	        LEFT JOIN MAGASIN m ON
	        ab.MAGASIN = m.ID;

create view FACTUREFOURNISSEURFILLEValide as 
SELECT ff.* FROM FACTUREFOURNISSEURFILLE ff JOIN facturefournisseur f ON f.id=ff.idfacturefournisseur WHERE f.etat>=11;


CREATE VIEW RAPPROCHEMENT_FFOURNISSEUR AS 
   SELECT
        abcc.ID,
        abcc.PRODUIT,
        abcc.NUMBL,
        abcc.IDDETAILSFACTUREFOURNISSEUR,
        abcc.UNITE,
        abcc.IDBC_FILLE,
        abcc.REMARQUE,
        abcc.IDBC,
        abcc.DATY,
        abcc.ETAT,
        abcc.MAGASIN,
        abcc.PRODUITLIB,
        abcc.UNITELIB,
        abcc.MAGASINLIB,
        abcc.LIBELLEEXTACTE AS LIBELLEEXACTE,
        abcc.pu,
        abcc.puar,
        abcc.QUANTITE,
        NVL(SUM(ffv.qte),0) AS qtefacturer,
        abcc.QUANTITE - NVL(SUM(ffv.qte),0)  as resteAfacturer
    FROM AS_BONDELIVRAISON_LIBCPL abcc
    left join FACTUREFOURNISSEURFILLEValide  ffv on ffv.idfacturefournisseur = abcc.IDFACTUREFOURNISSEUR
    GROUP BY 
        abcc.ID,
        abcc.PRODUIT,
        abcc.NUMBL,
        abcc.QUANTITE,
        abcc.IDDETAILSFACTUREFOURNISSEUR,
        abcc.UNITE,
        abcc.IDBC_FILLE,
        abcc.REMARQUE,
        abcc.IDBC,
        abcc.DATY,
        abcc.ETAT,
        abcc.MAGASIN,
        abcc.PRODUITLIB,
        abcc.UNITELIB,
        abcc.MAGASINLIB,
        abcc.LIBELLEEXTACTE,
        abcc.pu,
        abcc.puar
 ;