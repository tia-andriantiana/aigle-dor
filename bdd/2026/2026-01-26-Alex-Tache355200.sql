-- Table EtatMachine
CREATE TABLE etatmachine (
    id VARCHAR2(255) NOT NULL,
    val VARCHAR2(255),
    desce VARCHAR2(255),
    CONSTRAINT etatmachine_pk PRIMARY KEY (id)
);

CREATE SEQUENCE SEQETATMACHINE
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999
    START WITH 1
NOCYCLE;

CREATE OR REPLACE function get_SEQETATMACHINE
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQETATMACHINE.NEXTVAL INTO retour FROM DUAL;

    RETURN retour;
END;


-- Table ResultatMaintenance
CREATE TABLE resultatmaintenance (
     id VARCHAR2(255) NOT NULL,
     daty DATE,
     idordretravaux VARCHAR2(255) null,
     idpersonnel NUMBER null ,
     etatmachine VARCHAR2(255) null,
     designation VARCHAR2(255) null,
     prochaineetape VARCHAR2(255) null,
     prochainedaty DATE,
     CONSTRAINT resultatmaint_pk PRIMARY KEY (id),
     CONSTRAINT resultatmaint_ordre_fk FOREIGN KEY (idordretravaux) REFERENCES ordretravaux(id),
     CONSTRAINT resultatmaint_user_fk FOREIGN KEY (idpersonnel) REFERENCES utilisateur(REFUSER),
     CONSTRAINT resultatmaint_etat_fk FOREIGN KEY (etatmachine) REFERENCES etatmachine(id)
);

CREATE SEQUENCE seqresultatmaintenance
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999
    START WITH 1
NOCYCLE;

CREATE OR REPLACE function get_seqresultatmaintenance
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT seqresultatmaintenance.NEXTVAL INTO retour FROM DUAL;

    RETURN retour;
END;

CREATE OR REPLACE VIEW ResultatMaintenanceLib AS
SELECT
    rm.*,
    u.nomuser AS idpersonnelLib,
    em.val AS etatmachineLib
FROM resultatmaintenance rm
         LEFT JOIN utilisateur u ON rm.idpersonnel = u.REFUSER
         LEFT JOIN etatmachine em ON rm.etatmachine = em.id;