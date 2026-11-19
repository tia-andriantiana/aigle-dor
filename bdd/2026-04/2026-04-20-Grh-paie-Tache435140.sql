CREATE OR REPLACE FUNCTION GETSEQPAIE_AVANCEMENT
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
   SELECT SEQPAIE_AVANCEMENT.NEXTVAL INTO retour FROM DUAL;

   RETURN retour;
END;
 CREATE OR REPLACE VIEW EFFECTIF_LOG_PERSONNEL AS
SELECT
    CASE
        WHEN sexe = 'Masculin' THEN 'Masculin'
        WHEN sexe = 'Feminin' THEN 'Feminin'
        ELSE 'Non défini'
    END AS sexe,
    COUNT(*) AS nombre,
    idCategorie,
    idCategorieLib,
    IDDEPARTEMENT AS idDepartement,
    departementLib
FROM LOG_PERSONNEL_GRAPHE
GROUP BY
    CASE
        WHEN sexe = 'Masculin' THEN 'Masculin'
        WHEN sexe = 'Feminin' THEN 'Feminin'
        ELSE 'Non défini'
    END,
    idCategorie,
    idCategorieLib,
    IDDEPARTEMENT,
    departementLib;

CREATE OR REPLACE VIEW SUM_HS_MONTH_LIB AS
SELECT
    EXTRACT(YEAR FROM dateFabrication) AS annee,
    EXTRACT(MONTH FROM dateFabrication) AS mois,
    TO_CHAR(dateFabrication, 'Month YYYY', 'NLS_DATE_LANGUAGE=FRENCH') AS monthLib,
    SUM(HS) AS avg_hs_per_month,
    IDDEPARTEMENT,
    departementLib
FROM HEURESUPFABRICATION_CPL
GROUP BY
    EXTRACT(YEAR FROM dateFabrication),
    EXTRACT(MONTH FROM dateFabrication),
    TO_CHAR(dateFabrication, 'Month YYYY', 'NLS_DATE_LANGUAGE=FRENCH'),
    IDDEPARTEMENT,
    departementLib
ORDER BY
    annee,
    mois;

    CREATE OR REPLACE VIEW SUM_HS_DAY AS
SELECT
    dateFabrication AS jour,
    SUM(HS) AS avg_hs_per_day,
    IDDEPARTEMENT,
    departementLib
FROM HEURESUPFABRICATION_CPL
GROUP BY dateFabrication, IDDEPARTEMENT, departementLib
ORDER BY dateFabrication;

-- PER MONTH
CREATE OR REPLACE VIEW SUM_HS_MONTH AS
SELECT
    EXTRACT(YEAR FROM dateFabrication) AS annee,
    EXTRACT(MONTH FROM dateFabrication) AS mois,
    SUM(HS) AS avg_hs_per_month,
    IDDEPARTEMENT,
    departementLib
FROM HEURESUPFABRICATION_CPL
GROUP BY
    EXTRACT(YEAR FROM dateFabrication),
    EXTRACT(MONTH FROM dateFabrication),
    IDDEPARTEMENT,
    departementLib
ORDER BY annee, mois;

-- PER YEAR
create or replace view SUM_HS_YEAR AS
SELECT
    EXTRACT(YEAR FROM dateFabrication) AS annee,
    SUM(HS) AS avg_hs_per_year,
    IDDEPARTEMENT,
    departementLib
FROM HEURESUPFABRICATION_CPL
GROUP BY EXTRACT(YEAR FROM dateFabrication),IDDEPARTEMENT,
         departementLib
ORDER BY annee;

INSERT INTO TYPE_ACCIDENT (ID, VAL, DESCE) VALUES ('TA010', 'Autre', 'Autre');
INSERT INTO TYPE_ACCIDENT (ID, VAL, DESCE) VALUES ('TA011', 'Glissade', 'Glissade');
INSERT INTO TYPE_ACCIDENT (ID, VAL, DESCE) VALUES ('TA012', 'Frappe par outil', 'Frappe par outil');
INSERT INTO TYPE_ACCIDENT (ID, VAL, DESCE) VALUES ('TA013', 'Explosion', 'Explosion');
INSERT INTO TYPE_ACCIDENT (ID, VAL, DESCE) VALUES ('TA014', 'Incendie', 'Incendie');
INSERT INTO TYPE_ACCIDENT (ID, VAL, DESCE) VALUES ('TA015', 'Contact chimique', 'Contact chimique');

INSERT INTO LIEU_ACCIDENT_TRAVAIL (ID, VAL, DESCE)
VALUES ('LAC0001', 'CHANTIER', 'CHANTIER');
INSERT INTO LIEU_ACCIDENT_TRAVAIL (ID, VAL, DESCE)
VALUES ('LAC0002', 'BUREAU', 'BUREAU');
INSERT INTO LIEU_ACCIDENT_TRAVAIL (ID, VAL, DESCE)
VALUES ('LAC0003', 'ATELIER', 'ATELIER');
INSERT INTO LIEU_ACCIDENT_TRAVAIL (ID, VAL, DESCE)
VALUES ('LAC0004', 'ENTREPOT', 'ENTREPOT');
INSERT INTO LIEU_ACCIDENT_TRAVAIL (ID, VAL, DESCE)
VALUES ('LAC0005', 'MAGASIN', 'MAGASIN');

