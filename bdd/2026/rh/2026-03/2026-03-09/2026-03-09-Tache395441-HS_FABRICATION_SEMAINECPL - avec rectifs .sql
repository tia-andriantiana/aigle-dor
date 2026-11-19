CREATE OR REPLACE  VIEW HS_FABRICATION_SEMAINE  AS
SELECT
    hp.idPersonne,
    p.annee,
    p.mois,
    TO_CHAR(f.daty, 'IYYY-IW') AS semaine,
    SUM(hp.HS) AS hs_total,
    LEAST(SUM(hp.HS), 8) AS hs30,
    GREATEST(SUM(hp.HS) - 8, 0) AS hs50,
    SUM( hp.IF) AS if, sum(hp.JF) as JF, SUM(hp.MN) as MN , SUM( hp.HD) as HD
FROM HEURESUPFABRICATION_CPL hp
         LEFT JOIN FABRICATION f ON f.id = hp.IDFABRICATION
         LEFT JOIN PERIODEPAIE p ON f.daty BETWEEN p.datedebut AND p.datefin
GROUP BY hp.idPersonne, p.annee, p.mois, TO_CHAR(f.daty, 'IYYY-IW');

CREATE OR REPLACE  VIEW HS_FABBRICATION_SEMAINECPL AS
SELECT
    hs."IDPERSONNE",hs."ANNEE",hs."MOIS",hs."SEMAINE",hs."HS_TOTAL",hs."HS30",hs."HS50",
    pip.matricule,
    log.nom || ' ' || log.prenom as nomPersonnel,
    CAST(
            TRUNC(TO_DATE(SUBSTR(hs.SEMAINE, 1, 4) || '-01-04', 'YYYY-MM-DD'), 'IW')
                + (TO_NUMBER(SUBSTR(hs.SEMAINE, 6, 2)) - 1) * 7
        AS TIMESTAMP
    ) AS DATEDEBUTSEMAINE,
    CAST(
            TRUNC(TO_DATE(SUBSTR(hs.SEMAINE, 1, 4) || '-01-04', 'YYYY-MM-DD'), 'IW')
                + (TO_NUMBER(SUBSTR(hs.SEMAINE, 6, 2)) - 1) * 7
                + 6
        AS TIMESTAMP
    ) AS DATEFINSEMAINE,
    hs.IF AS IF, hs.JF as JF, hs.MN as MN , hs.HD as HD,hs.hs_total AS HS
FROM HS_FABRICATION_SEMAINE hs

         LEFT JOIN PAIE_INFO_PERSONNEL pip ON pip.id = hs.IDPERSONNE

         LEFT JOIN LOG_PERSONNEL log ON log.id = hs.IDPERSONNE;