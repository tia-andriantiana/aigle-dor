-- Création de la séquence pour Accident
CREATE SEQUENCE seqAccident;

-- Fonction pour obtenir la prochaine valeur de la séquence Accident
CREATE OR REPLACE FUNCTION getSeqAccident
    RETURN NUMBER
    IS
    retour NUMBER;
BEGIN
    SELECT seqAccident.NEXTVAL
    INTO retour
    FROM DUAL;

    RETURN retour;
END;

CREATE TABLE lieu_accident_travail
(
    Id               VARCHAR2(250) NOT NULL PRIMARY KEY,
    val varchar(250),
    desce varchar2(250)
);

CREATE TABLE type_accident
(
    Id               VARCHAR2(250) NOT NULL PRIMARY KEY,
    val varchar(250),
    desce varchar2(250)
);

CREATE TABLE gravite_accident
(
    Id               VARCHAR2(250) NOT NULL PRIMARY KEY,
    val varchar(250),
    desce varchar2(250)
);

-- Création de la table Accident
CREATE TABLE Accident
(
    Id               VARCHAR2(50) NOT NULL PRIMARY KEY,
    Daty             DATE,
    Date_declaration DATE,
    Id_personnel     VARCHAR2(50),
    id_lieu          VARCHAR2(50),
    id_type_accident VARCHAR2(50),
    id_gravite       VARCHAR2(50),
    Id_machine       VARCHAR2(50),
    Cause            VARCHAR2(500),
    CONSTRAINT fk_accident_personnel FOREIGN KEY (Id_personnel) REFERENCES log_personnel (Id),
    CONSTRAINT fk_accident_lieu FOREIGN KEY (id_lieu) REFERENCES lieu_accident_travail (Id),
    CONSTRAINT fk_accident_type FOREIGN KEY (id_type_accident) REFERENCES type_accident (Id),
    CONSTRAINT fk_accident_gravite FOREIGN KEY (id_gravite) REFERENCES gravite_accident (Id),
    CONSTRAINT fk_accident_machine FOREIGN KEY (Id_machine) REFERENCES machine (Id)
);