CREATE OR REPLACE VIEW HS_FAB_SEMAINE_PARTRANCHE AS
SELECT
    pip.id as idpersonne,
    hp.IDRESSPARFAB,
    TO_CHAR(f.daty, 'IYYY-IW') AS semaine,
    p.annee,
    p.mois,

    SUM(hp.HS) AS hs_total,

    CASE
        WHEN SUM(hp.HS) <= 8 THEN SUM(hp.HS)
        ELSE 8
        END AS hs30,

    CASE
        WHEN SUM(hp.HS) <= 8 THEN 0
        ELSE SUM(hp.HS) - 8
        END AS hs50,

    SUM(hp.MONTANT) AS montant_total,

    pip.IDDEPARTEMENT,
    pip.IDCATEGORIE_PAIE AS idCategorie

FROM HEURESUPFABRICATION hp
         JOIN FABRICATION f ON f.id = hp.IDFABRICATION
         LEFT JOIN PERIODEPAIE p
                   ON f.daty BETWEEN p.datedebut AND p.datefin
         LEFT JOIN RESSOURCEPARFABRICATION ress ON ress.id = hp.IDRESSPARFAB
         LEFT JOIN PAIE_INFO_PERSONNEL pip
                   ON pip.id = ress.IDRESSOURCE

GROUP BY
    pip.id,
    hp.IDRESSPARFAB,
    TO_CHAR(f.daty, 'IYYY-IW'),
    p.annee,
    p.mois,
    pip.IDDEPARTEMENT,
    pip.IDCATEGORIE_PAIE;

CREATE OR REPLACE VIEW HS_MOIS_PARTRANCHE AS
SELECT
    idPersonne,
    annee,
    mois,

    SUM(hs30) AS hs30_mois,
    SUM(hs50) AS hs50_mois,

    pip.IDDEPARTEMENT,
    pip.IDCATEGORIE_PAIE AS idCategorie

FROM HS_FABRICATION_SEMAINE hs
         LEFT JOIN PAIE_INFO_PERSONNEL pip
                   ON pip.id = hs.idPersonne

GROUP BY
    idPersonne,
    annee,
    mois,
    pip.IDDEPARTEMENT,
    pip.IDCATEGORIE_PAIE;


CREATE OR REPLACE VIEW VW_HS_CUMUL_WEEK AS
SELECT
    pip.id as IDPERSONNEL,
    TO_CHAR(f.DATY, 'IYYY-IW') AS SEMAINE,
    NVL(SUM(hp.HS), 0) AS TOTAL_HS
FROM HEURESUPFABRICATION hp
         LEFT JOIN FABRICATION f ON f.ID = hp.IDFABRICATION
         LEFT JOIN RESSOURCEPARFABRICATION ress ON ress.id = hp.IDRESSPARFAB
         LEFT JOIN PAIE_INFO_PERSONNEL pip ON pip.id = ress.IDRESSOURCE

GROUP BY
    pip.id,
    TO_CHAR(f.DATY, 'IYYY-IW');


ALTER TABLE HEURESUPFABRICATION ADD MONTANTHS NUMBER(30, 2);
ALTER TABLE HEURESUPFABRICATION
    RENAME COLUMN MONTANTHS TO MONTANTHEURESUP;

ALTER TABLE HEURESUPFABRICATION
    RENAME COLUMN MONTANTHEURESUP TO MONTANTHEURESUPP;


CREATE OR REPLACE VIEW HS_PAR_OF AS
SELECT
    fille.IDMERE AS idMere,
    'CATING000001' AS CATEGORIE,
    CAST(SUM(hs.MONTANT) AS NUMBER(30,2)) AS montantPersonnel
FROM HEURESUPFABRICATION hs
         JOIN FABRICATION fab ON fab.id = hs.IDFABRICATION
         JOIN OFFILLE fille ON fille.id = fab.IDOFFILLE
GROUP BY fille.IDMERE;

CREATE OR REPLACE VIEW HS_PAR_OFFILLE AS
SELECT
    fille.id AS idMere,
    'CATING000001' AS CATEGORIE,
    CAST(SUM(hs.MONTANT) AS NUMBER(30,2)) AS montantPersonnel
FROM HEURESUPFABRICATION hs
         JOIN FABRICATION fab ON fab.id = hs.IDFABRICATION
         JOIN OFFILLE fille ON fille.id = fab.IDOFFILLE
GROUP BY fille.id;


create or replace view RAPPROCHEMENT_COMPLET as
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
    'Charge personnelle' as CATEGORIE,
    hs.CATEGORIE as idCategorieIngredient,
    hs.montantPersonnel AS montantSortie,
    0 AS montth,
    -hs.montantPersonnel AS ecart
FROM HS_PAR_OF hs;



create or replace view RAPPROCHEMENT_COMPLETOFFILLE as
select
    st.IDOBJET AS idmere,
    st.CATEGORIEINGREDIENT,
    st.idcategorieingredient,
    cast(sum(montantsortie) as number(30,2)) as montantSortie,
    cast(sum(montth) as number(30,2)) as montth,
    cast(sum(montth)-sum(montantsortie) as number(30,2)) as ecart
from STOCKETDEPENSEOFFILLETHECAT st
group by st.IDOBJET ,st.CATEGORIEINGREDIENT, st.idcategorieingredient

UNION ALL

SELECT
    hs.idMere,
    'Charge personnelle' as CATEGORIE,
    hs.CATEGORIE as idCategorieIngredient,
    hs.montantPersonnel AS montantSortie,
    0 AS montth,
    -hs.montantPersonnel AS ecart
FROM HS_PAR_OFFILLE hs;

