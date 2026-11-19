CREATE TABLE COULEUR(
                        id varchar(255) CONSTRAINT COULEUR_pk PRIMARY KEY,
                        val varchar(255),
                        desce varchar(255)
);

CREATE SEQUENCE seqCOULEUR
    MINVALUE 1
    MAXVALUE 999999999999
    START WITH 1
    INCREMENT BY 1
    CACHE 20;

CREATE OR REPLACE FUNCTION getseqCOULEUR
    RETURN NUMBER
IS
    retour NUMBER;
BEGIN
SELECT seqCOULEUR.NEXTVAL INTO retour FROM DUAL;
RETURN retour;
END;


CREATE TABLE TAILLE(
                       id varchar(255) CONSTRAINT TAILLE_pk PRIMARY KEY,
                       val varchar(255),
                       desce varchar(255)
);

CREATE SEQUENCE seqTAILLE
    MINVALUE 1
    MAXVALUE 999999999999
    START WITH 1
    INCREMENT BY 1
    CACHE 20;

CREATE OR REPLACE FUNCTION getseqTAILLE
    RETURN NUMBER
IS
    retour NUMBER;
BEGIN
SELECT seqTAILLE.NEXTVAL INTO retour FROM DUAL;
RETURN retour;
END;


CREATE TABLE POINTURE(
                         id varchar(255) CONSTRAINT POINTURE_pk PRIMARY KEY,
                         val varchar(255),
                         desce varchar(255)
);

CREATE SEQUENCE seqPOINTURE
    MINVALUE 1
    MAXVALUE 999999999999
    START WITH 1
    INCREMENT BY 1
    CACHE 20;

CREATE OR REPLACE FUNCTION getseqPOINTURE
    RETURN NUMBER
IS
    retour NUMBER;
BEGIN
SELECT seqPOINTURE.NEXTVAL INTO retour FROM DUAL;
RETURN retour;
END;
