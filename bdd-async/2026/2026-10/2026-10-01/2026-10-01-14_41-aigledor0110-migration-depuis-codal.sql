CREATE OR REPLACE VIEW MVTSTOCKLIB AS
 SELECT
	base.ID,
	base.DESIGNATION,
	base.IDMAGASIN,
	base.IDOBJET,
	base.IDMAGASINLIB,
	base.IDVENTE,
	base.IDVENTELIB,
	base.IDTRANSFERT,
	base.IDTRANSFERTLIB,
	base.IDTYPEMVSTOCK,
	base.IDTYPEMVSTOCKLIB,
	base.DATY,
	base.ETAT,
	base.HEURE,
	base.ETATLIB,
	base.IDRESERVATION,
	CAST(base.MONTANTENTREE AS NUMBER(30,2)) AS MONTANTENTREE,
	CAST(base.MONTANTSORTIE AS NUMBER(30,2)) AS MONTANTSORTIE,
	base.IDCATEGORIESTOCK,
	base.IDCATEGORIESTOCKLIB,
	(
           NVL(CAST(base.ID AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(base.DESIGNATION AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(base.IDMAGASIN AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(base.IDOBJET AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(base.IDMAGASINLIB AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(base.IDVENTE AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(base.IDVENTELIB AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(base.IDTRANSFERT AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(base.IDTRANSFERTLIB AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(base.IDTYPEMVSTOCK AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(base.IDTYPEMVSTOCKLIB AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(TO_CHAR(base.DATY, 'YYYY-MM-DD HH24:MI:SS'), '') || ' | ' ||
           NVL(TO_CHAR(base.ETAT), '') || ' | ' ||
           NVL(CAST(base.HEURE AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(base.ETATLIB AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(base.IDRESERVATION AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(TO_CHAR(base.MONTANTENTREE), '') || ' | ' ||
           NVL(TO_CHAR(base.MONTANTSORTIE), '') || ' | ' ||
           NVL(CAST(base.IDCATEGORIESTOCK AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(base.IDCATEGORIESTOCKLIB AS VARCHAR2(4000)), '')
           ) AS MOTSCLESSS
FROM
	(
	SELECT
		m.ID,
		m.DESIGNATION,
		m.IDMAGASIN,
		m.IDOBJET,
		m2.VAL AS IDMAGASINLIB,
		m.IDVENTE,
		v.DESIGNATION AS IDVENTELIB,
		m.IDTRANSFERT,
		CAST(NULL AS VARCHAR2(255)) AS IDTRANSFERTLIB,
		m.IDTYPEMVSTOCK,
		t.VAL AS IDTYPEMVSTOCKLIB,
		m.DATY,
		m.ETAT,
		m.HEURE,
		CASE
			WHEN m.ETAT = 0 THEN 'ANNUL&Eacute;E'
			WHEN m.ETAT = 1 THEN 'CR&Eacute;&Eacute;E'
			WHEN m.ETAT = 11 THEN 'VALID&Eacute;E'
			ELSE NULL
		END AS ETATLIB,
		v.IDRESERVATION,
		CAST(
                        COALESCE(gm.MONTANTENTREE, 0)
                    AS NUMBER(30, 5)
                ) AS MONTANTENTREE,
		CAST(
                        COALESCE(gm.MONTANTSORTIE, 0)
                    AS NUMBER(30, 5)
                ) AS MONTANTSORTIE,
		m.IDCATEGORIESTOCK,
		cs.VAL AS IDCATEGORIESTOCKLIB
	FROM
		MVTSTOCK m
	LEFT JOIN TYPEMVTSTOCK t
                            ON
		t.ID = m.IDTYPEMVSTOCK
	LEFT JOIN VENTE v
                            ON
		v.ID = m.IDVENTE
	LEFT JOIN MAGASIN2 m2
                            ON
		m2.ID = m.IDMAGASIN
	LEFT JOIN MVTSTOCKFILLEGROUPEMERE gm
                            ON
		gm.IDMVTSTOCK = m.ID
	LEFT JOIN CATEGORIESTOCK cs
                            ON
		cs.ID = m.IDCATEGORIESTOCK
     ) base;

CREATE VIEW INVENTAIREFILLEGROUPEMERE AS 
  SELECT
	f.IDINVENTAIRE,
	CAST(sum(nvl(f.pu * f.QUANTITE, 0)) AS NUMBER(30, 2)) AS montantQuantite
FROM
	INVENTAIREFILLE f
GROUP BY
	f.IDINVENTAIRE;

CREATE OR REPLACE VIEW INVENTAIRELIB AS 
  SELECT i.ID,
       i.DATY,
       i.DESIGNATION,
       i.IDMAGASIN,
       m.VAL AS IDMAGASINLIB,
       i.ETAT,
       i.HEURE,
       CASE
           WHEN i.ETAT = 0  THEN 'ANNUL&Eacute;E'
           WHEN i.ETAT = 1  THEN 'CR&Eacute;&Eacute;E'
           WHEN i.ETAT = 11 THEN 'VALID&Eacute;E'
           ELSE NULL
           END AS ETATLIB,
       i.IDCATEGORIE,
       c.VAL AS IDCATEGORIELIB,
       (
           NVL(CAST(i.ID AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(TO_CHAR(i.DATY, 'YYYY-MM-DD HH24:MI:SS'), '') || ' | ' ||
           NVL(CAST(i.DESIGNATION AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(i.IDMAGASIN AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(m.VAL AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(TO_CHAR(i.ETAT), '') || ' | ' ||
           NVL(CAST(i.HEURE AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(
                   CASE
                       WHEN i.ETAT = 0  THEN 'ANNUL&Eacute;E'
                       WHEN i.ETAT = 1  THEN 'CR&Eacute;&Eacute;E'
                       WHEN i.ETAT = 11 THEN 'VALID&Eacute;E'
                       ELSE NULL
                       END,
                   ''
           ) || ' | ' ||
           NVL(CAST(i.IDCATEGORIE AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(c.VAL AS VARCHAR2(4000)), '')
           ) AS MOTSCLESSS,
           invfgm.montantquantite
FROM INVENTAIRE i
         LEFT JOIN MAGASINPOINT m
                   ON m.ID = i.IDMAGASIN
         LEFT JOIN CATEGORIEINGREDIENT c
                   ON c.ID = i.IDCATEGORIE
		 LEFT JOIN INVENTAIREFILLEGROUPEMERE invfgm ON invfgm.idinventaire = i.id;

CREATE OR REPLACE VIEW INVENTAIRELIB_ANNULEE AS 
  SELECT 
i.ID,i.DATY,i.DESIGNATION,i.IDMAGASIN,i.IDMAGASINLIB,i.ETAT,i.ETATLIB,i.MONTANTQUANTITE
FROM INVENTAIRELIB i 
WHERE i.ETAT = 0;

CREATE OR REPLACE VIEW INVENTAIRELIB_CREE AS 
  SELECT 
i.ID,i.DATY,i.DESIGNATION,i.IDMAGASIN,i.IDMAGASINLIB,i.ETAT,i.ETATLIB,i.MONTANTQUANTITE
FROM INVENTAIRELIB i 
WHERE i.ETAT = 1;

CREATE OR REPLACE VIEW INVENTAIRELIB_VALIDEE AS 
  SELECT 
i.ID,i.DATY,i.DESIGNATION,i.IDMAGASIN,i.IDMAGASINLIB,i.ETAT,i.ETATLIB,i.MONTANTQUANTITE
FROM INVENTAIRELIB i 
WHERE i.ETAT = 11;

CREATE VIEW TRANSTOCKDETAILSGROUPEMERE AS 
  SELECT
	f.IDTRANSFERTSTOCK,
	CAST(sum(nvl(f.pu * f.QUANTITE, 0)) AS NUMBER(30, 2)) AS montantQuantite
FROM
	TRANSFERTSTOCKDETAILS f
GROUP BY
	f.IDTRANSFERTSTOCK;

CREATE OR REPLACE VIEW TRANSFERTSTOCKCPL AS 
  SELECT t.ID,
       t.DESIGNATION,
       t.IDMAGASINDEPART,
       m.VAL AS IDMAGASINDEPARTLIB,
       t.IDMAGASINARRIVE,
       m2.VAL AS IDMAGASINARRIVELIB,
       t.DATY,
       t.ETAT,
       t.IDOF,
       CASE
           WHEN t.ETAT = 0  THEN 'ANNULEE'
           WHEN t.ETAT = 1  THEN 'CREEE'
           WHEN t.ETAT = 11 THEN 'VISEE'
           ELSE NULL
           END AS ETATLIB,
       (
           NVL(CAST(t.ID AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(t.DESIGNATION AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(t.IDMAGASINDEPART AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(m.VAL AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(t.IDMAGASINARRIVE AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(m2.VAL AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(TO_CHAR(t.DATY, 'YYYY-MM-DD HH24:MI:SS'), '') || ' | ' ||
           NVL(TO_CHAR(t.ETAT), '') || ' | ' ||
           NVL(CAST(t.IDOF AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(
                   CASE
                       WHEN t.ETAT = 0  THEN 'ANNULEE'
                       WHEN t.ETAT = 1  THEN 'CREEE'
                       WHEN t.ETAT = 11 THEN 'VISEE'
                       ELSE NULL
                       END,
                   ''
           )
           ) AS MOTSCLESSS,
           tdgm.montantquantite
FROM TRANSFERTSTOCK t
         LEFT JOIN MAGASINPOINT m
                   ON m.ID = t.IDMAGASINDEPART
         LEFT JOIN MAGASINPOINT m2
                   ON m2.ID = t.IDMAGASINARRIVE
		LEFT JOIN TRANSTOCKDETAILSGROUPEMERE tdgm ON tdgm.idtransfertstock = t.ID;

CREATE OR REPLACE VIEW TRANSFERTSTOCKCPL_ANNULEE AS 
  (
	SELECT
		t.ID,t.DESIGNATION,t.IDMAGASINDEPART,t.IDMAGASINDEPARTLIB,t.IDMAGASINARRIVE,t.IDMAGASINARRIVELIB,t.DATY,t.ETAT,t.IDOF,t.ETATLIB, t.montantquantite
	FROM
	TransfertStockCpl t
	WHERE t.etat=0
);

CREATE OR REPLACE VIEW TRANSFERTSTOCKCPL_CREE AS 
  (
	SELECT
		t.ID,t.DESIGNATION,t.IDMAGASINDEPART,t.IDMAGASINDEPARTLIB,t.IDMAGASINARRIVE,t.IDMAGASINARRIVELIB,t.DATY,t.ETAT,t.IDOF,t.ETATLIB, t.montantquantite
	FROM
	TransfertStockCpl t
	WHERE t.etat=1
);

CREATE OR REPLACE VIEW TRANSFERTSTOCKCPL_VISEE AS 
  (
	SELECT
		t.ID,t.DESIGNATION,t.IDMAGASINDEPART,t.IDMAGASINDEPARTLIB,t.IDMAGASINARRIVE,t.IDMAGASINARRIVELIB,t.DATY,t.ETAT,t.IDOF,t.ETATLIB, t.montantquantite
	FROM
	TransfertStockCpl t
	WHERE t.etat=11
);

CREATE VIEW DEMTRANSFILLEGROUPEMERE AS 
  SELECT
	f.IDDEMANDETRANSFERT,
	CAST(sum(nvl(f.pu * f.QUANTITE, 0)) AS NUMBER(30, 2)) AS montantQuantite
FROM
	DEMANDETRANSFERTFILLE f
GROUP BY
	f.IDDEMANDETRANSFERT;

CREATE OR REPLACE VIEW DEMANDETRANSFERTCPL AS 
  SELECT t.ID,
       t.DESIGNATION,
       t.IDMAGASINDEPART,
       m.VAL AS IDMAGASINDEPARTLIB,
       t.IDMAGASINARRIVE,
       m2.VAL AS IDMAGASINARRIVELIB,
       t.DATY,
       t.ETAT,
       t.IDOF,
       t.CATEGORIEINGREDIENT,
       c.VAL AS CATEGORIEINGREDIENTLIB,
       CASE
           WHEN t.ETAT = 0  THEN 'Annul&eacute;'
           WHEN t.ETAT = 1  THEN 'Cr&eacute;&eacute;'
           WHEN t.ETAT = 11 THEN 'Vis&eacute;'
           ELSE NULL
           END AS ETATLIB,
       (
           NVL(CAST(t.ID AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(t.DESIGNATION AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(t.IDMAGASINDEPART AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(m.VAL AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(t.IDMAGASINARRIVE AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(m2.VAL AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(TO_CHAR(t.DATY, 'YYYY-MM-DD HH24:MI:SS'), '') || ' | ' ||
           NVL(TO_CHAR(t.ETAT), '') || ' | ' ||
           NVL(CAST(t.IDOF AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(t.CATEGORIEINGREDIENT AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(c.VAL AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(
                   CASE
                       WHEN t.ETAT = 0  THEN 'Annul&eacute;'
                       WHEN t.ETAT = 1  THEN 'Cr&eacute;&eacute;'
                       WHEN t.ETAT = 11 THEN 'Vis&eacute;'
                       ELSE NULL
                       END,
                   ''
           )
           ) AS MOTSCLESSS,
           dmtsf.montantquantite
FROM DEMANDETRANSFERT t
         LEFT JOIN MAGASINPOINT m
                   ON m.ID = t.IDMAGASINDEPART
         LEFT JOIN MAGASINPOINT m2
                   ON m2.ID = t.IDMAGASINARRIVE
         LEFT JOIN CATEGORIEINGREDIENT c
                   ON c.ID = t.CATEGORIEINGREDIENT
		LEFT JOIN DEMTRANSFILLEGROUPEMERE dmtsf ON dmtsf.iddemandetransfert = t.ID;

CREATE OR REPLACE VIEW V_INVENTAIREFILLECPL AS 
  SELECT base.ID,base.IDINVENTAIRE,base.IDPRODUIT,base.IDPRODUITLIB,base.EXPLICATION,base.QUANTITETHEORIQUE,base.QUANTITE,base.LIBELLEEXTACTE,base.PU,base.ECART,base.DATEINV,base.MONTANTTHEORIQUE,base.MONTANTREELLE,base.ECARTMONTANT,base.CATEGORIEINGREDIENT,
       (
           NVL(CAST(base.ID AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(base.IDINVENTAIRE AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(base.IDPRODUIT AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(base.IDPRODUITLIB AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(base.EXPLICATION AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(TO_CHAR(base.QUANTITETHEORIQUE), '') || ' | ' ||
           NVL(TO_CHAR(base.QUANTITE), '') || ' | ' ||
           NVL(CAST(base.LIBELLEEXTACTE AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(TO_CHAR(base.PU), '') || ' | ' ||
           NVL(TO_CHAR(base.ECART), '') || ' | ' ||
           NVL(TO_CHAR(base.DATEINV, 'YYYY-MM-DD HH24:MI:SS'), '') || ' | ' ||
           NVL(TO_CHAR(base.MONTANTTHEORIQUE), '') || ' | ' ||
           NVL(TO_CHAR(base.MONTANTREELLE), '') || ' | ' ||
           NVL(TO_CHAR(base.ECARTMONTANT), '') || ' | ' ||
           NVL(
                   CAST(base.CATEGORIEINGREDIENT AS VARCHAR2(4000)),
                   ''
           )
           ) AS MOTSCLESSS,
           base.IDMAGASIN,
		   base.idMagasinLib
FROM (
         SELECT i.ID,
                i.IDINVENTAIRE,
                i.IDPRODUIT,
                p.LIBELLE AS IDPRODUITLIB,
                i.EXPLICATION,
                CAST(
                        NVL(i.QUANTITETHEORIQUE, 0)
                    AS NUMBER(30, 6)
                ) AS QUANTITETHEORIQUE,
                CAST(
                        NVL(i.QUANTITE, 0)
                    AS NUMBER(30, 6)
                ) AS QUANTITE,
                p.LIBELLEEXTACTE,
                CAST(
                        NVL(i.PU, 0)
                    AS NUMBER(30, 6)
                ) AS PU,
                CAST(
                        NVL(i.QUANTITE, 0) -
                        NVL(i.QUANTITETHEORIQUE, 0)
                    AS NUMBER(30, 6)
                ) AS ECART,
                iv.DATY AS DATEINV,
                CAST(
                        NVL(i.PU, 0) *
                        NVL(i.QUANTITETHEORIQUE, 0)
                    AS NUMBER(30, 6)
                ) AS MONTANTTHEORIQUE,
                CAST(
                        NVL(i.PU, 0) *
                        NVL(i.QUANTITE, 0)
                    AS NUMBER(30, 6)
                ) AS MONTANTREELLE,
                CAST(
                        (
                            NVL(i.PU, 0) -
                            NVL(i.QUANTITE, 0)
                            ) -
                        (
                            NVL(i.PU, 0) -
                            NVL(i.QUANTITETHEORIQUE, 0)
                            )
                    AS NUMBER(30, 6)
                ) AS ECARTMONTANT,
                p.CATEGORIEINGREDIENT,
                iv.IDMAGASIN,
				m.VAL AS idMagasinLib
         FROM INVENTAIREFILLE i
                  LEFT JOIN INVENTAIRE iv
                            ON iv.ID = i.IDINVENTAIRE
                  LEFT JOIN AS_INGREDIENTS p
                            ON p.ID = i.IDPRODUIT
                  LEFT JOIN MAGASIN2 m ON iv.IDMAGASIN = m.ID
         WHERE iv.ETAT >= 11
     ) base;

UPDATE MENUDYNAMIQUE x
	SET x.ID_PERE='MNDN000000021NULL'
	WHERE x.ID='MNDN000000029';
