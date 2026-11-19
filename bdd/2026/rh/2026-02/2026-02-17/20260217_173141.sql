-- CREATION MENU ACCIDENT

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MENDYN1771336006705273', 'Gestion des accidents', 'construction', null, 7, 3, 'ELM000633');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MENDYN1771336131953250', 'Liste des accidents', 'view_list', 'module.jsp?but=paie/accident/accident-liste.jsp', 2, 4, 'MENDYN1771336006705273');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MENDYN1771336173330884', 'Saisie d’un accident', 'add', 'module.jsp?but=paie/accident/accident-saisie.jsp', 1, 4, 'MENDYN1771336006705273');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MENDYN177133634086797', 'Nombre d’accident entre deux dates', 'bar_chart', 'module.jsp?but=paie/accident/accident-parmachine-graphe.jsp', 1, 5, 'MENDYN1771336275781841');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MENDYN1771336258318257', 'Liste des arrêts de travail', 'view_list', 'module.jsp?but=paie/accident/arretTravail-liste.jsp', 3, 4, 'MENDYN1771336006705273');

-- CREATION VIEW POUR LA DECLARATION ACCIDENT CNAPS
create or replace view V_ACCIDENT_PDF as
SELECT acc."ID",acc."DATY",acc."DATE_DECLARATION",acc."ID_PERSONNEL",acc."ID_LIEU",acc."ID_TYPE_ACCIDENT",acc."ID_GRAVITE",acc."ID_MACHINE",acc."CAUSE",acc."ETAT",
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
           END AS etat_lib,
       acc.DETAILSTEMOIN1,
       acc.DETAILSTEMOIN2,
       acc.HEUREACCIDENT,
       acc.HORAIREDEBUT,
       acc.HORAIREFIN,
       acc.ACTIVITE,
       acc.LESIONS,
       acc.CENTRESOIN,
       lp.NUMERO_CIN,
       lp.DATE_NAISSANCE,
       pf.val as fonction,
       lp.ADRESSE,
       pip.DATEEMBAUCHE,
       pip.NUMERO_CNAPS
FROM Accident acc
         LEFT JOIN MACHINE m ON m.ID = acc.Id_machine
         LEFT JOIN lieu_accident_travail lat ON lat.ID = acc.id_lieu
         LEFT JOIN type_accident ta ON ta.id = acc.id_type_accident
         LEFT JOIN gravite_accident ga ON ga.id = acc.id_gravite
         LEFT JOIN LOG_PERSONNEL lp ON lp.ID = acc.ID_PERSONNEL
         LEFT JOIN PAIE_INFO_PERSONNEL pip ON pip.id = acc.ID_PERSONNEL
         LEFT JOIN PAIE_FONCTION pf ON pf.id = pip.IDFONCTION;



-- RECTIF VIEW ACCIDENT LIB 17:32
create or replace view V_ACCIDENT_LIB as
SELECT acc."ID",acc."DATY",acc."DATE_DECLARATION",acc."ID_PERSONNEL",acc."ID_LIEU",acc."ID_TYPE_ACCIDENT",acc."ID_GRAVITE",acc."ID_MACHINE",acc."CAUSE",acc."ETAT",
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
           END AS etat_lib,
       acc.DETAILSTEMOIN1,
       acc.DETAILSTEMOIN2,
       acc.HEUREACCIDENT,
       acc.HORAIREDEBUT,
       acc.HORAIREFIN,
       acc.ACTIVITE,
       acc.LESIONS,
       acc.CENTRESOIN
FROM Accident acc
         LEFT JOIN MACHINE m ON m.ID = acc.Id_machine
         LEFT JOIN lieu_accident_travail lat ON lat.ID = acc.id_lieu
         LEFT JOIN type_accident ta ON ta.id = acc.id_type_accident
         LEFT JOIN gravite_accident ga ON ga.id = acc.id_gravite
         LEFT JOIN LOG_PERSONNEL lp ON lp.ID = acc.ID_PERSONNEL
         LEFT JOIN PAIE_INFO_PERSONNEL pip ON pip.id = acc.ID_PERSONNEL;

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MENDYN1771336275781841', 'Analyse', 'analytics', null, 4, 4, 'MENDYN1771336006705273');
