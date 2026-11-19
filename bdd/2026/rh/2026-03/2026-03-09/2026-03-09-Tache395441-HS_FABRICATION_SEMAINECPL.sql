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
    ) AS DATEFINSEMAINE
FROM HS_FABRICATION_SEMAINE hs

         LEFT JOIN PAIE_INFO_PERSONNEL pip ON pip.id = hs.IDPERSONNE

         LEFT JOIN LOG_PERSONNEL log ON log.id = hs.IDPERSONNE;