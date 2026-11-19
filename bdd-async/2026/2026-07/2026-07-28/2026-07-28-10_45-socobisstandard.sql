CREATE TABLE OUVERTURECAISSE(
	id varchar(255) PRIMARY KEY,
	daty DATE,
	heure varchar(255),
	idPoint varchar(255),
	remarque varchar(255),
	etat number(2)
);

CREATE SEQUENCE seq_ouvcaisse INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER 

CREATE OR REPLACE FUNCTION getseq_ouvcaisse
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
SELECT seq_ouvcaisse.NEXTVAL INTO retour FROM DUAL;
RETURN retour;
END;

CREATE TABLE OUVERTURECAISSEFILLE(
	id varchar(255),
	idOuverture varchar(255),
	idCaisse varchar(255),
	montantTheorique number(32,5),
	montant number(32,5),
	explication varchar(255),
	FOREIGN KEY (idOuverture) REFERENCES OUVERTURECAISSE(id),
	FOREIGN KEY (idCaisse) REFERENCES caisse(id)
);

CREATE SEQUENCE seq_ouvcaissefille INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER 

CREATE OR REPLACE FUNCTION getseq_ouvcaissefille
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
SELECT seq_ouvcaissefille.NEXTVAL INTO retour FROM DUAL;
RETURN retour;
END;
