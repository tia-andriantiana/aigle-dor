CREATE SEQUENCE seqArretTravail;

CREATE OR REPLACE FUNCTION getSeqArretTravail
    RETURN NUMBER
    IS
    retour NUMBER;
BEGIN
    SELECT seqAccident.NEXTVAL
    INTO retour
    FROM DUAL;

    RETURN retour;
END;

CREATE TABLE arret_travail
(
    Id               VARCHAR2(50) NOT NULL PRIMARY KEY,
    id_accident     VARCHAR2(50),
    Daty             DATE,
    Date_debut_arret DATE,
    Date_fin_arret  DATE,
    nombre_jour     numeric(6,2)
);