-- Stefan

CREATE OR REPLACE VIEW "SITUATION_SALAIRE_COMPLET"AS
SELECT se.MATRICULE,se.NOM,(se.ID||'//'||sa.idedition) AS id,se.MOIS,se.ANNEE,se.IDEDITION,se.SALAIRE,se.HS_M,se.INDEM,se.ANCIEN,se.PRIME,se.AUTRES,se.TOTAL,se.CNAPS,se.OSTIE,se.IRSA_E,se.IRSA_S,se.AV_SPE,se.AUTRES2,se.A_PAYER,sa.heuresupp30ni,heuresupp30i,heuresupp50ni,heuresupp50i,majnuit,majferie,majweekend,abbatement,
       CASE se.MOIS
           WHEN 1 THEN 'Janvier'
           WHEN 2 THEN 'Février'
           WHEN 3 THEN 'Mars'
           WHEN 4 THEN 'Avril'
           WHEN 5 THEN 'Mai'
           WHEN 6 THEN 'Juin'
           WHEN 7 THEN 'Juillet'
           WHEN 8 THEN 'Août'
           WHEN 9 THEN 'Septembre'
           WHEN 10 THEN 'Octobre'
           WHEN 11 THEN 'Novembre'
           WHEN 12 THEN 'Décembre'
           END AS MOISLIB
FROM SITUATION_SALAIRE_EDITION se
         LEFT JOIN SITUATION_SALAIRE_AUTRE sa
                   ON se.idedition =sa.idedition
                       AND se.id = sa.idpersonnel
;

CREATE OR REPLACE VIEW "DEMANDE_LIBCOMPLET" AS
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
           WHEN d.etat = 1 THEN 'Créé'
           WHEN d.etat = 11 THEN 'Validé'
           WHEN d.etat = -1 THEN 'Refusée'
           ELSE 'AUTRE'
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


CREATE OR REPLACE VIEW "LOG_PERS_NON_VALIDE_LIB" AS
SELECT
    lpnv.id,
    lp.nom || ' ' || lp.prenom AS idlogpers,
    lp.sexe,
    lpnv.dateapplication,
    td.val AS idtypedebauche,
    lpnv.etat,
    lpnv.iduser,
    pif.matricule,
    lpnv.date_decision,
    lpnv.refdecision,
    CASE
        WHEN lpnv.etat = 1 THEN
            'Créé'
        WHEN lpnv.etat = 11 THEN
            'Validé'
        WHEN lpnv.etat = 0 THEN
            'Annulé'
        ELSE
            'Inconnu'
        END AS etatLib
FROM log_personnel_non_valide lpnv
         LEFT JOIN type_depart td
                   ON td.id = lpnv.idtypedebauche
         LEFT JOIN paie_info_personnel pif
                   ON pif.id = lpnv.idlogpers
         LEFT JOIN log_personnel lp
                   ON lp.id = lpnv.idlogpers
WHERE lpnv.date_reintegration IS NULL
;


UPDATE MENUDYNAMIQUE
SET LIBELLE='Configuration ', ICONE='settings', HREF=NULL, RANG=5, NIVEAU=2, ID_PERE='MNDNMT01'
WHERE ID='MENDYN1770807165914602'

UPDATE MENUDYNAMIQUE
SET LIBELLE='Pièce', ICONE='list_alt', HREF=NULL, RANG=4, NIVEAU=3, ID_PERE='MNDNMT0134256'
WHERE ID='MENDYN1764614974716255'

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDN000000011071117', 'Fournisseur', 'group', 'module.jsp?but=fournisseur/fournisseur-liste.jsp', 4, 3, 'MENDYN1765272561517975')


CREATE OR REPLACE VIEW "PAIE_AVANCEMENT_LIBELLE2" AS
SELECT pav.id,
       dt.val AS motif,
       dt.id AS idmotif,
       (lp.nom || ' ') || lp.prenom AS id_logpers,
       lpad(pip.matricule, 5, '0') AS matricule,
       pip.id AS idpers,
       pav.datedecision,
       pav.refdecision,
       pav.date_application,
       ld.val AS direction,
       ls.code_service AS service,
       pf.id AS idfonction,
       pav.ctg,
       pg.val AS idcategorie,
       pav.echelon,
       pav.classee,
       pav.indicegrade,
       pav.indice_fonctionnel,
       CASE
           WHEN pip.temporaire = -1 THEN 'Temporaire'
           WHEN pip.temporaire = 0 THEN 'Permanent'
           WHEN pip.temporaire = 1 THEN 'Cadre'
           ELSE NULL
           END AS statut,
       pav.vehiculee,
       pav.remarque,
       lp.sexe,
       pav.etat,
       pav.matricule_patron,
       pav.droit_hs,
       pav.indice_ct,
       pav.code_banque,
       pf.desce AS fonctionLib,
       CASE
           WHEN pav.etat = 1 THEN 'NON VALIDÉ'
           WHEN pav.etat = 11 THEN 'VALIDÉE'
           ELSE 'AUTRE'
           END AS etatLib
