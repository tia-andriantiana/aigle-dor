create  or replace view FABRICATIONCPL as
SELECT
    f.ID,f.LANCEPAR,f.CIBLE,f.REMARQUE,f.LIBELLE,f.BESOIN,f.DATY,f.idOffille,nvl(f.idof, off.idmere) AS idof,
    p.val AS lanceparLib,
    p2.val AS cibleLib,
    f.etat AS etat,
    CASE
        WHEN f.ETAT=1
            THEN 'CRÉÉ'
        WHEN f.ETAT=11
            THEN 'VALIDÉE'
        WHEN f.ETAT=0
            THEN 'ANNULÉE'
        WHEN f.ETAT=21
            THEN 'ENTAMÉE'
        WHEN f.ETAT=31
            THEN 'BLOQUÉE'
        WHEN f.ETAT=41
            THEN 'TERMINÉE'
        END AS ETATLIB,
    f.FABRICATIONPREC,
    f.FABRICATIONSUIV
FROM FABRICATION f
         LEFT JOIN MAGASINPOINT p ON p.id = f.lancepar
         LEFT JOIN MAGASINPOINT p2 ON p2.id = f.cible
         LEFT JOIN offille off ON f.idoffille = off.id;