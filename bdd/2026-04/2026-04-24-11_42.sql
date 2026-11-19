
create or replace view V_MOYENNE_SALAIRE_PARFONCTION as
SELECT
    pip.idfonction as id,
    pf.desce as fonctionlib,
    pem.annee,
    pem.mois,
    ROUND(AVG(pe.GAIN), 2) AS moyenne_salaire_base
FROM PAIE_EDITION pe
         LEFT JOIN PAIE_EDITIONMOISANNEE pem ON pem.ID = pe.IDEDITION
         LEFT JOIN PAIE_INFO_PERSONNEL pip ON pip.ID = pe.IDPERSONNEL
         left join PAIE_FONCTION pf ON pf.id = pip.IDFONCTION
WHERE pe.IDELEMENTPAIE = 'PR000041'
GROUP BY pip.idfonction, pf.desce, pem.annee, pem.mois;
