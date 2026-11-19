ALTER TABLE DEMANDE ADD IDDEPARTEMENT VARCHAR2(255);

-- 19:51
INSERT INTO TYPE_ABSENCE (ID, VAL, DESCE) VALUES ('TYPCOL0004', 'Congé Collectif', 'Congé Collectif');

INSERT INTO TYPEABSENCE (ID, VAL, DESCE) VALUES ('TYPCOL0004', 'Congé Collectif', 'Congé Collectif');


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
           END AS weekendDecompteLib,
       d.IDDEPARTEMENT,
       dp.DESCE as departementLib
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
         LEFT JOIN log_personnel pl ON pl.id = lp.idsup
         LEFT JOIN DEPARTEMENT dp ON dp.id = d.IDDEPARTEMENT;




CREATE OR REPLACE VIEW congecollectif_lib AS
select *
from DEMANDE_LIBCOMPLET where idtypeabsence='TYPCOL0004';

-- delete from MENUDYNAMIQUE where id='MENDYN17654822343459COL';
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENDYN17654822343459COL', 'Congé collectif', 'sticky_note_2', 'module.jsp?but=paie/demande/conge-collectif-liste.jsp', 4,
        3, 'MENDYN1765481923948780');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENDYN17654822343459GRPH', 'Taux d''absenteisme', 'bar_chart', 'module.jsp?but=paie/demande/tauxabsenteisme-graphe.jsp', 5,
        3, 'MENDYN1765481923948780');


INSERT INTO TYPE_ABSENCE (ID, VAL, DESCE) VALUES ('TYPEV0001', 'Mariage de l’employé', 'Mariage de l’employé');
INSERT INTO TYPE_ABSENCE (ID, VAL, DESCE) VALUES ('TYPEV0002', 'Mariage d’un enfant', 'Mariage d’un enfant');
INSERT INTO TYPE_ABSENCE (ID, VAL, DESCE) VALUES ('TYPEV0003', 'Baptême / cérémonie coutumière', 'Baptême / cérémonie coutumière');
INSERT INTO TYPE_ABSENCE (ID, VAL, DESCE) VALUES ('TYP00MAT', 'Maternité', 'Maternité');


INSERT INTO TYPEABSENCE (ID, VAL, DESCE) VALUES ('TYPEV0001', 'Mariage de l’employé', 'Mariage de l’employé');
INSERT INTO TYPEABSENCE (ID, VAL, DESCE) VALUES ('TYPEV0002', 'Mariage d’un enfant', 'Mariage d’un enfant');
INSERT INTO TYPEABSENCE (ID, VAL, DESCE) VALUES ('TYPEV0003', 'Baptême / cérémonie coutumière', 'Baptême / cérémonie coutumière');
INSERT INTO TYPEABSENCE (ID, VAL, DESCE) VALUES ('TYP00MAT', 'Maternité', 'Maternité');
