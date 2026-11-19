
CREATE OR REPLACE VIEW SOLDE_FORMATION_SYNDICALE AS
SELECT
    pip.id,
    NVL(mvt.ANNEE, EXTRACT(YEAR FROM SYSDATE)) AS annee,
    CAST(15 AS NUMBER(30,2)) AS congedroit,

    CAST(SUM(NVL(mvt.moins, 0)) AS NUMBER(30,2)) AS congepris,

    CAST(
            15 - SUM(NVL(mvt.moins, 0))
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
                       AND mvt.IDTYPE = 'TYPCOL0005'

         LEFT JOIN log_personnel_v log
                   ON log.id = pip.id

         LEFT JOIN DEPARTEMENT dep
                   ON dep.id = pip.IDDEPARTEMENT

GROUP BY
    pip.id,
    mvt.ANNEE,
    log.NOM,
    log.PRENOM,
    pip.MATRICULE,
    pip.IDDEPARTEMENT,
    dep.VAL;

