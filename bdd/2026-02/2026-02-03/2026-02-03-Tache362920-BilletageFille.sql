
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

CREATE TABLE billetageFille (
                                 id VARCHAR(100) PRIMARY KEY,
                                 idMere VARCHAR(100) NOT NULL,
                                 billet INT NOT NULL,
                                 nombreBillet INT NOT NULL
);


CREATE TABLE billet (
                                id VARCHAR(100) PRIMARY KEY,
                                val VARCHAR(100),
                                desce VARCHAR(255)
);

INSERT ALL
    INTO billet (id, val) VALUES ('20000', '20000')
INTO billet (id, val) VALUES ('10000', '10000')
INTO billet (id, val) VALUES ('5000', '5000')
INTO billet (id, val) VALUES ('2000', '2000')
INTO billet (id, val) VALUES ('1000', '1000')
INTO billet (id, val) VALUES ('500', '500')
INTO billet (id, val) VALUES ('200', '200')
INTO billet (id, val) VALUES ('100', '100')
SELECT * FROM dual;

