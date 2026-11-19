CREATE OR REPLACE VIEW CHARGE_CPL AS
SELECT
    c.ID,
    c.DATY,
    c.LIBELLE,
    c.PU,
    c.QTE,
    c.TYPE,
    c.IDFABRICATION,
    c.ETAT,
    t.val AS typelib,
    CASE
        WHEN c.ETAT = 0
            THEN 'ANNULÉE'
        WHEN c.ETAT = 1
            THEN 'CRÉÉE'
        WHEN c.ETAT = 11
            THEN 'VISÉE'
        ELSE 'INCONNU'
        END AS etatlib
FROM
    CHARGE c
        LEFT JOIN TYPECHARGE t ON t.id = c.TYPE;