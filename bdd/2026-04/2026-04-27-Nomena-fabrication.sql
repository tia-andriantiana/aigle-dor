create OR REPLACE view HEURESUPFABRICATION_CPL as
SELECT SQ."ID",SQ."IDRESSPARFAB",SQ."HEURENORMALE",SQ."HS",SQ."MN",SQ."JF",SQ."HD",SQ."IF",SQ."ETAT",SQ."REMARQUE",SQ."IDPERSONNE",SQ."IDFABRICATION",SQ."DATEFABRICATION",SQ."ETATLIB",SQ."IDPERSONNELIB",SQ."MATRICULE",SQ."TAUXHORAIRE",SQ."TAUXHORAIREEFFECTIVE",SQ."TEMPORAIRE",SQ."MONTANT",SQ."IDQUALIFICATION",SQ."MONTANTJF",SQ."MONTANTHD",SQ."MONTANTIF",SQ."MONTANTMN",SQ."MONTANTHN",SQ."IDDEPARTEMENT",SQ."DEPARTEMENTLIB",SQ."POSTE",SQ."POSTELIB",
       (NVL(TO_CHAR(ID),'') || ' | ' || NVL(TO_CHAR(IDRESSPARFAB),'') || ' | ' || NVL(TO_CHAR(HEURENORMALE),'') || ' | ' || NVL(TO_CHAR(HS),'') || ' | ' || NVL(TO_CHAR(MN),'') || ' | ' || NVL(TO_CHAR(JF),'') || ' | ' || NVL(TO_CHAR(HD),'') || ' | ' || NVL(TO_CHAR(IF),'') || ' | ' || NVL(TO_CHAR(ETAT),'') || ' | ' || NVL(TO_CHAR(REMARQUE),'') || ' | ' || NVL(TO_CHAR(IDPERSONNE),'') || ' | ' || NVL(TO_CHAR(IDFABRICATION),'') || ' | ' || NVL(TO_CHAR(DATEFABRICATION,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(ETATLIB),'') || ' | ' || NVL(TO_CHAR(IDPERSONNELIB),'') || ' | ' || NVL(TO_CHAR(MATRICULE),'') || ' | ' || NVL(TO_CHAR(TAUXHORAIRE),'') || ' | ' || NVL(TO_CHAR(TAUXHORAIREEFFECTIVE),'') || ' | ' || NVL(TO_CHAR(TEMPORAIRE),'') || ' | ' || NVL(TO_CHAR(MONTANT),'') || ' | ' || NVL(TO_CHAR(IDQUALIFICATION),'') || ' | ' || NVL(TO_CHAR(MONTANTJF),'') || ' | ' || NVL(TO_CHAR(MONTANTHD),'') || ' | ' || NVL(TO_CHAR(MONTANTIF),'') || ' | ' || NVL(TO_CHAR(MONTANTMN),'') || ' | ' || NVL(TO_CHAR(MONTANTHN),'') || ' | ' || NVL(TO_CHAR(IDDEPARTEMENT),'') || ' | ' || NVL(TO_CHAR(DEPARTEMENTLIB),'') || ' | ' || NVL(TO_CHAR(POSTE),'') || ' | ' || NVL(TO_CHAR(POSTELIB),'')) AS MOTSCLESSS
FROM (
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
             pf.val as PosteLib
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
                  LEFT JOIN PAIE_FONCTION pf on pf.id = h.poste
     ) SQ;