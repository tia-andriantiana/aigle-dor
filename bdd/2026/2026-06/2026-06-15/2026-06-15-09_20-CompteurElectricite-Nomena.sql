create table CompteurElectricite
(
    ID          VARCHAR2(255) not null
        primary key,
    DATY        DATE,
    IDLIGNE     VARCHAR2(255)
        references LIGNE,
    VALEUR      NUMBER(38),
    ECART       NUMBER(38),
    IDCATEGORIE VARCHAR2(255)
        constraint FK_COMPTEUR_INGREDIENTS_CE
            references AS_INGREDIENTS,
    IDMAGASIN   VARCHAR2(255)
        constraint FK_COMPTEUR_MAGASIN_CE
            references MAGASIN2,
    ETAT        NUMBER,
    ANCIEN      NUMBER(30, 3),
    REMARQUE    VARCHAR2(255),
    HEURE       VARCHAR2(255)
);

CREATE SEQUENCE seqCompteurElectricite
    START WITH     1
    INCREMENT BY   1
    MINVALUE       1
    MAXVALUE       999999999
    NOCYCLE
    CACHE          20
    NOORDER;

CREATE OR REPLACE FUNCTION getseqCompteurElectricite
    RETURN NUMBER
    IS
    v_valeur NUMBER;
BEGIN
SELECT seqCompteurElectricite.NEXTVAL
INTO   v_valeur
FROM   DUAL;

RETURN v_valeur;
END seqCompteurElectricite;


