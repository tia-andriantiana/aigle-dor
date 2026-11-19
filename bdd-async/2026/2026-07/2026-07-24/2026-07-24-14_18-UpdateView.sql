CREATE OR REPLACE VIEW COMPTEURELECTRICITEMERELIB (
    ID, DATY, LIGNE, REMARQUE, ETAT, LIGNELIB, CONSOMMATION,ETATLIB
) AS
SELECT
    c.ID,
    c.DATY,
    c.LIGNE,
    c.REMARQUE,
    c.ETAT,
    l.VAL AS LIGNELIB,
    NVL(f.CONSOMMATION, 0) AS CONSOMMATION,
    CASE
        WHEN c.ETAT = 0
            THEN 'ANNUL&Eacute;E'
        WHEN c.ETAT = 1
            THEN 'CR&Eacute;&Eacute;E'
        WHEN c.ETAT = 11
            THEN 'VIS&Eacute;(E) par Chef de Fabrication'
        WHEN c.ETAT = 3
            THEN 'VIS&Eacute;(E) par Releveur'
        END AS etatlib
FROM
    COMPTEURELECTRICITEMERE c
        LEFT JOIN LIGNE l
                  ON l.ID = c.LIGNE
        LEFT JOIN (
        SELECT
            fe.IDMERE AS ID_MERE,
            SUM(fe.ECART)    AS CONSOMMATION
        FROM
            COMPTEURELECTRICITE fe
        GROUP BY
            fe.IDMERE
    ) f ON f.ID_MERE = c.ID;