INSERT INTO GRAVITE_ACCIDENT (ID, VAL, DESCE)
VALUES ('GRA0001', 'LEGER', 'LEGER');
INSERT INTO GRAVITE_ACCIDENT (ID, VAL, DESCE)
VALUES ('GRA0002', 'MOYEN', 'MOYEN');
INSERT INTO GRAVITE_ACCIDENT (ID, VAL, DESCE)
VALUES ('GRA0003', 'GRAVE', 'GRAVE');
INSERT INTO GRAVITE_ACCIDENT (ID, VAL, DESCE)
VALUES ('GRA0004', 'CRITIQUE', 'CRITIQUE');
INSERT INTO GRAVITE_ACCIDENT (ID, VAL, DESCE)
VALUES ('GRA0005', 'FATAL', 'FATAL');

UPDATE MENUDYNAMIQUE SET HREF='module.jsp?but=paie/editions/paieedition-analyse3.jsp' WHERE ID='MENDYN003';
UPDATE MENUDYNAMIQUE SET HREF='module.jsp?but=paie/editions/paieedition-analyse2.jsp' WHERE ID='MENDYN002';
UPDATE MENUDYNAMIQUE SET  HREF='module.jsp?but=paie/annexe/categorie-paie-liste.jsp' WHERE ID='MENDYN1776671295351277';
UPDATE MENUDYNAMIQUE SET  ICONE='add' WHERE ID='MD00021110006';
UPDATE MENUDYNAMIQUE SET  HREF=NULL WHERE ID='MD00021110005';

INSERT INTO USERMENU
(ID, REFUSER, IDMENU, IDROLE, CODESERVICE, CODEDIR, INTERDIT)
VALUES('UMP00001', NULL, 'MENDYN1776671295351277', 'dg', NULL, NULL, 1);
INSERT INTO USERMENU
(ID, REFUSER, IDMENU, IDROLE, CODESERVICE, CODEDIR, INTERDIT)
VALUES('USMP0002', NULL, 'MENDYN1773227713298979', 'dg', NULL, NULL, 1);
INSERT INTO USERMENU
(ID, REFUSER, IDMENU, IDROLE, CODESERVICE, CODEDIR, INTERDIT)
VALUES('USMP0003', NULL, 'MD00021110071', 'dg', NULL, NULL, 1);
INSERT INTO USERMENU
(ID, REFUSER, IDMENU, IDROLE, CODESERVICE, CODEDIR, INTERDIT)
VALUES('USMP0004', NULL, 'MENDYN1773220215257281', 'dg', NULL, NULL, 1);

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



CREATE OR REPLACE VIEW CONGECOLLECTIF_LIB (ID, IDPERSONNEL, MATRICULE, IDFONCTION, FONCTIONLIB, IDTYPEDEMANDE, TYPEDEMANDELIB, TITRE, HORAIRENORMAL, HEUREDEPART, HEUREARRIVE, IDTYPEABSENCE, TYPEABSENCELIB, MOTIF, NUMERO, DESCE, ETAT, DATY, DUREE, DATEDEPART, DATERETOUR, OBSERVATION, REMARQUE, NOM, PRENOM, IDDIRECTION, DIRECTIONLIB, ETATLIB, REFUSER, RANGUSER, IDREMPLACENTS, REMPLACENTS, MATRICULES, DATEFIN, PERSONNEL, IDSUP, AVENANT, ANNULER, SUPERIEUR, MOTIFREFU, WEEKENDDECOMPTELIB, IDDEPARTEMENT, DEPARTEMENTLIB) AS 
SELECT
	ID,
	IDPERSONNEL,
	MATRICULE,
	IDFONCTION,
	FONCTIONLIB,
	IDTYPEDEMANDE,
	TYPEDEMANDELIB,
	TITRE,
	HORAIRENORMAL,
	HEUREDEPART,
	HEUREARRIVE,
	IDTYPEABSENCE,
	TYPEABSENCELIB,
	MOTIF,
	NUMERO,
	DESCE,
	ETAT,
	DATY,
	DUREE,
	DATEDEPART,
	DATERETOUR,
	OBSERVATION,
	REMARQUE,
	NOM,
	PRENOM,
	IDDIRECTION,
	DIRECTIONLIB,
	ETATLIB,
	REFUSER,
	RANGUSER,
	IDREMPLACENTS,
	REMPLACENTS,
	MATRICULES,
	DATEFIN,
	PERSONNEL,
	IDSUP,
	AVENANT,
	ANNULER,
	SUPERIEUR,
	MOTIFREFU,
	WEEKENDDECOMPTELIB,
	IDDEPARTEMENT,
	DEPARTEMENTLIB
FROM
	DEMANDE_LIBCOMPLET
WHERE
	idtypeabsence = 'TYPCOL0004'
 ;

 
CREATE OR REPLACE VIEW HS_GROUPE AS
SELECT *
FROM (
         SELECT
             p.id,
             p.matricule,
             p.id_code_rubrique,
             p.nomRubrique,
             p.date_debut,
             p.date_fin,
             p.gain,
             p.retenue,
             p.remarque,
             p.nomPersonnel,
             p.etat,
             p.id_objet,
             p.iduser,
             p.moisregularisation,
             p.anneeregularisation,
             p.idcategorie_qualification,
             p.idfonction,
             p.pourcentage,
             p.etatLib
         FROM PAIEPERS_ELP_CPL p
     )
         PIVOT (
                SUM(gain)
    FOR id_code_rubrique IN (
        'PR0000130'  AS "HS_30_NI",
        'PR0000130I' AS "HS_30_I",
        'PR0000150'  AS "HS_50_NI",
        'PR0000150I' AS "HS_50_I"
        )
        ) ORDER BY matricule ASC;