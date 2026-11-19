-- SOCOBISRECTIFDONNEE.AS_UNITE definition

CREATE TABLE PROVENANCE 
   (	ID VARCHAR2(50) NOT NULL ENABLE, 
	VAL VARCHAR2(250), 
	DESCE VARCHAR2(250), 
	 CONSTRAINT PK_PROVENANCE PRIMARY KEY (ID)
   ) ;

CREATE SEQUENCE SEQPROVENANCE INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER;

CREATE OR REPLACE FUNCTION GETSEQPROVENANCE
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
   SELECT SEQPROVENANCE.NEXTVAL INTO retour FROM DUAL;

   RETURN retour;
END;

INSERT INTO PROVENANCE
(ID, VAL, DESCE)
VALUES('PRO00001', 'Import', 'Import');
INSERT INTO PROVENANCE
(ID, VAL, DESCE)
VALUES('PRO00002', 'Locale', 'Locale');


ALTER TABLE dmdachat ADD idProvenance varchar2(100);
 

 -- SOCOBISRECTIFDONNEE.DMDACHATLIB source

ALTER TABLE AS_BONDECOMMANDE ADD refProforma varchar2(200);



CREATE OR REPLACE  VIEW DMDACHATLIB (ID, DATY, FOURNISSEUR, FOURNISSEURLIB, REMARQUE, DATELIMITE, IDMAGASINLIB, IDCATEGORIELIB, ETAT, ETATLIB, IDOBJET, IDSERVICELIB,idProvenance,IDPROVENANCELIB,REFPROFORMA) AS 
  SELECT
	    da.id,
	    da.daty,
	    da.fournisseur,
	    f.nom AS fournisseurlib,
	    da.remarque,
	    da.dateLimite,
	    m.val AS idMagasinLib,
	    ci.val AS idCategorieLib,
	    da.etat,
	    CASE
	        WHEN da.ETAT = 0
	            THEN 'ANNUL&Eacute;E'
	        WHEN da.ETAT = 1
	            THEN 'CR&Eacute;&Eacute;E'
	        WHEN da.ETAT = 11
	            THEN 'VIS&Eacute;(E) par Responsable achat'
	        WHEN da.ETAT = 3
	            THEN 'VIS&Eacute;(E) par Chef de Fabrication'
	        WHEN da.ETAT = 4
	            THEN 'VIS&Eacute;(E) par Le Directeur'
	        END AS etatlib,
	    da.idObjet,
	    s.libelle AS idServiceLib,
	    da.idProvenance,
	    pr.val AS idProvenanceLib,
	    bc.refproforma AS refproforma
	FROM DMDACHAT da
	         LEFT JOIN FOURNISSEUR f ON f.ID = da.fournisseur
	         LEFT JOIN MAGASIN2 m ON da.idMagasin = m.ID
	         LEFT JOIN categorieIngredient ci ON da.idCategorie = ci.id
	         LEFT JOIN SERVICE s ON da.SERVICE = s.COMPTE
	 		 LEFT JOIN provenance pr ON da.idProvenance=pr.id
	 		 LEFT JOIN AS_BONDECOMMANDE bc ON da.id=bc.IDDMDACHAT
 ;


-- SOCOBISRECTIFDONNEE.DMDACHATLIB_TRAITE source

CREATE OR REPLACE  VIEW DMDACHATLIB_TRAITE (ID, DESIGNATION, IDBC, DATY, FOURNISSEUR, FOURNISSEURLIB, REMARQUE, DATELIMITE, IDMAGASINLIB, IDCATEGORIELIB, ETAT, ETATLIB, IDOBJET, IDSERVICELIB, TRAITE,IDPROVENANCE,IDPROVENANCELIB,REFPROFORMA) AS 
  SELECT
    d.ID,
    bc.DESIGNATION ,
    bc.id AS idbc ,
    d.DATY,
    d.FOURNISSEUR,
    d.FOURNISSEURLIB,
    d.REMARQUE,
    d.DATELIMITE,
    d.IDMAGASINLIB,
    d.IDCATEGORIELIB,
    d.ETAT,
    d.ETATLIB,
    d.IDOBJET,
    d.IDSERVICELIB,
    CASE
        WHEN bc.ID IS NOT NULL THEN 'Oui'
        ELSE 'Non'
    END AS TRAITE,
    d.idProvenance,
    d.IDPROVENANCELIB,
    d.refproforma
FROM DMDACHATLIB d
LEFT JOIN AS_BONDECOMMANDE_MERECPL bc
    ON d.ID = REPLACE(
        bc.DESIGNATION,
        'Facture de la demande d''achat ',
        ''
    );