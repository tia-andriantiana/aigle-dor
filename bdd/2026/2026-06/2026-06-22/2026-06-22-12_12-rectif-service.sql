select *
from SERVICE;

select *
from SECTION_LIB;


CREATE SEQUENCE seqdepartementDivers
    MINVALUE 1
    MAXVALUE 999999999999999999999999999
    START WITH 1
    INCREMENT BY 1;


create or replace FUNCTION GETseqdepartementDivers
    RETURN NUMBER IS
    retour NUMBER;
BEGIN
SELECT seqdepartementDivers.nextval INTO retour FROM dual;
return retour;
END;

create table departementDivers
(
    ID      VARCHAR2(100) not null
        primary key,
    LIBELLE VARCHAR2(255),
    CODE    VARCHAR2(255)
);

INSERT INTO departementDivers (ID, LIBELLE, CODE) VALUES ('DEPD0001', 'DU', '11');
INSERT INTO departementDivers (ID, LIBELLE, CODE) VALUES ('DEPD00010', 'DAP', '20');
INSERT INTO departementDivers (ID, LIBELLE, CODE) VALUES ('DEPD0002', 'FIMCOBIS', '12');
INSERT INTO departementDivers (ID, LIBELLE, CODE) VALUES ('DEPD0003', 'DPCO', '13');
INSERT INTO departementDivers (ID, LIBELLE, CODE) VALUES ('DEPD0004', 'DARH', '14');
INSERT INTO departementDivers (ID, LIBELLE, CODE) VALUES ('DEPD0006', 'DCF', '16');
INSERT INTO departementDivers (ID, LIBELLE, CODE) VALUES ('DEPD0009', 'DCM', '19');

alter table SECTION drop constraint FK_SECTION_SERVICE;

UPDATE SECTION
SET IDSERVICE = REPLACE(IDSERVICE, 'SERV', 'DEPD')
WHERE IDSERVICE LIKE 'SERV%';

create or replace view SECTION_LIB as
SELECT
    s."ID",s."IDSERVICE",s."VAL",s."DESCE",
    ser.LIBELLE AS libelle,
    ''  AS compte
FROM SECTION s
         LEFT JOIN departementDivers ser
                   ON s.IDSERVICE = ser.ID;

delete from SERVICE where 1 < 2;

alter table SECTION add constraint FK_SECTION_SERVICE foreign key (IDSERVICE) references departementDivers(ID);

INSERT INTO SERVICE (ID, LIBELLE, CODE, COMPTE) VALUES ('SERV0001', 'Usine Confiserie', '11', '11');
INSERT INTO SERVICE (ID, LIBELLE, CODE, COMPTE) VALUES ('SERV0002', 'Usine Biscuiterie', '12', '12');
INSERT INTO SERVICE (ID, LIBELLE, CODE, COMPTE) VALUES ('SERV0003', 'Usine Pâte alimentaire', '13', '13');
INSERT INTO SERVICE (ID, LIBELLE, CODE, COMPTE) VALUES ('SERV0004', 'Recherche et développement', '14', '14');
INSERT INTO SERVICE (ID, LIBELLE, CODE, COMPTE) VALUES ('SERV0005', 'Atelier Biscuiterie', '15', '15');
INSERT INTO SERVICE (ID, LIBELLE, CODE, COMPTE) VALUES ('SERV0006', 'Atelier Confiserie', '16', '16');
INSERT INTO SERVICE (ID, LIBELLE, CODE, COMPTE) VALUES ('SERV0007', 'Atelier Pâte alimentaire', '17', '17');
INSERT INTO SERVICE (ID, LIBELLE, CODE, COMPTE) VALUES ('SERV0008', 'Administration de vente', '18', '18');
INSERT INTO SERVICE (ID, LIBELLE, CODE, COMPTE) VALUES ('SERV0009', 'Marketing ', '19', '19');
INSERT INTO SERVICE (ID, LIBELLE, CODE, COMPTE) VALUES ('SERV00010', 'Approvisionnement', '20', '20');
INSERT INTO SERVICE (ID, LIBELLE, CODE, COMPTE) VALUES ('SERV00011', 'Gouvernance, Performance et Système d’information', '21', '21');


create or replace view DEPENSEDIVERSLIB as
SELECT
    d.ID,d.DATY,d.FOURNISSEUR,d.REMARQUE,d.IDMODEPAIEMENT,d.COMPTECHEQUE,d.ACHETEUR,d.IDMAGASIN,d.IDCATEGORIE,d.ETAT,
    f.NOM AS fournisseurLib,
    m.VAL AS IDMODEPAIEMENTLIB,
    m2.val AS idMagasinLib,
    c.VAL AS idCategorieLib,
    CASE
        WHEN d.ETAT = 0
            THEN 'ANNUL&Eacute;E'
        WHEN d.ETAT = 1
            THEN 'CR&Eacute;&Eacute;E'
        WHEN d.ETAT = 3
            THEN 'VIS&Eacute;E par Chef de D&eacutepartement'
        WHEN d.ETAT = 4
            THEN 'VIS&Eacute;E par Directeur de D&eacutepartement'
        WHEN d.ETAT = 11
            THEN 'VIS&Eacute;E par Le Directeur'
        WHEN d.ETAT = 5
            THEN 'VIS&Eacute;E par Contr&ocirc;le'
        END AS etatlib,
    s.LIBELLE AS serviceLib,
    sec.VAL AS idSectionLib,
    d.service,
    d.idSection,
    (SELECT NVL(SUM(NVL(df.QUANTITE, 0) * NVL(df.PU, 0)), 0)
     FROM DEPENSEDIVERSFILLE df
     WHERE df.IDMERE = d.ID
    ) AS montantTotal,
    (SELECT NVL(SUM(NVL(mc.DEBIT, 0)), 0)
     FROM MOUVEMENTCAISSE mc
     WHERE mc.IDORIGINE = d.ID
        OR mc.IDORIGINE IN (
         SELECT b.IDFACTUREFOURNISSEUR
         FROM AS_BONDELIVRAISON b
         WHERE b.IDDEPENSEDIVERS = d.ID
     )
    ) - (
        SELECT NVL(SUM(NVL(df.QUANTITE, 0) * NVL(df.PU, 0)), 0)
        FROM DEPENSEDIVERSFILLE df
        WHERE df.IDMERE = d.ID
    ) AS surplusTotal,
    (SELECT NVL(SUM(NVL(mc.CREDIT, 0)), 0)
     FROM MOUVEMENTCAISSE mc
     WHERE mc.IDORIGINE = d.ID
        OR mc.IDORIGINE IN (
         SELECT b.IDFACTUREFOURNISSEUR
         FROM AS_BONDELIVRAISON b
         WHERE b.IDDEPENSEDIVERS = d.ID
     )
    ) AS renduTotal
FROM DEPENSEDIVERS d
         LEFT JOIN FOURNISSEUR f ON d.FOURNISSEUR = f.ID
         LEFT JOIN MODEPAIEMENT m ON d.IDMODEPAIEMENT = m.ID
         LEFT JOIN MAGASIN2 m2 ON d.IDMAGASIN = m2.ID
         LEFT JOIN CATEGORIEINGREDIENT c ON d.IDCATEGORIE     = c.ID
         LEFT JOIN departementDivers s ON s.id = d.SERVICE
         LEFT JOIN SECTION sec ON sec.ID = d.IDSECTION;
