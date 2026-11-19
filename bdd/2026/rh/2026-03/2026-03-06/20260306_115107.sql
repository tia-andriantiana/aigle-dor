create or replace view HS_FABRICATION_SEMAINE as
SELECT
    hp.idPersonne,
    p.annee,
    p.mois,
    TO_CHAR(f.daty, 'IYYY-IW') AS semaine,
    SUM(hp.HS) AS hs_total,
    LEAST(SUM(hp.HS), 8) AS hs30,
    GREATEST(SUM(hp.HS) - 8, 0) AS hs50,
    SUM(hp.HD) as HD,
    SUM(hp.JF) as JF,
    SUM(hp.MN) as MN,
    SUM(hp.IF) as IF
FROM HEURESUPFABRICATION_CPL hp
         LEFT JOIN FABRICATION f ON f.id = hp.IDFABRICATION
         LEFT JOIN PERIODEPAIE p ON f.daty BETWEEN p.datedebut AND p.datefin
GROUP BY hp.idPersonne, p.annee, p.mois, TO_CHAR(f.daty, 'IYYY-IW');