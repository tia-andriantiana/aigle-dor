CREATE TABLE ACTIONROLE
(
    ID            VARCHAR2(50) NOT NULL
        CONSTRAINT PK_ACTIONROLES PRIMARY KEY,
    NOMTABLEOBJET VARCHAR2(50),
    ACTION        VARCHAR2(50),
    ROLEMINIMUM   NUMBER(30),
    DIRECTION     VARCHAR2(50),
    UTILISATEUR   VARCHAR2(50),
    GROUPETABLE   VARCHAR2(150)
);


CREATE TABLE POSTE
(
    ID    VARCHAR2(100) NOT NULL
        CONSTRAINT POSTE_PK PRIMARY KEY,
    VAL   VARCHAR2(200),
    DESCE VARCHAR2(200)
);


CREATE TABLE DEPARTEMENT
(
    ID    VARCHAR2(255) NOT NULL
        CONSTRAINT DEPARTEMENT_PK PRIMARY KEY,
    VAL   VARCHAR2(255),
    DESCE VARCHAR2(255)
);


CREATE TABLE TYPEDEMANDE
(
    ID    VARCHAR2(100) NOT NULL
        CONSTRAINT TYPEDEMANDE_PK PRIMARY KEY,
    VAL   VARCHAR2(200),
    DESCE VARCHAR2(200)
);


CREATE TABLE TYPEABSENCE
(
    ID    VARCHAR2(100) NOT NULL
        CONSTRAINT TYPEABSENCE_PK PRIMARY KEY,
    VAL   VARCHAR2(200),
    DESCE VARCHAR2(200)
);


CREATE TABLE CATEGORIE_PAIE
(
    ID              VARCHAR2(100) NOT NULL
        CONSTRAINT CATEGORIE_PAIE_PK PRIMARY KEY,
    VAL             VARCHAR2(500),
    DESCE           VARCHAR2(500),
    MONTANT         NUMBER(30, 2),
    REMARQUE        VARCHAR2(500),
    DROIT_HEURE_SUP VARCHAR2(500),
    ESSAIE          NUMBER(30, 2)
);


CREATE TABLE PAIE_CATEGORIE
(
    ID    VARCHAR2(50) NOT NULL
        CONSTRAINT PAIE_CATEGORIE_PKEY PRIMARY KEY,
    VAL   VARCHAR2(50),
    DESCE VARCHAR2(255),
    TAUX  VARCHAR2(50)
);


CREATE TABLE SEXE
(
    ID    VARCHAR2(50) NOT NULL,
    VAL   VARCHAR2(50),
    DESCE VARCHAR2(50)
);


CREATE TABLE BANQUE
(
    ID    VARCHAR2(100) NOT NULL
        CONSTRAINT PK_BANQUE PRIMARY KEY,
    VAL   VARCHAR2(500),
    DESCE VARCHAR2(500)
);


CREATE TABLE CONGE_FIN_2023
(
    ID        VARCHAR2(50) NOT NULL
        CONSTRAINT CONGE_FIN2023_PKEY PRIMARY KEY,
    MATRICULE VARCHAR2(50)
        CONSTRAINT CONGE_FIN_2023_MATRICULE_KEY UNIQUE,
    CONGE     NUMBER(10, 2)
);


CREATE TABLE LOG_PERSONNEL_NON_VALIDE
(
    ID                 VARCHAR2(100) NOT NULL
        CONSTRAINT LOG_EMPLOYE_VALIDE_PK PRIMARY KEY,
    IDLOGPERS          VARCHAR2(100) NOT NULL,
    DATEAPPLICATION    DATE NOT NULL,
    IDTYPEDEBAUCHE     VARCHAR2(100) NOT NULL,
    ETAT               NUMBER,
    IDUSER             VARCHAR2(100),
    MOTIF              VARCHAR2(100),
    DATE_REINTEGRATION DATE,
    DATE_DECISION      DATE,
    REFDECISION        VARCHAR2(100),
    IDAVANCEMENT       VARCHAR2(100),
    DATEFIN            DATE,
    IDPASSATION        VARCHAR2(100),
    DUREEPREAVIS       NUMBER(30, 2),
    STC                NUMBER
);

