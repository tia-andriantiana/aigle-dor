create table CompteurElectriciteMere(
	id varchar(255) PRIMARY KEY,
	Daty date,
	Ligne varchar(255),
	Remarque varchar(255),
	etat number(5)
);

CREATE SEQUENCE SEQ_CompteurElectriciteMere INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER 

CREATE OR REPLACE FUNCTION GETSEQ_CompteurElectriciteMere
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
SELECT SEQavancement.NEXTVAL INTO retour FROM DUAL;
RETURN retour;
END;

ALTER TABLE CompteurElectricite ADD idMere varchar(255);
ALTER TABLE CompteurElectricite
ADD CONSTRAINT CompteurElectricite_mere_fk
FOREIGN KEY (idMere)
REFERENCES CompteurElectriciteMere(id);