FROM paie_avancement pav
         LEFT JOIN dec_decision_type dt ON dt.id = pav.motif
         JOIN log_personnel lp ON lp.id = pav.id_logpers
         LEFT JOIN paie_info_personnel pip ON pip.id = pav.id_logpers
         LEFT JOIN log_direction ld ON ld.id = pav.direction
         LEFT JOIN log_service ls ON ls.id = pav.service
         LEFT JOIN paie_fonction pf ON pf.id = pav.idfonction
         LEFT JOIN paie_categorie pg ON pg.id = pav.idcategorie
;

CREATE OR REPLACE VIEW "LOG_PERSONNEL_AVECCONGE" AS
SELECT l.id,
       l.permis_conduire,
       l.chemin_permis,
       l.remarque,
       l.id_pers,
       l.nom,
       l.prenom,
       l.date_naissance,
       sex.desce AS sexe,
       l.numero_cin,
       l.date_cin,
       l.date_dupl_cin,
       l.nationalite,
       l.adresse,
       l.fokotany,
       l.acte_naissance,
       d.val AS direction,
       s.libelle AS service,
       s.code_dr,
       TO_CHAR(paie.matricule) AS matricule,
       paie.idcategorie,
       paie.ctg,
       paie.indicegrade,
       paie.indice_fonctionnel,
       paie.statut,
       c.taux AS categorieval,
       '' AS ctgval,
       paie.numero_cnaps,
       paie.numero_ostie,
       CASE
           WHEN paie.temporaire = -1 THEN 'Temporaire'
           WHEN paie.temporaire = 0 THEN 'Permanent'
           WHEN paie.temporaire = 1 THEN 'Cadre'
           ELSE NULL
           END AS temporaire,
       CAST(NVL(sc.PLUS , 0) AS NUMBER(30, 2)) AS droit ,
       CAST(NVL(sp.CONGEPRIS , 0) AS NUMBER(30, 2)) AS prie,
       CAST(NVL(sc.SOLDE, 0) AS NUMBER(30, 2)) AS resteconge,
       paie.etat,
       l.id AS idpersonnel,
       l.direction AS iddirection,
       dp.val AS departementlib,
       CASE
           WHEN paie.etat < 1 THEN 'Débauchés'
           WHEN paie.etat = 1 THEN 'A Valider'
           WHEN paie.etat = 11 THEN 'Validés'
           ELSE NULL
           END AS etatLib
FROM log_personnel l
         LEFT JOIN log_service s ON l.service = s.id
         LEFT JOIN paie_info_personnel paie ON paie.id = l.id
         LEFT JOIN sexe sex ON l.sexe = sex.id
         LEFT JOIN log_direction d ON d.id = l.direction
         LEFT JOIN paie_categorie c ON c.id = paie.idcategorie
         LEFT JOIN SOLDECONGEPRIS_PERS sp ON l.id = sp.id
         LEFT JOIN SOLDECONGE_PERS sc ON l.id = sc.idPersonnel
         LEFT JOIN departement dp ON paie.idDepartement = dp.id
;

CREATE OR REPLACE VIEW "LOG_PERSONNEL_FIN_CONGE" AS
SELECT l.id,
       l.permis_conduire,
       l.chemin_permis,
       l.remarque,
       l.id_pers,
       l.nom,
       l.prenom,
       l.date_naissance,
       sex.desce AS sexe,
       l.numero_cin,
       l.date_cin,
       l.date_dupl_cin,
       l.nationalite,
       l.adresse,
       l.fokotany,
       l.acte_naissance,
       d.val AS direction,
       s.libelle AS service,
       s.code_dr,
       TO_CHAR(paie.matricule) AS matricule,
       paie.idcategorie,
       paie.ctg,
       paie.indicegrade,
       paie.indice_fonctionnel,
       paie.statut,
       c.taux AS categorieval,
       '' AS ctgval,
       paie.numero_cnaps,
       paie.numero_ostie,
       CASE
           WHEN paie.temporaire = -1 THEN 'Temporaire'
           WHEN paie.temporaire = 0 THEN 'Permanent'
           WHEN paie.temporaire = 1 THEN 'Cadre'
           ELSE NULL
           END AS temporaire,
       CAST(NVL(sc.PLUS , 0) AS NUMBER(30, 2)) AS droit ,
       CAST(NVL(sp.CONGEPRIS , 0) AS NUMBER(30, 2)) AS prie,
       CAST(NVL(sc.SOLDE, 0) AS NUMBER(30, 2)) AS resteconge,
       paie.etat,
       l.id AS idpersonnel,
       l.direction AS iddirection,
       dp.val AS departementlib,
       CASE
           WHEN paie.etat < 1 THEN 'Débauchés'
           WHEN paie.etat = 1 THEN 'A Valider'
           WHEN paie.etat = 11 THEN 'Validés'
           ELSE NULL
           END AS etatLib
