create table livraisonFictif
(
    ID    VARCHAR2(255) not null primary key,
    VAL   VARCHAR2(255),
    DESCE VARCHAR2(255)
);


CREATE SEQUENCE seq_livraisonFictif
    MINVALUE 1
    MAXVALUE 999999999999999999999999999
    START WITH 1
    INCREMENT BY 1;
create or replace FUNCTION GETSEQlivraisonFictif
    RETURN NUMBER IS
    retour NUMBER;
BEGIN
SELECT seq_livraisonFictif.nextval INTO retour FROM dual;
return retour;
END;