alter table ACCIDENT add etat integer;

CREATE OR REPLACE VIEW v_accident_lib AS
SELECT acc.*,
       m.VAL AS id_machine_lib,
       lat.val AS id_lieu_lib,
       ta.VAL AS id_type_accident_lib,
       ga.val AS id_gravite_lib,
       lp.NOM || ' ' || lp.prenom AS id_personnel_lib,
       pip.MATRICULE AS matricule,
       CASE
           WHEN acc.etat = 1 THEN 'Créé'
           WHEN acc.etat = 11 THEN 'Déclaré'
           ELSE 'inconnu'
       END AS etat_lib
FROM Accident acc
         LEFT JOIN MACHINE m ON m.ID = acc.Id_machine
         LEFT JOIN lieu_accident_travail lat ON lat.ID = acc.id_lieu
         LEFT JOIN type_accident ta ON ta.id = acc.id_type_accident
         LEFT JOIN gravite_accident ga ON ga.id = acc.id_gravite
         LEFT JOIN LOG_PERSONNEL lp ON lp.ID = acc.ID_PERSONNEL
         LEFT JOIN PAIE_INFO_PERSONNEL pip ON pip.id = acc.ID_PERSONNEL;

