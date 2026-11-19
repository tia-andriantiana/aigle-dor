CREATE OR REPLACE VIEW HEURESUPFABRICATION_CPL (ID, IDRESSPARFAB, HEURENORMALE, HS, MN, JF, HD, IF, ETAT, REMARQUE, IDPERSONNE, IDFABRICATION, DATEFABRICATION, ETATLIB, IDPERSONNELIB, MATRICULE, TAUXHORAIRE, TAUXHORAIREEFFECTIVE, TEMPORAIRE, MONTANT, IDQUALIFICATION, MONTANTJF, MONTANTHD, MONTANTIF, MONTANTMN, MONTANTHN, IDDEPARTEMENT, DEPARTEMENTLIB, POSTE, POSTELIB, DATEIMPORT) AS 
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
    d.val as departementLib,
    h.poste,
    pf.val as PosteLib,
    h.DATEIMPORT
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