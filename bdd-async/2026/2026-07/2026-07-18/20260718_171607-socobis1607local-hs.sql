ALTER TABLE HEURESUPFABRICATION ADD TAUXHORAIRE NUMBER(30, 2);

create or replace view HEURESUPFABRICATION_CPL as
SELECT
    h.ID,h.IDRESSPARFAB,h.HEURENORMALE ,h.HS,h.MN,h.JF,h.HD,h.IF,h.ETAT,h.REMARQUE,
    p.id AS  idPersonne,
    h.idFabrication,
    h.daty as dateFabrication,
    CASE
        WHEN h.etat=0
            THEN 'ANNULÉ'
        WHEN h.etat=1
            THEN 'CRÉÉ'
        WHEN h.etat=11
            THEN 'VISÉ'
        END AS etatlib,
    pm.NOM || ' ' || pm.PRENOM AS idPersonnelib,
    p.MATRICULE,
    h.TAUXHORAIRE,
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
    d.val as departementLib,
    h.poste,
    pf.val as PosteLib,
    h.DATEIMPORT,
    h.MONTANTHEURESUPP
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
         LEFT JOIN DEPARTEMENT d on d.id = p.IDDEPARTEMENT
         LEFT JOIN PAIE_FONCTION pf on pf.id = h.poste;


create or replace view HEURESUPFABRICATION_CPL_VISEE as
SELECT
    hs.ID,
    hs.IDRESSPARFAB,
    hs.HEURENORMALE,
    hs.HS,
    hs.MN,
    hs.JF,
    hs.HD,
    hs.IF,
    hs.ETAT,
    hs.REMARQUE,
    hs.IDPERSONNE,
    hs.IDFABRICATION,
    hs.DATEFABRICATION,
    hs.ETATLIB,
    hs.IDPERSONNELIB,
    hs.MATRICULE,
    CAST(hs.TAUXHORAIRE AS NUMBER(30,2)) as TAUXHORAIRE,
    hs.TAUXHORAIREEFFECTIVE,
    hs.TEMPORAIRE,
    CAST(hs.MONTANT AS NUMBER(30,2)) AS montantTotal,
    hs.IDQUALIFICATION,
    hs.MONTANTJF AS valeurJF,
    hs.MONTANTHD AS valeurHD,
    hs.MONTANTIF AS valeurIF,
    hs.MONTANTMN AS valeurMN,
    hs.MONTANTHN AS valeurHN,
    hs.MONTANTHEURESUPP AS valeurHS,
    hs.IDDEPARTEMENT,
    hs.DEPARTEMENTLIB
FROM HEURESUPFABRICATION_CPL hs
WHERE hs.ETAT = 11;





create or replace view CHARGEPERSONNEL_CPL as
SELECT
    hs.*,
    hs.TAUXHORAIRE as th

FROM HEURESUPFABRICATION_CPL_VISEE hs;

