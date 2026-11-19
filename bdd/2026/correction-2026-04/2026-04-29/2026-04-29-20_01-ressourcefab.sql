

create or replace view RESSOURCEPARFABRICATIONCOMPLET as
SELECT
    r.id,
    r.daty,
    r.idFabrication,
    r.idPoste AS idPosteDefaut,
    r.idRessource,
    p.matricule,
    f.IDOF,
    r.etat ,
    p.TEMPORAIRE,
    p.IDQUALIFICATION AS IdQualification,
    c.IDCATEGORIE,
    c.idPoste ,
    po.VAL AS idPostelib,
    p.IDQUALIFICATION AS IdQualificationEffective,
    CAST(c.montant/((40*52)/12) AS NUMBER(30,2) ) AS tauxhoraire,
    h.HS ,
    h.MN ,
    h.JF ,
    h.HD ,
    h.IF ,
    CASE
        WHEN r.etat = 0
            THEN 'ANNULEE'
        WHEN r.etat = 1
            THEN 'CREE'
        WHEN r.etat = 11
            THEN 'VISEE'
        END AS etatlib,
    p.MATRICULE AS idRessourcelib
FROM ressourceParFabrication r
         LEFT JOIN PAIE_INFO_PERSONNEL p ON p.id = r.idRessource
         LEFT JOIN CATEGORIE_QUALIFICATION c
                   ON c.IDQUALIFICATION = r.IDQUALIFICATION
                       AND c.IDCATEGORIE = p.IDCATEGORIE
                       AND (
                          (c.REMARQUE IS NULL)
                              OR (c.REMARQUE = r.IDRESSOURCE)
                          ) AND c.etat = 1
         LEFT JOIN FABRICATION f ON f.id = r.idFabrication
         LEFT JOIN heureSupFabrication h ON h.idRessParFab = r.id
         LEFT JOIN POSTE po ON po.id =  c.idPoste;

