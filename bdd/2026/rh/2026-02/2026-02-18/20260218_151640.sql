create or replace view HEURESUPFABRICATION_CPL as
SELECT
    h.ID,h.IDRESSPARFAB,h.HEURENORMALE ,h.HS,h.MN,h.JF,h.HD,h.IF,h.ETAT,h.REMARQUE,
    p.id AS  idPersonne,
    h.idFabrication,
    fab.daty as dateFabrication,
    CASE
        WHEN h.etat=0
            THEN 'ANNULEE'
        WHEN h.etat=1
            THEN 'CREE'
        WHEN h.etat=11
            THEN 'VISEE'
        END AS etatlib,
    pm.NOM || ' ' || pm.PRENOM AS idPersonnelib,
    p.MATRICULE,
    r.TAUXHORAIRE,
    CAST(nvl(c.montant,0)/((40*52)/12) AS NUMBER(30,2) ) AS TAUXHORAIREEFFECTIVE,
    p.temporaire,
    h.MONTANT,
    r.IDQUALIFICATION,
    NVL(h.montantJF, 0) as montantJF,
    NVL(h.montantHD, 0) as montantHD,
    NVL(h.montantIF,0) as montantIF,
    NVL(h.montantMN, 0) as montantMN,
    NVL(h.MONTANTHN, 0) as montantHN,
    p.IDDEPARTEMENT,
    d.val as departementLib
FROM HEURESUPFABRICATION h
         LEFT JOIN RESSOURCEPARFABRICATIONCOMPLET r ON r.id = h.IDRESSPARFAB
         LEFT JOIN PAIE_INFO_PERSONNEL p ON p.id = r.idRessource
         LEFT JOIN CATEGORIE_QUALIFICATION c
                   ON c.IDQUALIFICATION = r.IDQUALIFICATION
                       AND c.IDCATEGORIE = r.IDCATEGORIE
                       AND (
                          (c.REMARQUE IS NULL)
                              OR (c.REMARQUE = r.IDRESSOURCE)
                          ) AND c.etat = 1
         LEFT JOIN LOG_PERSONNEL pm ON pm.id = r.IDRESSOURCE
         LEFT JOIN FABRICATION fab ON fab.ID = h.IDFABRICATION
         LEFT JOIN DEPARTEMENT d on d.id = p.IDDEPARTEMENT;

-- 15:16
create or replace view LOG_PERSONNEL_FIN as
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
       s.code_service AS service,
       s.code_dr,
       TO_CHAR(paie.matricule) AS matricule,
       paie.idcategorie,
       paie.ctg,
       paie.indicegrade,
       paie.indice_fonctionnel,
       paie.statut,
       c.taux AS categorieval,
       '''' AS ctgval,
       paie.numero_cnaps,
       paie.numero_ostie,
       CASE
           WHEN paie.temporaire = -1 THEN 'Temporaire'
           WHEN paie.temporaire = 0 THEN 'Permanent'
           WHEN paie.temporaire = 1 THEN 'Cadre'
           ELSE NULL
           END AS temporaire,
       NVL(dr.conge, 0) AS droit,
       NVL(cg.conge, 0) AS prie,
       NVL(dr.conge, 0) - NVL(cg.conge, 0) AS resteconge,
       paie.etat,
       l.id AS idpersonnel,
       l.direction AS iddirection,
       dp.val as departementLib,
       paie.IDDEPARTEMENT,
       paie.IDQUALIFICATION,
       paie.IDCATEGORIE_PAIE
FROM log_personnel l
         LEFT JOIN log_service s ON l.service = s.id
         LEFT JOIN paie_info_personnel paie ON paie.id = l.id
         LEFT JOIN sexe sex ON l.sexe = sex.id
         LEFT JOIN log_direction d ON d.id = l.direction
         LEFT JOIN paie_categorie c ON c.id = paie.idcategorie
         LEFT JOIN droitdeconge_parpersonne dr ON dr.idpersonnel = l.id
         LEFT JOIN congeprisgroupbypers cg ON cg.idpersonnel = l.id
         LEFT JOIN DEPARTEMENT dp ON dp.id = paie.IDDEPARTEMENT;



-- 15:17
CREATE OR REPLACE VIEW CATEGORIEQUALIFICATION_LIB AS
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
                              OR (c.REMARQUE = log.id)
                          )

         LEFT JOIN CATEGORIE_PAIE cp ON cp.id = c.IDCATEGORIE
         LEFT JOIN QUALIFICATION_PAIE qp ON qp.id = c.IDQUALIFICATION;


-- 15:20
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
       d.MOTIFREFU
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


create or replace view DEMANDE_LIBCOMPLET2 as
SELECT d.id,
       d.idpersonnel,
       pip.matricule AS matricules,
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
       d.datefin,
       d.dateretour,
       d.observation,
       d.remarque,
       lp.nom,
       lp.prenom,
       (lp.nom || ' ') || lp.prenom AS personnel,
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
       d.avenant
FROM demande d
         LEFT JOIN paie_info_personnel pip ON d.idpersonnel = pip.id
         LEFT JOIN paie_fonction pf ON pf.id = pip.idfonction
         LEFT JOIN typedemande t ON t.id = d.idtypedemande
         LEFT JOIN typeabsence t2 ON t2.id = d.idtypeabsence
         LEFT JOIN log_personnel lp ON lp.id = pip.id
         LEFT JOIN log_direction ld ON ld.id = lp.direction
         LEFT JOIN utilisateur u ON u.refuser = lp.refuser
         LEFT JOIN roles r ON r.idrole = u.idrole
         LEFT JOIN demande_remplacents rmp ON rmp.id = d.id;