CREATE TABLE QUALIFICATION_PAIE
(
    ID      VARCHAR2(100) NOT NULL
        CONSTRAINT QUALIFICATION_PAIE_PK PRIMARY KEY,
    VAL     VARCHAR2(500),
    DESCE   VARCHAR2(500),
    IDPOSTE VARCHAR2(100)
        CONSTRAINT FK_POSTE REFERENCES POSTE
);


CREATE TABLE BANQUE_AGENCE
(
    ID         VARCHAR2(255) NOT NULL
        CONSTRAINT AGENCE_PK PRIMARY KEY,
    NOM        VARCHAR2(255),
    CODEAGENCE VARCHAR2(255),
    IDBANQUE   VARCHAR2(255)
        CONSTRAINT FK_BANQUE_AGENCE REFERENCES BANQUE
);

CREATE TABLE PAIE_INFO_PERSONNEL
(
    ID                     VARCHAR2(50) NOT NULL
        CONSTRAINT PAIE_INFO_PERSONNEL_PK PRIMARY KEY,
    DATESAISIE             DATE,
    MATRICULE              VARCHAR2(50),
    LIEU_NAISSANCE_COMMUNE VARCHAR2(50),
    LIEU_DELIVRANCE_CIN    VARCHAR2(50),
    SITUATION_MATRIMONIAL  VARCHAR2(50),
    INITIALE               VARCHAR2(50),
    CTURGENCE_NOM_PRENOM   VARCHAR2(255),
    CTURGENCE_TELEPHONE1   VARCHAR2(50),
    CTURGENCE_TELEPHONE2   VARCHAR2(50),
    CTURGENCE_TELEPHONE3   VARCHAR2(50),
    IDCONJOINT             VARCHAR2(50),
    CODE_AGENCE_BANQUE     VARCHAR2(50),
    BANQUE_NUMERO_COMPTE   VARCHAR2(50),
    BANQUE_COMPTE_CLE      VARCHAR2(50),
    DATEEMBAUCHE           DATE,
    IDFONCTION             VARCHAR2(50),
    IDCATEGORIE            VARCHAR2(50),
    MODE_PAIEMENT          VARCHAR2(50),
    CLASSEE                VARCHAR2(50),
    INDICEGRADE            NUMBER,
    INDICE_FONCTIONNEL     NUMBER,
    MATRICULE_PATRON       VARCHAR2(50),
    STATUT                 VARCHAR2(50),
    DROIT_HS               VARCHAR2(1),
    VEHICULEE              NUMBER DEFAULT 0,
    ECHELON                NUMBER,
    ETAT                   NUMBER,
    CTG                    VARCHAR2(50),
    IDUSER                 VARCHAR2(50),
    INDICE_CT              NUMBER,
    DATEPROMOTION          DATE,
    NUMERO_CNAPS           VARCHAR2(50),
    NUMERO_OSTIE           VARCHAR2(50),
    TEMPORAIRE             NUMBER,
    N_EMBAUCHE             VARCHAR2(50),
    DATE_DEPART            DATE,
    N_DEPART               VARCHAR2(50),
    NBENFANT               NUMBER,
    HEUREJOURNALIER        NUMBER(30, 2),
    HEUREHEBDOMADAIRE      NUMBER(30, 2),
    HEUREMENSUEL           NUMBER(30, 2),
    INDESIRABLE            NUMBER,
    DUREE                  NUMBER(30, 2),
    TELEPHONE              VARCHAR2(100),
    MAIL                   VARCHAR2(500),
    ADRESSE_LIGNE1         VARCHAR2(100),
    ADRESSE_LIGNE2         VARCHAR2(100),
    CODE_POSTAL            VARCHAR2(100),
    REGION                 VARCHAR2(100),

    IDCATEGORIE_PAIE       VARCHAR2(500)
        CONSTRAINT CATEGORIE_PAIE_FK
            REFERENCES CATEGORIE_PAIE,

    IDQUALIFICATION        VARCHAR2(500)
        CONSTRAINT QUALIFICATION_PAIE_FK
            REFERENCES QUALIFICATION_PAIE,

    FORMATION              VARCHAR2(1000),
    DISCIPLINE             VARCHAR2(1000),
    ANNEEEXPERIENCE        VARCHAR2(1000),
    PERSONNEL_ETAT         NUMBER,
    PERIODE_ESSAI          NUMBER,
    DEBUTCONTRAT           DATE,
    FINCONTRAT             DATE,
    REFUSER                NUMBER,
    TYPECONTRAT            VARCHAR2(100),
    IDDEPARTEMENT          VARCHAR2(255),

    IDBANQUE               VARCHAR2(255)
        CONSTRAINT FK_PAIEINFO_BANQUE
            REFERENCES BANQUE,

    IDAGENCE               VARCHAR2(255)
        CONSTRAINT FK_PAIEINFO_AGENCE
            REFERENCES BANQUE_AGENCE,

    IDSTATUT               VARCHAR2(100),
    SALAIREBASE            NUMBER(30, 2),
    TAUXHORAIRE            NUMBER(30, 2),
    UNITE                  VARCHAR2(255),
    RETRAITECOMPL          NUMBER(10)
);