FROM log_personnel l
         LEFT JOIN log_service s ON l.service = s.id
         LEFT JOIN paie_info_personnel paie ON paie.id = l.id
         LEFT JOIN sexe sex ON l.sexe = sex.id
         LEFT JOIN log_direction d ON d.id = l.direction
         LEFT JOIN paie_categorie c ON c.id = paie.idcategorie
         LEFT JOIN SOLDECONGEPRIS_PERS sp ON l.id = sp.id
         LEFT JOIN SOLDECONGE_PERS sc ON l.id = sc.idPersonnel
         LEFT JOIN departement dp ON paie.idDepartement = dp.id
;

CREATE OR REPLACE VIEW "LOG_PERSONNEL_FIN_VALIDE"  AS
SELECT lpf.id,
       lpf.permis_conduire,
       lpf.chemin_permis,
       lpf.remarque,
       lpf.id_pers,
       lpf.nom,
       lpf.prenom,
       lpf.date_naissance,
       lpf.sexe,
       lpf.numero_cin,
       lpf.date_cin,
       lpf.date_dupl_cin,
       lpf.nationalite,
       lpf.adresse,
       lpf.fokotany,
       lpf.acte_naissance,
       lpf.direction,
       lpf.service,
       lpf.code_dr,
       lpf.matricule,
       lpf.idcategorie,
       lpf.ctg,
       lpf.indicegrade,
       lpf.indice_fonctionnel,
       lpf.statut,
       lpf.categorieval,
       lpf.ctgval,
       lpf.numero_cnaps,
       lpf.numero_ostie,
       lpf.temporaire,
       lpf.droit,
       lpf.prie,
       lpf.resteconge,
       lpf.departementlib,
       lpf.etat,
       lpf.etatLib
FROM LOG_PERSONNEL_FIN_CONGE lpf
WHERE lpf.etat >= 11
;

CREATE OR REPLACE VIEW "LOG_PERSONNEL_FIN_A_VALIDER" AS
SELECT lpf.id,
       lpf.permis_conduire,
       lpf.chemin_permis,
       lpf.remarque,
       lpf.id_pers,
       lpf.nom,
       lpf.prenom,
       lpf.date_naissance,
       lpf.sexe,
       lpf.numero_cin,
       lpf.date_cin,
       lpf.date_dupl_cin,
       lpf.nationalite,
       lpf.adresse,
       lpf.fokotany,
       lpf.acte_naissance,
       lpf.direction,
       lpf.service,
       lpf.code_dr,
       lpf.matricule,
       lpf.idcategorie,
       lpf.ctg,
       lpf.indicegrade,
       lpf.indice_fonctionnel,
       lpf.statut,
       lpf.categorieval,
       lpf.ctgval,
       lpf.numero_cnaps,
       lpf.numero_ostie,
       lpf.temporaire,
       lpf.droit,
       lpf.prie,
       lpf.resteconge,
       lpf.departementlib,
       lpf.etat,
       lpf.etatLib
FROM LOG_PERSONNEL_FIN_CONGE lpf
WHERE lpf.etat = 1
;

CREATE OR REPLACE VIEW "LOG_PERSONNE_NON_VALIDE_VUE" AS
SELECT lpf.id,
       lpf.permis_conduire,
       lpf.chemin_permis,
       lpf.remarque,
       lpf.id_pers,
       lpf.nom,
       lpf.prenom,
       lpf.date_naissance,
       lpf.sexe,
       lpf.numero_cin,
       lpf.date_cin,
       lpf.date_dupl_cin,
       lpf.nationalite,
       lpf.adresse,
       lpf.fokotany,
       lpf.acte_naissance,
       lpf.direction,
       lpf.service,
       lpf.code_dr,
       lpf.matricule,
       lpf.idcategorie,
       lpf.ctg,
       lpf.indicegrade,
       lpf.indice_fonctionnel,
       lpf.statut,
       lpf.categorieval,
       lpf.ctgval,
       lpf.numero_cnaps,
       lpf.numero_ostie,
       lpf.temporaire,
       lpf.droit,
       lpf.prie,
       lpf.resteconge,
       lpf.departementlib,
       lpf.etat,
       lpf.etatLib
FROM LOG_PERSONNEL_FIN_CONGE lpf
WHERE lpf.etat < 1
;