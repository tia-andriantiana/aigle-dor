-- Stefan

CREATE TABLE POINTAGECANTINE (
                                 ID VARCHAR2(255) PRIMARY KEY,
                                 IDPERSONNEL VARCHAR2(255),
                                 IDDEPARTEMENT VARCHAR2(255),
                                 MOIS NUMBER(38, 0),
                                 ANNEE NUMBER(38, 0),
                                 NOMBRE NUMBER(38, 0),
                                 DATY DATE,
                                 ETAT NUMBER(38, 0)
);

CREATE SEQUENCE seq_POINTAGECANTINE
    START WITH 1
    INCREMENT BY 1
    MAXVALUE 999999999999
    NOCYCLE
CACHE 20;

CREATE OR REPLACE FUNCTION GET_SEQ_POINTAGECANTINE
 RETURN NUMBER
IS
  retour NUMBER;
BEGIN
SELECT seq_POINTAGECANTINE.NEXTVAL into retour from dual;
RETURN retour;
END;

CREATE OR REPLACE VIEW POINTAGECANTINE_CPL AS
SELECT
    pt.*,
    log.nom || ' ' || log.prenom AS nomPersonnel,
    pip.matricule,
    dp.val AS departementLib,
    CASE
        WHEN pt.etat = 1 THEN 'CRÉÉ'
        WHEN pt.etat = 11 THEN 'VALIDÉ'
        WHEN pt.etat = 0 THEN 'ANNULÉ'
        ELSE 'INCONNU'
        END AS etatLib
FROM POINTAGECANTINE pt
         LEFT JOIN LOG_PERSONNEL log
                   ON log.id = pt.idpersonnel
         LEFT JOIN PAIE_INFO_PERSONNEL pip
                   ON pip.id = pt.idpersonnel
         LEFT JOIN DEPARTEMENT dp
                   ON dp.id = pt.iddepartement;