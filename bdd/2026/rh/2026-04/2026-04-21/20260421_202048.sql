

create or replace view RESSOURCEPARFAB_CPL_RECTIF as
SELECT
    r.id,
    r.daty,
    r.idFabrication,
    r.idPoste AS idPosteDefaut,
    r.idRessource,
    p.MATRICULE,
    r.IDPOSTE,
    poste.val as idPosteLib,
    CASE
        WHEN r.etat = 0
            THEN 'ANNULÉE'
        WHEN r.etat = 1
            THEN 'CRÉÉE'
        WHEN r.etat = 11
            THEN 'VISÉE'
        END AS etatlib
FROM ressourceParFabrication r
         LEFT JOIN PAIE_INFO_PERSONNEL p ON p.id = r.idRessource
         LEFT JOIN POSTE poste ON poste.id = r.IDPOSTE;