CREATE TABLE DEMANDE
(
    ID               VARCHAR2(100) NOT NULL
        CONSTRAINT DEMANDE_PK PRIMARY KEY,

    IDPERSONNEL      VARCHAR2(100)
        CONSTRAINT DEMANDE_PAIEINFOPERS_ID_FK
            REFERENCES PAIE_INFO_PERSONNEL,

    IDTYPEDEMANDE    VARCHAR2(100)
        CONSTRAINT DEMANDE_TYPEDEMANDE_ID_FK
            REFERENCES TYPEDEMANDE,

    TITRE            VARCHAR2(100),
    HORAIRENORMAL    VARCHAR2(20),
    HEUREDEPART      VARCHAR2(20),
    HEUREARRIVE      VARCHAR2(20),

    IDTYPEABSENCE    VARCHAR2(100)
        CONSTRAINT DEMANDE_TYPEABS_ID_FK
            REFERENCES TYPEABSENCE,

    MOTIF            VARCHAR2(100),
    NUMERO           VARCHAR2(50),
    DESCE            VARCHAR2(200),
    ETAT             NUMBER,
    DATY             DATE,
    DUREE            NUMBER(10, 2),
    DATEDEPART       DATE,
    DATERETOUR       DATE,
    OBSERVATION      VARCHAR2(50),
    REMARQUE         VARCHAR2(200),
    IDREMPLACENTS    VARCHAR2(100),
    RESTE_CONGE      NUMBER(10, 2),
    DATEFIN          DATE,
    AVENANT          VARCHAR2(250),
    RESTE_PERMISSION NUMBER(10, 2),
    MOTIFREFU        VARCHAR2(500),
    WEEKENDDECOMPTE  NUMBER,
    IDDEPARTEMENT    VARCHAR2(255)
);



CREATE OR REPLACE VIEW CATEGORIE_PAIE_LIB AS
SELECT cp.id,
       cp.val,
       cp.desce,
       cp.montant,
       cp.remarque,
       CASE
           WHEN cp.droit_heure_sup = 'o' THEN 'OUI'
           WHEN cp.droit_heure_sup = 'n' THEN 'NON'
           ELSE NULL
           END AS droit_heure_sup,
       cp.essaie
FROM categorie_paie cp;



CREATE OR REPLACE VIEW CONGEPRIS AS
SELECT demande.id,
       demande.idpersonnel,
       demande.idtypedemande,
       demande.titre,
       demande.horairenormal,
       demande.heuredepart,
       demande.heurearrive,
       demande.idtypeabsence,
       demande.motif,
       demande.numero,
       demande.desce,
       demande.etat,
       demande.daty,
       demande.duree,
       demande.datedepart,
       demande.dateretour,
       demande.observation,
       demande.remarque,
       demande.idremplacents,
       demande.reste_conge,
       demande.datefin
FROM demande
WHERE demande.etat = 11
  AND demande.idtypeabsence = 'TYP000004';


CREATE OR REPLACE VIEW CONGEPRISGROUPBYPERS AS
SELECT congepris.idpersonnel,
       SUM(congepris.duree) AS conge
FROM congepris
GROUP BY congepris.idpersonnel;



CREATE OR REPLACE VIEW SOLDECONGE_FIN_2023 AS
SELECT pip.id AS idpersonnel,
       cf.id,
       cf.matricule,
       cf.conge
