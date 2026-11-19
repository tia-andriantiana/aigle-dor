-- Stefan

CREATE OR REPLACE VIEW "HEURESUPFABRICATION_CPL" ("ID", "IDRESSPARFAB", "HEURENORMALE", "HS", "MN", "JF", "HD", "IF", "ETAT", "REMARQUE", "IDPERSONNE", "IDFABRICATION", "DATEFABRICATION", "ETATLIB", "IDPERSONNELIB", "MATRICULE", "TAUXHORAIRE", "TAUXHORAIREEFFECTIVE", "TEMPORAIRE", "MONTANT", "IDQUALIFICATION", "MONTANTJF", "MONTANTHD", "MONTANTIF", "MONTANTMN", "MONTANTHN", "IDDEPARTEMENT", "DEPARTEMENTLIB") AS
SELECT
    h.ID,h.IDRESSPARFAB,h.HEURENORMALE ,h.HS,h.MN,h.JF,h.HD,h.IF,h.ETAT,h.REMARQUE,
    p.id AS  idPersonne,
    h.idFabrication,
    h.daty as dateFabrication,
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

CREATE OR REPLACE VIEW "HEURESUPFABRICATION_CPL_VISEE" AS
SELECT
hs.*
FROM heureSupFabrication_cpl hs WHERE etat = 11
;

CREATE OR REPLACE VIEW "HEURESUPFABRICATION_CUMUL" ("IDPERSONNE", "IDPERSONNELIB", "MATRICULE", "SEMAINE", "JOUR", "HEUREJOUR", "HEUREDEJACUMULEES") AS
SELECT
    p.id AS idPersonne,
    pm.NOM AS idPersonnelib,
    p.MATRICULE,
    TO_CHAR(h.daty, 'IYYY-IW') AS semaine,
    h.daty AS jour,
    SUM(h.HS) AS heureJour,
    SUM(SUM(h.HS)) OVER (
        PARTITION BY p.id, TO_CHAR(h.daty, 'IYYY-IW')
        ORDER BY h.daty
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) - SUM(h.HS) AS heureDejaCumulees
FROM HEURESUPFABRICATION h
         LEFT JOIN RESSOURCEPARFABRICATIONCOMPLET r ON r.id = h.IDRESSPARFAB
         LEFT JOIN PAIE_INFO_PERSONNEL p ON p.id = r.idRessource
         LEFT JOIN PERSONNEL_MATRICULE pm ON pm.id = r.IDRESSOURCE
         LEFT JOIN FABRICATION fab ON fab.ID = h.IDFABRICATION
WHERE h.ETAT >= 11
GROUP BY p.id, pm.NOM, p.MATRICULE, h.daty
;

CREATE OR REPLACE VIEW "HEURESUPFABRICATION_TOTAL" ("IDPERSONNE", "IDPERSONNELIB", "MATRICULE", "TAUXHORAIRE", "TAUXHORAIREEFFECTIVE", "TEMPORAIRE", "SEMAINE", "TOTALHEURESEMAINE") AS
SELECT
    p.id AS idPersonne,
    pm.NOM AS idPersonnelib,
    p.MATRICULE,
    r.TAUXHORAIRE,
    CAST(NVL(c.montant,0)/((40*52)/12) AS NUMBER(30,2)) AS TAUXHORAIREEFFECTIVE,
    p.temporaire,
    TO_CHAR(h.daty, 'IYYY-IW') AS semaine,
    SUM(h.HS) AS totalHeureSemaine
FROM HEURESUPFABRICATION h
         LEFT JOIN RESSOURCEPARFABRICATIONCOMPLET r ON r.id = h.IDRESSPARFAB
         LEFT JOIN PAIE_INFO_PERSONNEL p ON p.id = r.idRessource
         LEFT JOIN CATEGORIE_QUALIFICATION c ON c.IDQUALIFICATION = p.IDQUALIFICATION
         LEFT JOIN PERSONNEL_MATRICULE pm ON pm.id = r.IDRESSOURCE
         LEFT JOIN FABRICATION fab ON fab.ID = h.IDFABRICATION
GROUP BY p.id, pm.NOM, p.MATRICULE, r.TAUXHORAIRE, p.temporaire,
         TO_CHAR(h.daty, 'IYYY-IW'), c.montant
;

CREATE OR REPLACE VIEW "RESSOURCEPARFABRICATIONCOMPLET" ("ID", "DATY","IDFABRICATION", "IDPOSTEDEFAUT", "IDRESSOURCE", "MATRICULE", "IDOF", "ETAT", "TEMPORAIRE", "IDQUALIFICATION", "IDCATEGORIE", "IDPOSTE", "IDPOSTELIB", "IDQUALIFICATIONEFFECTIVE", "TAUXHORAIRE", "HS", "MN", "JF", "HD", "IF", "ETATLIB", "IDRESSOURCELIB") AS
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
         LEFT JOIN CATEGORIE_QUALIFICATION c ON c.IDQUALIFICATION = r.IDQUALIFICATION
         LEFT JOIN FABRICATION f ON f.id = r.idFabrication
         LEFT JOIN heureSupFabrication h ON h.idRessParFab = r.id
         LEFT JOIN POSTE po ON po.id =  c.idPoste
;