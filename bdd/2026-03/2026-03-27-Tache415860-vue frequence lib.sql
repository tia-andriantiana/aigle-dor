CREATE OR REPLACE VIEW TYPEABSENCE_CPL as
SELECT
    typ.*,
    fc.val AS frequencelib,
    CASE
        WHEN typ.etat=1 THEN 'CR&Eacute;&Eacute;'
        WHEN typ.etat=11 THEN 'VALID&Eacute;'
        END AS etatlib
FROM type_absence typ
         LEFT JOIN frequence_conge fc ON fc.id=typ.frequence;