FROM conge_fin_2023 cf
         LEFT JOIN paie_info_personnel pip
                   ON pip.matricule = cf.matricule;


CREATE OR REPLACE VIEW DROITDECONGE_PARPERS AS
SELECT cd.idpersonnel AS idpersonnel,
       SUM(cd.conge) AS conge
FROM soldeconge_fin_2023 cd
GROUP BY cd.idpersonnel;


CREATE OR REPLACE VIEW JOURS_PAR_MOIS AS
SELECT
    EXTRACT(
            YEAR FROM ADD_MONTHS(DATE '2019-01-01', LEVEL - 1)
    ) AS annee,

    EXTRACT(
            MONTH FROM ADD_MONTHS(DATE '2019-01-01', LEVEL - 1)
    ) AS mois,

    TO_NUMBER(
            TO_CHAR(
                    LAST_DAY(
                            ADD_MONTHS(DATE '2019-01-01', LEVEL - 1)
                    ),
                    'DD'
            )
    ) AS nb_jour,

    ROUND(
            2.5 /
            TO_NUMBER(
                    TO_CHAR(
                            LAST_DAY(
                                    ADD_MONTHS(DATE '2019-01-01', LEVEL - 1)
                            ),
                            'DD'
                    )
            ),
            6
    ) AS conge_journalier

FROM dual

    CONNECT BY ADD_MONTHS(
               DATE '2019-01-01',
               LEVEL - 1
           ) < SYSDATE;


CREATE OR REPLACE VIEW PAIE_INFO_JOURS_MOIS AS

SELECT
    pip.id,
    pip.dateembauche,
    pip.date_depart,
    j.annee,
    j.mois,
    j.nb_jour,
    j.conge_journalier,

    0 AS jourplusdepart,

    CASE
        WHEN j.annee = EXTRACT(YEAR FROM pip.dateembauche)
            AND j.mois = EXTRACT(MONTH FROM pip.dateembauche)
            THEN EXTRACT(DAY FROM pip.dateembauche)
        ELSE 0
        END AS jourplusembauche

FROM paie_info_personnel pip,
     jours_par_mois j

WHERE
    TO_DATE(
            j.annee || LPAD(j.mois, 2, '0'),
            'YYYYMM'
    )
        >=
    TO_DATE(
            TO_CHAR(pip.dateembauche, 'YYYYMM'),
            'YYYYMM'
    )

  AND pip.date_depart IS NULL


UNION


SELECT
    pip.id,
    pip.dateembauche,
    pip.date_depart,
    j.annee,
    j.mois,
    j.nb_jour,
    j.conge_journalier,

    CASE
        WHEN j.annee = EXTRACT(YEAR FROM pip.date_depart)
            AND j.mois = EXTRACT(MONTH FROM pip.date_depart)
            THEN EXTRACT(DAY FROM pip.date_depart)
        ELSE 0
        END AS jourplusdepart,

    CASE
        WHEN j.annee = EXTRACT(YEAR FROM pip.dateembauche)
            AND j.mois = EXTRACT(MONTH FROM pip.dateembauche)
            THEN EXTRACT(DAY FROM pip.dateembauche)
        ELSE 0
        END AS jourplusembauche

FROM paie_info_personnel pip,
     jours_par_mois j

WHERE
    TO_DATE(
            j.annee || LPAD(j.mois, 2, '0'),
            'YYYYMM'
    )
        >=
    TO_DATE(
            TO_CHAR(pip.dateembauche, 'YYYYMM'),
            'YYYYMM'
    )

  AND pip.date_depart IS NOT NULL

  AND TO_DATE(
              j.annee || LPAD(j.mois, 2, '0'),
              'YYYYMM'
      )
    <=
      TO_DATE(
              TO_CHAR(pip.date_depart, 'YYYYMM'),
              'YYYYMM'
      );


