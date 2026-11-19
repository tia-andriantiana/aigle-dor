ALTER TABLE DEMANDE ADD WEEKENDDECOMPTE NUMBER;

-- 19:16
create or replace view DEMANDE_LIBCOMPLET as
SELECT d.id,
       d.idpersonnel,
       pip.matricule,
       pip.idfonction,
       pf.val AS fonctionlib,
       d.idtypedemande,
       t.val AS typedemandelib,
       d.titre,
       d.horairenormal,
       d.heuredepart,
       d.heurearrive,
       d.idtypeabsence,
       t2.desce AS typeabsencelib,
       d.motif,
       d.numero,
       d.desce,
       d.etat,
       d.daty,
       d.duree,
       d.datedepart,
       d.dateretour,
       d.observation,
       d.remarque,
       lp.nom,
       lp.prenom,
       lp.direction AS iddirection,
       ld.val AS directionlib,
       CASE
           WHEN d.etat = 1 THEN '<span style="color:green;">CR&Eacute;&Eacute;E</span>'
           WHEN d.etat = 11 THEN '<span style="color:blue;">VIS&Eacute;E</span>'
           WHEN d.etat = -1 THEN '<span style="color:red;">REFUS&Eacute;E</span>'
           ELSE '<span style="color: yellow;">AUTRE</span>'
           END AS etatlib,
       u.refuser,
       r.rang AS ranguser,
       d.idremplacents,
       rmp.remplacents,
       pip.matricule AS matricules,
       d.datefin,
       (lp.nom || ' ') || lp.prenom AS personnel,
       lp.idsup,
       d.avenant,
       CASE
           WHEN d.avenant IS NOT NULL THEN 'OUI'
           ELSE NULL
           END AS annuler,
       (pl.nom || ' ') || pl.prenom AS superieur,
       d.MOTIFREFU,
       CASE WHEN
                WEEKENDDECOMPTE = 1 THEN 'OUI'
            WHEN WEEKENDDECOMPTE = 0 THEN 'NON'
           END AS weekendDecompteLib
FROM demande d
         LEFT JOIN paie_info_personnel pip ON d.idpersonnel = pip.id
         LEFT JOIN paie_fonction pf ON pf.id = pip.idfonction
         LEFT JOIN typedemande t ON t.id = d.idtypedemande
         LEFT JOIN typeabsence t2 ON t2.id = d.idtypeabsence
         LEFT JOIN log_personnel lp ON lp.id = pip.id
         LEFT JOIN log_direction ld ON ld.id = lp.direction
         LEFT JOIN utilisateur u ON u.refuser = lp.refuser
         LEFT JOIN roles r ON r.idrole = u.idrole
         LEFT JOIN demande_remplacents rmp ON rmp.id = d.id
         LEFT JOIN log_personnel pl ON pl.id = lp.idsup;

