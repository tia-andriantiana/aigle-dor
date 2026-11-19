CREATE OR REPLACE VIEW V_HS_FABRICATION_DETAIL AS
SELECT
    hp.IDFABRICATION,
    hp.idPersonne,
    f.daty,
    p.annee,
    p.mois,
    SUM(hp.HS) AS hs_total,
    LEAST(SUM(hp.HS), 8) AS hs30,
    GREATEST(SUM(hp.HS) - 8, 0) AS hs50
FROM HEURESUPFABRICATION_CPL hp
         LEFT JOIN FABRICATION f ON f.id = hp.IDFABRICATION
         LEFT JOIN PERIODEPAIE p ON f.daty BETWEEN p.datedebut AND p.datefin
GROUP BY hp.IDFABRICATION, hp.idPersonne, f.daty, p.annee, p.mois;

CREATE OR REPLACE VIEW HS_MOIS AS
SELECT
    idPersonne,
    annee,
    mois,
    SUM(hs30) AS hs30_mois,
    SUM(hs50) AS hs50_mois
FROM V_HS_FABRICATION_DETAIL
GROUP BY idPersonne, annee, mois;


CREATE TABLE HS_FABRICATION_DETAIL_PAIE (
                                            ID                VARCHAR2(50) PRIMARY KEY,
                                            IDFABRICATION     VARCHAR2(50),
                                            IDPERSONNEL       VARCHAR2(50),
                                            TYPE_HS           VARCHAR2(10), -- HS30NI, HS30I, HS50NI, HS50I
                                            HEURES            NUMBER,
                                            TAUX              NUMBER,
                                            MONTANT           NUMBER,
                                            CUMUL_AVANT       NUMBER,
                                            ID_HSMOIS         VARCHAR2(50),
                                            DATY              DATE
);

CREATE OR REPLACE VIEW HS_PAR_FABRICATION AS
SELECT
    d.IDFABRICATION,
    d.idPersonne,
    d.daty,
    d.hs30,
    d.hs50,
    d.mois,
    d.annee
FROM V_HS_FABRICATION_DETAIL d
ORDER BY d.idPersonne, d.daty;


create sequence SEQHSDETAIL
    minvalue 1
    maxvalue 999999999999
    start with 1
    increment by 1
    cache 20;



CREATE OR REPLACE FUNCTION getseq_hsdetail
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
SELECT SEQHSDETAIL.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;


CREATE OR REPLACE VIEW HS_PAR_OF AS
SELECT
    fille.IDMERE AS idMere,
    'CATING000001' AS CATEGORIE,
    CAST(SUM(hs.MONTANT) AS NUMBER(30,2)) AS montantPersonnel
FROM HS_FABRICATION_DETAIL_PAIE hs
         LEFT JOIN FABRICATION fab ON fab.id = hs.IDFABRICATION
         LEFT JOIN OFFILLE fille ON fille.id = fab.IDOFFILLE
GROUP BY fille.IDMERE;

CREATE OR REPLACE VIEW RAPPROCHEMENT_COMPLET AS

SELECT
    st.idmere,
    st.CATEGORIEINGREDIENT AS categorieIngredient,
    st.idcategorieingredient,
    CAST(SUM(montantsortie) AS NUMBER(30,2)) AS montantSortie,
    CAST(SUM(montth) AS NUMBER(30,2)) AS montth,
    CAST(SUM(montth)-SUM(montantsortie) AS NUMBER(30,2)) AS ecart
FROM stockEtDepenseOfFabTheCat st
GROUP BY st.idmere, st.CATEGORIEINGREDIENT, st.idcategorieingredient

UNION ALL

SELECT
    hs.idMere,
    'Charge personnel' as CATEGORIE,
    hs.CATEGORIE as idCategorieIngredient,
    hs.montantPersonnel AS montantSortie,
    0 AS montth,
    -hs.montantPersonnel AS ecart
FROM HS_PAR_OF hs;
