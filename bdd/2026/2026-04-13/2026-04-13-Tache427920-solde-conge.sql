CREATE OR REPLACE VIEW SOLDE_CONGE_PERS AS
SELECT
    pip.id,
    CAST(SUM(NVL(mvt.plus, 0)) AS NUMBER(30,2)) AS congedroit,
    CAST(SUM(NVL(mvt.moins, 0)) AS NUMBER(30,2)) AS congepris,
    CAST(
            SUM(NVL(mvt.plus, 0)) - SUM(NVL(mvt.moins, 0))
        AS NUMBER(30,2)
    ) AS congereste,
    log.NOM,
    log.PRENOM,
    pip.MATRICULE,
    pip.IDDEPARTEMENT,
    dep.VAL AS IDDEPARTEMENTLib
FROM PAIE_INFO_PERSONNEL pip
         LEFT JOIN MOUVEMENTABSENCE mvt
                   ON mvt.IDPERSONNEL = pip.id
                       AND mvt.IDTYPE = 'TYP000004'
         LEFT JOIN log_personnel_v log
                   ON log.id = pip.id
         LEFT JOIN DEPARTEMENT dep
                   ON dep.id = pip.IDDEPARTEMENT
GROUP BY
    pip.id,
    log.NOM,
    log.PRENOM,
    pip.MATRICULE,
    pip.IDDEPARTEMENT,
    dep.VAL;


