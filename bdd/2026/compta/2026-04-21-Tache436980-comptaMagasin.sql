
create table magasin_compte
(
    ID    VARCHAR2(50) not null
        primary key,
    VAL   VARCHAR2(100),
    DESCE VARCHAR2(100)
)
    /

CREATE SEQUENCE seq_magasin_compte
    MINVALUE 1
    MAXVALUE 999999999999999999999999999
    START WITH 1
    INCREMENT BY 1;

-- procedure
create or replace FUNCTION GETSEQMAGASINCOMPTE
    RETURN NUMBER IS
    retour NUMBER;
BEGIN
SELECT seq_magasin_compte.nextval INTO retour FROM dual;
return retour;
END;


create or replace view MAGASINLIBCompta as
SELECT
    m.ID ,
    m.VAL ,
    m.DESCE ,
    m.IDPOINT ,
    p.VAL AS IDPOINTLIB,
    m.IDTYPEMAGASIN ,
    t.VAL AS IDTYPEMAGASINLIB,
    m.IDPRODUIT ,
    p2.LIBELLE AS IDPRODUITLIB,
    mc.DESCE as compte,
    mc.id as idMagasincompte
FROM MAGASIN2 m
         LEFT JOIN POINT p ON p.ID = m.IDPOINT
         LEFT JOIN TYPEMAGASIN t ON t.ID = m.IDTYPEMAGASIN
         LEFT JOIN AS_INGREDIENTS p2 ON p2.ID = m.IDPRODUIT
         LEFT JOIN magasin_compte mc ON mc.VAL = m.ID

    /