CREATE TABLE HISTORIQUE_SYNC (
                                 ID             VARCHAR2(200),
                                 ACTION         VARCHAR2(200),
                                 TABLECONCERNE  VARCHAR2(200),
                                 REQUETE        VARCHAR2(4000),
                                 DATY           DATE,
                                 HEURE          VARCHAR2(200),
                                 SERVEUR        VARCHAR2(200),
                                 ETAT           NUMBER(10,0),
                                 CONSTRAINT PK_HISTORIQUE_SYNC PRIMARY KEY (ID)
);

CREATE TABLE REQUETE_RECU_GROUPE (
                                     ID                 VARCHAR2(200),
                                     ACTION             CLOB,
                                     TABLECONCERNE      CLOB,
                                     REQUETE            CLOB,
                                     DATYG              CLOB,
                                     HEURE              CLOB,
                                     SERVEUR            CLOB,
                                     ETAT               NUMBER(10,0),
                                     IDREQUETEAENVOYER  CLOB,
                                     CONSTRAINT PK_REQUETE_RECU_GROUPE PRIMARY KEY (ID)
);

CREATE TABLE TABLENONSYNC (
                              ID             VARCHAR2(100),
                              TABLECONCERNE  VARCHAR2(100),
                              CONSTRAINT PK_TABLENONSYNC PRIMARY KEY (ID),
                              CONSTRAINT UQ_TABLENONSYNC_TABLECONCERNE UNIQUE (TABLECONCERNE)
);

CREATE SEQUENCE SEQHISTORIQUESYNC           INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER;
CREATE SEQUENCE SEQREQUETEAENVOYER          INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER;
CREATE SEQUENCE SEQREQUETEEXECUTE           INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER;

CREATE OR REPLACE FUNCTION GETSEQHISTORIQUESYNC
  RETURN NUMBER IS
  retour NUMBER;
BEGIN
SELECT SEQHISTORIQUESYNC.nextval INTO retour FROM dual;
RETURN retour;
END;

CREATE OR REPLACE VIEW REQUETE_A_ENVOYER_SERVEUR
  (ID, ACTION, TABLECONCERNE, REQUETE, DATY, HEURE, SERVEUR) AS
SELECT rae.ID, rae.ACTION, rae.TABLECONCERNE, rae.REQUETE,
       rae.DATY, rae.HEURE, rae.SERVEUR
FROM REQUETE_A_ENVOYER rae;

CREATE OR REPLACE VIEW REQUETE_EXECUTE_SERVEUR
  (ID, ACTION, TABLECONCERNE, REQUETE, DATY, HEURE, SERVEUR) AS
SELECT rae.ID, rae.ACTION, rae.TABLECONCERNE, rae.REQUETE,
       rae.DATY, rae.HEURE, re.SERVEUR
FROM REQUETE_A_ENVOYER rae
         JOIN REQUETE_EXECUTE re ON rae.ID = re.IDREQUETE;