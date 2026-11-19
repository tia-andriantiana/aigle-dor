CREATE TABLE depenseDivers(
                              id varchar(255) PRIMARY KEY,
                              daty DATE,
                              fournisseur varchar(255),
                              remarque varchar(255),
                              idModePaiement varchar(255),
                              compteCheque varchar(255),
                              acheteur varchar(255),
                              idMagasin varchar(255),
                              idCategorie varchar(255),
                              etat int,
                              FOREIGN KEY (fournisseur) REFERENCES FOURNISSEUR (id)
);

CREATE TABLE depenseDiversFille(
                                   id varchar(255) PRIMARY KEY,
                                   idMere varchar(255),
                                   idProduit varchar(255),
                                   designation varchar(255),
                                   quantite number(10,2),
                                   pu NUMBER (10, 2),
                                   FOREIGN KEY (idMere) REFERENCES depenseDivers(id)
);

CREATE SEQUENCE seqdepenseDivers INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

create FUNCTION getseqdepenseDivers
    RETURN NUMBER
        IS
           retour   NUMBER;
BEGIN
SELECT seqdepenseDivers.NEXTVAL INTO retour FROM DUAL;
RETURN retour;
END;

CREATE SEQUENCE seqdepenseDiversFille INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

create FUNCTION getseqdepenseDiversFille
    RETURN NUMBER
        IS
           retour   NUMBER;
BEGIN
SELECT seqdepenseDiversFille.NEXTVAL INTO retour FROM DUAL;
RETURN retour;
END;

CREATE OR REPLACE VIEW DEPENSEDIVERSLIB as
SELECT
    d.* ,
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
        WHEN d.ETAT = 5
            THEN 'VIS&Eacute;E par Le Directeur'
        WHEN d.ETAT = 11
            THEN 'VIS&Eacute;E par Contr&ocirc;le'
        END AS etatlib
FROM DEPENSEDIVERS d
         LEFT JOIN FOURNISSEUR f ON d.FOURNISSEUR = f.ID
         LEFT JOIN MODEPAIEMENT m ON d.IDMODEPAIEMENT = m.ID
         LEFT JOIN MAGASIN2 m2 ON d.IDMAGASIN = m2.ID
         LEFT JOIN CATEGORIEINGREDIENT c ON d.IDCATEGORIE = c.ID ;

CREATE OR REPLACE VIEW DEPENSEDIVERSFILLELIB AS
SELECT
    d.*,
    ail.LIBELLE AS idProduitLib
FROM DEPENSEDIVERSFILLE d
         LEFT JOIN AS_INGREDIENTS_LIB ail ON d.IDPRODUIT = ail.ID ;