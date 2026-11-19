-- Stefan

CREATE OR REPLACE VIEW "DEPENSELIB" ("ID", "DESIGNATION", "IDCAISSE", "IDCAISSELIB", "IDOP", "IDORIGINE", "DATY", "MONTANT", "ETAT", "ETATLIB") AS
SELECT
    d.ID ,
    d.DESIGNATION ,
    d.IDCAISSE ,
    c.VAL AS IDCAISSELIB,
    d.IDOP ,
    d.IDORIGINE ,
    d.DATY ,
    d.MONTANT ,
    d.ETAT ,
    CASE
        WHEN d.ETAT = 1
            THEN 'CRÉÉE'
        WHEN d.ETAT = 11
            THEN 'VISÉE'
        WHEN d.ETAT = 0
            THEN 'ANNULÉE'
        END AS ETATLIB
FROM DEPENSE d
         LEFT JOIN CAISSE c ON c.ID = d.IDCAISSE
;