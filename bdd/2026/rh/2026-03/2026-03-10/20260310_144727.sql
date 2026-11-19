INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENDYN1765437542785117SYH', 'Recap des HS', 'list_alt',
        'module.jsp?but=paie/hs/heure-par-semaine-liste.jsp', 4, 3, 'MENDYN1765437395219335');


create or replace view HS_FABRICATION_SEMAINE as
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

create or replace view HS_FABBRICATION_SEMAINECPL as
SELECT
    hs."IDPERSONNE" as id, hs."IDPERSONNE",hs."ANNEE",hs."MOIS",hs."SEMAINE",hs."HS_TOTAL",hs."HS30",hs."HS50",
    pip.matricule,
    log.nom || ' ' || log.prenom as nomPersonnel,
    CAST(
            TRUNC(TO_DATE(SUBSTR(hs.SEMAINE, 1, 4) || '-01-04', 'YYYY-MM-DD'), 'IW')
                + (TO_NUMBER(SUBSTR(hs.SEMAINE, 6, 2)) - 1) * 7
        AS DATE
    ) AS DATEDEBUTSEMAINE,
    CAST(
            TRUNC(TO_DATE(SUBSTR(hs.SEMAINE, 1, 4) || '-01-04', 'YYYY-MM-DD'), 'IW')
                + (TO_NUMBER(SUBSTR(hs.SEMAINE, 6, 2)) - 1) * 7
                + 6
        AS DATE
    ) AS DATEFINSEMAINE,
    hs.IF AS IF,
    hs.JF AS JF,
    hs.MN AS MN,
    hs.HD AS HD,
    hs.hs_total AS HS
FROM HS_FABRICATION_SEMAINE hs

         LEFT JOIN PAIE_INFO_PERSONNEL pip ON pip.id = hs.IDPERSONNE

         LEFT JOIN LOG_PERSONNEL log ON log.id = hs.IDPERSONNE;

