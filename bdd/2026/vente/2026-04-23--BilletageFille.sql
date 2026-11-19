
create sequence SEQBILLETAGEFILLE
    minvalue 1
    maxvalue 999999999999
    start with 1
    increment by 1
    cache 20;



CREATE OR REPLACE FUNCTION GETSEQBILLETAGEFILLE
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQBILLETAGEFILLE.NEXTVAL INTO retour FROM DUAL;

    RETURN retour;
END;