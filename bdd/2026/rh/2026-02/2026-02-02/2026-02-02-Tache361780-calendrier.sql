CREATE TABLE CALENDRIER (
                            id        VARCHAR(255) PRIMARY KEY,
                            daty      DATE,
                            evenement VARCHAR(255)
);

create sequence seqcalendrier
    minvalue 1
    maxvalue 999999999999
    start with 1
    increment by 1
    cache 20;



CREATE OR REPLACE FUNCTION getseqcalendrier
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT seqcalendrier.NEXTVAL INTO retour FROM DUAL;

    RETURN retour;
END;