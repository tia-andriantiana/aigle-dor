---Tiavina

--bdd
--
--dans la table : ENFANTPERSONNEL
--
--ajouter colonne : estScolarise NUMBER 
--
--dans view : ENFANTPERSONNEL_CPL
--
--ajouter estScolariseLib 
--
--si 1 => Oui 
--
--si 0 => Non



ALTER TABLE ENFANTPERSONNEL ADD estScolarise NUMBER;

CREATE OR REPLACE  VIEW ENFANTPERSONNEL_CPL (ID, IDPERSONNEL, NOM, DATENAISSANCE, GENRELIB, NOMPERSONNEL, MATRICULE, AGE,estScolariseLib) AS 
  SELECT
    e.ID,
    e.IDPERSONNEL,
    e.NOM,
    e.DATENAISSANCE,
    CASE
        WHEN e.GENRE = 1 THEN 'Masculin'
        ELSE 'F&eacute;minin'
    END AS GENRELIB,
    log.nom || ' ' || log.prenom AS nomPersonnel,
    log.matricule,
    FLOOR(MONTHS_BETWEEN(SYSDATE, e.dateNaissance) / 12) AS age,
    CASE 
    	WHEN e.estScolarise  = 1 
    	THEN 'Oui'
    	WHEN e.estScolarise  = 0
    	THEN 'Non'
    END AS estScolariseLib
FROM ENFANTPERSONNEL e
LEFT JOIN LOG_PERSONNEL_V2 log
    ON e.idpersonnel = log.id
 ;