CREATE OR REPLACE VIEW PAIE_INFO_JOURS_MOIS2 AS
SELECT p.id,
       p.dateembauche,
       p.date_depart,
       p.annee,
       p.mois,
       p.nb_jour,
       p.conge_journalier,
       p.jourplusdepart,
       p.jourplusembauche,

       CASE
           WHEN p.jourplusdepart > 0
               AND p.jourplusembauche = 0
               THEN p.jourplusdepart

           WHEN p.jourplusdepart = 0
               AND p.jourplusembauche > 0
               THEN p.nb_jour - p.jourplusembauche + 1

           WHEN p.jourplusdepart > 0
               AND p.jourplusembauche > 0
               THEN p.jourplusdepart - p.jourplusembauche

           WHEN p.annee = EXTRACT(YEAR FROM SYSDATE)
               AND p.mois = EXTRACT(MONTH FROM SYSDATE)
               THEN EXTRACT(DAY FROM SYSDATE)

           ELSE p.nb_jour
           END AS nbjoursvrai

FROM paie_info_jours_mois p;



CREATE OR REPLACE VIEW PAIE_INFO_JOURS_MOIS2_BIS AS
SELECT pijm.id,
       pijm.dateembauche,
       pijm.date_depart,
       pijm.annee,
       pijm.mois,
       pijm.nb_jour,
       pijm.conge_journalier,
       pijm.jourplusdepart,
       pijm.jourplusembauche,
       pijm.nbjoursvrai

FROM paie_info_jours_mois2 pijm

WHERE pijm.dateembauche <= TO_DATE('2024-01-01', 'YYYY-MM-DD')
  AND pijm.annee >= 2024;



CREATE OR REPLACE VIEW PAIE_INFO_JOURS_MOIS3_BIS AS
SELECT
    paie_info_jours_mois2_bis.id,

    ROUND(
            SUM(
                    paie_info_jours_mois2_bis.nbjoursvrai
                        *
                    paie_info_jours_mois2_bis.conge_journalier
            ),
            1
    ) AS jourconge

FROM paie_info_jours_mois2_bis

GROUP BY paie_info_jours_mois2_bis.id;


CREATE OR REPLACE VIEW DROITDECONGE_PARPERSONNE AS
SELECT
    dp.idpersonnel,

    ROUND(
            (dp.conge + pij.jourconge) * 2
    ) / 2 - 1.5 AS conge

FROM droitdeconge_parpers dp

         LEFT JOIN paie_info_jours_mois3_bis pij
                   ON dp.idpersonnel = pij.id;



CREATE OR REPLACE VIEW LOG_PERSONNEL_FIN AS
SELECT
    l.id,
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

    NVL(dr.conge, 0)
        -
    NVL(cg.conge, 0) AS resteconge,

    paie.etat,

    l.id AS idpersonnel,

    l.direction AS iddirection,

    dp.val AS departementLib,

    paie.IDDEPARTEMENT,
    paie.IDQUALIFICATION,

    qp.val AS qualificationLib,

    paie.IDCATEGORIE_PAIE

FROM log_personnel l

         LEFT JOIN log_service s
                   ON l.service = s.id

         LEFT JOIN paie_info_personnel paie
                   ON paie.id = l.id

         LEFT JOIN sexe sex
                   ON l.sexe = sex.id

         LEFT JOIN log_direction d
                   ON d.id = l.direction

         LEFT JOIN paie_categorie c
                   ON c.id = paie.idcategorie

         LEFT JOIN droitdeconge_parpersonne dr
                   ON dr.idpersonnel = l.id

         LEFT JOIN congeprisgroupbypers cg
                   ON cg.idpersonnel = l.id

         LEFT JOIN DEPARTEMENT dp
                   ON dp.id = paie.IDDEPARTEMENT

         LEFT JOIN QUALIFICATION_PAIE qp
                   ON qp.id = paie.IDQUALIFICATION;


CREATE OR REPLACE VIEW LOG_PERSONNEL_V AS
SELECT
    log_personnel_fin.id,
    log_personnel_fin.permis_conduire,
    log_personnel_fin.chemin_permis,
    log_personnel_fin.remarque,
    log_personnel_fin.id_pers,
    log_personnel_fin.nom,
    log_personnel_fin.prenom,
    log_personnel_fin.date_naissance,
    log_personnel_fin.sexe,
    log_personnel_fin.numero_cin,
    log_personnel_fin.date_cin,
    log_personnel_fin.date_dupl_cin,
    log_personnel_fin.nationalite,
    log_personnel_fin.adresse,
    log_personnel_fin.fokotany,
    log_personnel_fin.acte_naissance,
    log_personnel_fin.direction,
    log_personnel_fin.service,
    log_personnel_fin.code_dr,
    log_personnel_fin.matricule,
    log_personnel_fin.idcategorie,
    log_personnel_fin.ctg,
    log_personnel_fin.indicegrade,
    log_personnel_fin.indice_fonctionnel,
    log_personnel_fin.statut,
    log_personnel_fin.categorieval,
    log_personnel_fin.ctgval,
    log_personnel_fin.numero_cnaps,
    log_personnel_fin.numero_ostie,
    log_personnel_fin.temporaire,
    log_personnel_fin.resteconge,
    log_personnel_fin.idDIRECTION

