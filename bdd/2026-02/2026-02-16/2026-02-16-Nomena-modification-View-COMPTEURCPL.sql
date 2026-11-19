create or replace view COMPTEURCPL as
SELECT
    c.id,
    c.daty,
    c.idligne,
    c.valeur,
    c.ecart,
    c.idcategorie,
    c.idtranche,
    l.val        AS idlignelib,
    cc.val       AS idcategorielib,
    t.val        AS idtranchelib
FROM compteurmaintenance c
         LEFT JOIN ligne l
                   ON l.id = c.idligne
         LEFT JOIN categorieconsommable cc
                   ON cc.id = c.idcategorie
         LEFT JOIN tranche t
                   ON t.id = c.idtranche;