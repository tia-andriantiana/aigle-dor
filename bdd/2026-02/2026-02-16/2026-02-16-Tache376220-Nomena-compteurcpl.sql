CREATE OR REPLACE VIEW compteurcpl AS
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
FROM compteur c
         LEFT JOIN ligne l
                   ON l.id = c.idligne
         LEFT JOIN categorieconsommable cc
                   ON cc.id = c.idcategorie
         LEFT JOIN tranche t
                   ON t.id = c.idtranche;

