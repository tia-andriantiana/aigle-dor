create view SOLDE_CONGE_PERS as
SELECT
    pip.id,
    NVL(mvt.plus, 0) AS congedroit,
    NVL(mvt.moins, 0) AS congepris,
    NVL(mvt.plus, 0) - NVL(mvt.moins, 0) AS congereste,
    log.NOM,
    log.PRENOM,
    pip.MATRICULE,
    pip.IDDEPARTEMENT,
    dep.VAL as IDDEPARTEMENTLib
FROM PAIE_INFO_PERSONNEL pip
         LEFT JOIN MOUVEMENTABSENCE mvt
                   ON mvt.IDPERSONNEL = pip.id
         LEFT JOIN log_personnel_v log
                   ON log.id = pip.id
         LEFT JOIN DEPARTEMENT dep
                   ON dep.id = pip.IDDEPARTEMENT
                       /

