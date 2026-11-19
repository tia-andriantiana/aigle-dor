ALTER TABLE CompteurElectricite
    ADD IdMachine VARCHAR2(50) NULL REFERENCES AS_INGREDIENT_MAINTENANCE(id);

CREATE OR REPLACE VIEW CompteurElectriciteLib AS
SELECT
    ce.*,
    l.VAL AS IdLigneLib,
    m.libelle AS IdMachineLib,
    cat.VAL AS IdCategorieLib
FROM CompteurElectricite ce
         LEFT JOIN Ligne l ON ce.IdLigne = l.id
         LEFT JOIN AS_INGREDIENT_MAINTENANCE m ON ce.IdMachine = m.id
         LEFT JOIN Categorie cat ON ce.IdCategorie = cat.id;

drop sequence seqCompteurElectricite;

CREATE SEQUENCE seqCompteurElectricite
    START WITH     1
    INCREMENT BY   1
    MINVALUE       1
    MAXVALUE       999999999
    NOCYCLE
    CACHE          20
    NOORDER;


CREATE OR REPLACE FUNCTION GETSEQCOMPTEURELECTRICITE
    RETURN NUMBER
    IS
    retour NUMBER;
BEGIN
SELECT seqCompteurElectricite.NEXTVAL
INTO retour
FROM DUAL;

RETURN retour;
END;