FROM log_personnel_fin

WHERE NOT (
    log_personnel_fin.id IN
    (
        SELECT log_personnel_non_valide.idlogpers
        FROM log_personnel_non_valide
        WHERE log_personnel_non_valide.etat >= 11
    )
    );


CREATE OR REPLACE VIEW LOG_PERSONNEL_V2 AS
SELECT
    lpv.id,
    lpv.permis_conduire,
    lpv.chemin_permis,
    lpv.remarque,
    lpv.id_pers,
    lpv.nom,
    lpv.prenom,
    lpv.date_naissance,
    lpv.sexe,
    lpv.numero_cin,
    lpv.date_cin,
    lpv.date_dupl_cin,
    lpv.nationalite,
    lpv.adresse,
    lpv.fokotany,
    lpv.acte_naissance,
    lpv.direction,
    lpv.service,
    lpv.code_dr,
    lpv.matricule,
    lpv.idcategorie,
    lpv.ctg,
    lpv.indicegrade,
    lpv.indice_fonctionnel,
    lpv.statut,
    lpv.categorieval,
    lpv.ctgval,
    lpv.numero_cnaps,
    lpv.numero_ostie,
    lpv.temporaire,
    lpv.resteconge,

    cpl.val AS categorie,

    qp.val AS qualification,

    lpv.idDIRECTION,

    pinfo.iddepartement,

    pinfo.idcategorie_paie

FROM log_personnel_v lpv

         LEFT JOIN paie_info_personnel pinfo
                   ON pinfo.id = lpv.id

         LEFT JOIN categorie_paie_lib cpl
                   ON cpl.id = pinfo.idcategorie_paie

         LEFT JOIN qualification_paie qp
                   ON qp.id = pinfo.idqualification;



CREATE TABLE UTILISATEUR_PERSONNEL
(
    ID VARCHAR2(50) NOT NULL
        PRIMARY KEY,

    IDUTILISATEUR VARCHAR2(50)
        CONSTRAINT UQ_UP_UTILISATEUR UNIQUE,

    IDPERSONNEL VARCHAR2(50)
        CONSTRAINT UQ_UP_PERSONNEL UNIQUE
        CONSTRAINT FK_UP_PERSONNEL
            REFERENCES LOG_PERSONNEL
);



CREATE OR REPLACE VIEW LOG_PERSONNEL_V2_USER AS
SELECT
    l.ID,
    l.PERMIS_CONDUIRE,
    l.CHEMIN_PERMIS,
    l.REMARQUE,
    l.ID_PERS,
    l.NOM,
    l.PRENOM,
    l.DATE_NAISSANCE,
    l.SEXE,
    l.NUMERO_CIN,
    l.DATE_CIN,
    l.DATE_DUPL_CIN,
    l.NATIONALITE,
    l.ADRESSE,
    l.FOKOTANY,
    l.ACTE_NAISSANCE,
    l.DIRECTION,
    l.SERVICE,
    l.CODE_DR,
    l.MATRICULE,
    l.IDCATEGORIE,
    l.CTG,
    l.INDICEGRADE,
    l.INDICE_FONCTIONNEL,
    l.STATUT,
    l.CATEGORIEVAL,
    l.CTGVAL,
    l.NUMERO_CNAPS,
    l.NUMERO_OSTIE,
    l.TEMPORAIRE,
    l.RESTECONGE,
    l.CATEGORIE,
    l.QUALIFICATION,
    l.IDDIRECTION,
    l.IDDEPARTEMENT,
    l.IDCATEGORIE_PAIE,

    up.idUtilisateur AS idutilisateur

FROM log_personnel_v2 l

         JOIN utilisateur_personnel up
              ON up.idpersonnel = l.id;