CREATE OR REPLACE VIEW POINTAGECANTINE_CPL AS 
SELECT
    pt.ID,
    pt.IDPERSONNEL,
    pt.IDDEPARTEMENT,
    pt.MOIS,
    pt.ANNEE,
    pt.NOMBRE,
    pt.DATY,
    pt.ETAT,

    TO_CHAR(
        TO_DATE(TO_CHAR(pt.mois, 'FM00'), 'MM'),
        'FMMonth',
        'NLS_DATE_LANGUAGE=FRENCH'
    ) AS moisLib,

    log.nom || ' ' || log.prenom AS nomPersonnel,
    pip.matricule,
    dp.val AS departementLib,

    CASE
        WHEN pt.etat = 1 THEN 'CRÉÉ'
        WHEN pt.etat = 11 THEN 'VALIDÉ'
        WHEN pt.etat = 0 THEN 'ANNULÉ'
        ELSE 'INCONNU'
    END AS etatLib

FROM POINTAGECANTINE pt
LEFT JOIN LOG_PERSONNEL log
ON log.id = pt.idpersonnel

LEFT JOIN PAIE_INFO_PERSONNEL pip
ON pip.id = pt.idpersonnel

LEFT JOIN DEPARTEMENT dp
ON dp.id = pt.iddepartement;