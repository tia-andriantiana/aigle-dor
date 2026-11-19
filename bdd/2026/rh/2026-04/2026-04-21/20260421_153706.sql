create or replace view CATEGORIEQUALIFICATION_LIB as
SELECT
    log.id,
    log.MATRICULE,
    log.nom || ' ' || log.prenom as nomPersonnel,
    c.MONTANT,
    cp.val as categorieLib,
    qp.val as qualificationLib
FROM LOG_PERSONNEL_FIN log
         LEFT JOIN CATEGORIE_QUALIFICATION c
                   ON c.IDQUALIFICATION = log.IDQUALIFICATION
                       AND c.IDCATEGORIE = log.IDCATEGORIE_PAIE
                       AND (
                          (c.REMARQUE IS NULL)
                              OR (c.REMARQUE = log.ID)
                          ) AND c.etat = 1
         LEFT JOIN CATEGORIE_PAIE cp ON cp.id = c.IDCATEGORIE
         LEFT JOIN QUALIFICATION_PAIE qp ON qp.id = c.IDQUALIFICATION;

