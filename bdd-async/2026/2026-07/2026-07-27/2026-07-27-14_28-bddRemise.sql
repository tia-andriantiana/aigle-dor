CREATE TABLE Remise (
	id VARCHAR(255) PRIMARY KEY,
	daty DATE ,
	nom varchar(155),
	dateDebut DATE,
	dateFin DATE,
	etat NUMBER
);

CREATE SEQUENCE SEQ_Remise INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE OR REPLACE FUNCTION GETSEQ_Remise
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
SELECT SEQ_Remise.NEXTVAL INTO retour FROM DUAL;
RETURN retour;
END;

CREATE TABLE RemiseFille (
	id varchar(255),
	remise number(30,2),
	idCategorieClient varchar(255),
	idProduit varchar(255),
	cateGorieProduit varchar(255),
	idPoint varchar(255),
	idRemise varchar(255),
	FOREIGN KEY (idRemise) REFERENCES Remise (id),
	FOREIGN KEY (idCategorieClient) REFERENCES TYPECLIENT (id),
	FOREIGN KEY (idProduit) REFERENCES as_ingredients (id),
	FOREIGN KEY (idPoint) REFERENCES point (id)
);


ALTER TABLE RemiseFille
ADD CONSTRAINT RemiseFille_fk
FOREIGN KEY (cateGorieProduit)
REFERENCES CATEGORIEINGREDIENT (id);


CREATE SEQUENCE SEQ_RemiseFille INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE OR REPLACE FUNCTION GETSEQ_RemiseFille
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
SELECT SEQ_RemiseFille.NEXTVAL INTO retour FROM DUAL;
RETURN retour;
END;


CREATE OR REPLACE VIEW REMISEFILLELIB (ID, REMISE, IDCATEGORIECLIENT, IDCATEGORIECLIENTLIB, IDPRODUIT, IDPRODUITLIB, CATEGORIEPRODUIT,CATEGORIEPRODUITLIB, IDPOINT, IDPOINTLIB, IDREMISE) AS 
  SELECT 
	rf.id,
	rf.remise,
	rf.idCategorieClient,
	tp.val AS idCategorieClientlib,
	rf.idProduit,
	ai.libelle,
	rf.cateGorieProduit,
	cti.val AS CATEGORIEPRODUITLIB,
	rf.idPoint,
	p.val AS idPointLib,
	rf.idRemise
FROM RemiseFille rf
LEFT JOIN typeclient tp ON tp.id = rf.idCategorieClient
LEFT JOIN as_ingredients ai ON ai.id = rf.idProduit
LEFT JOIN point p ON p.id = rf.idPoint
LEFT JOIN categorieingredient cti ON cti.id = rf.CATEGORIEPRODUIT
;


CREATE VIEW remiseFilleMere (idmere,idfille,daty,nom,datedebut,datefin,etat,remise,idCategorieClient,idProduit,cateGorieProduit,idPoint) AS
SELECT 
r.id AS idmere,
rf.id AS idfille,
r.daty,
r.nom,
r.datedebut,
r.datefin,
r.etat,
rf.remise,
rf.idCategorieClient
FROM Remise r 
LEFT JOIN RemiseFille rf ON r.id = rf.idRemise;



CREATE VIEW remiseFilleMereLib (idmere,idfille,daty,nom,datedebut,datefin,etat,remise,idCategorieClient,idCategorieClientLib,idProduit,idProduitLib,cateGorieProduit,cateGorieProduitLib,idPoint,idPointLib) AS
SELECT 
r.id AS idmere,
rf.id AS idfille,
r.daty,
r.nom,
r.datedebut,
r.datefin,
r.etat,
rf.remise,
rf.idCategorieClient,
tp.val AS idCategorieClientLib,
rf.idProduit,
ai.libelle AS idProduitLib,
rf.cateGorieProduit,
cti.val AS cateGorieProduitLib,
rf.idPoint,
p.val AS idPointLib
FROM Remise r 
LEFT JOIN RemiseFille rf ON r.id = rf.idRemise
LEFT JOIN typeclient tp ON tp.id = rf.idCategorieClient
LEFT JOIN as_ingredients ai ON ai.id = rf.idProduit
LEFT JOIN point p ON p.id = rf.idPoint
LEFT JOIN categorieingredient cti ON cti.id = rf.CATEGORIEPRODUIT
;
