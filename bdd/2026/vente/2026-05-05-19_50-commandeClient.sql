CREATE SEQUENCE seqCOMMANDEbesoin
    MINVALUE 1
    MAXVALUE 999999999999999999999999999
    START WITH 1
    INCREMENT BY 1;

create or replace FUNCTION GETseqCOMMANDE
    RETURN NUMBER IS
    retour NUMBER;
BEGIN
SELECT seqCOMMANDEbesoin.nextval INTO retour FROM dual;
return retour;
END;

CREATE SEQUENCE seqCOMMANDEbesoinFille
    MINVALUE 1
    MAXVALUE 999999999999999999999999999
    START WITH 1
    INCREMENT BY 1;

create or replace FUNCTION GETseqCOMMANDEbesoinFille
    RETURN NUMBER IS
    retour NUMBER;
BEGIN
SELECT seqCOMMANDEbesoinFille.nextval INTO retour FROM dual;
return retour;
END;


create table COMMANDE
(
    ID             VARCHAR2(500) not null
        constraint commande_client_PK
            primary key,
    DATY           DATE,
    ETAT           NUMBER,
    REMARQUE       VARCHAR2(500),
    DESIGNATION    VARCHAR2(500),
    MODEPAIEMENT   VARCHAR2(500),
    IDCLIENT       VARCHAR2(255)
        constraint c_FK_CLIENT
            references CLIENT,
    REFERENCE      VARCHAR2(500),
    IDDEVISE       VARCHAR2(100)
        constraint C_DEVISE_FK
            references DEVISE,
    IDMAGASIN      VARCHAR2(255),
    DATEBESOIN     DATE,
    IDPROFORMA     VARCHAR2(255),
    MODELIVRAISON  NUMBER,
    DATELIVRAISON  DATE,
    LIEULIVRAISON  VARCHAR2(255),
    FRAISLIVRAISON NUMBER(30, 2)
);

create table COMMANDEFILLE
(
    ID          VARCHAR2(1000) not null
        constraint commande_client_FILLE_PK
            primary key,
    PRODUIT     VARCHAR2(255),
    IDC        VARCHAR2(500)
        constraint c_FILLE
            references COMMANDE,
    QUANTITE    NUMBER(30, 2),
    PU          NUMBER(38, 2),
    MONTANT     FLOAT,
    TVA         NUMBER(38, 2),
    REMISE      NUMBER(30, 2),
    IDDEVISE    VARCHAR2(100)
        constraint cmd_d_FK
            references DEVISE,
    UNITE       VARCHAR2(100),
    DESIGNATION VARCHAR2(255),
    RISTOURNE   NUMBER(5, 2)
);

CREATE OR REPLACE VIEW COMMANDECPL AS
SELECT cmd.*,
       p.VAL AS idMagasinLib,
       cl.NOM AS idClientLib,
       CASE
           WHEN cmd.etat = 1 THEN 'Créé'
           WHEN cmd.etat = 2 THEN 'Validé'
           WHEN cmd.etat = 0 THEN 'Annulé'
           ELSE 'Inconnu'
           END AS etatLib,
       CASE
           WHEN cmd.modelivraison = 1 THEN '<span style=color: green;>LIVRAISON</span>'
           WHEN cmd.modelivraison = 2 THEN '<span style=color: green;>RECUPERATION</span>'
           END AS modelivraisonlib,
       mp.VAL as modePaiementLib
FROM COMMANDE cmd
         LEFT JOIN MAGASIN p
                   ON p.id = cmd.IDMAGASIN
         LEFT JOIN CLIENT cl
                   ON cl.id = cmd.IDCLIENT
         left join modepaiement mp
                   on mp.id = cmd.MODEPAIEMENT;



CREATE OR REPLACE VIEW COMMANDEFILLECPL AS
SELECT cmd.*,
       p.LIBELLE as produitLib
FROM COMMANDEFILLE cmd
         LEFT JOIN AS_INGREDIENTS p
                   ON p.id = cmd.PRODUIT;
