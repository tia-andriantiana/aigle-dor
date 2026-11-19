CREATE OR REPLACE  VIEW DEMANDETRAVAUX_CPL AS
   SELECT SQ."ID",SQ."IDENTITE",SQ."IDSITUATION",SQ."IDMACHINE",SQ."DATY",SQ."DATEBESOIN",SQ."PRIORITE",SQ."ESTEXISTANT",SQ."DESCRIPTION",SQ."ETAT",SQ."IDDEPARTEMENT",SQ."IDENTITELIB",SQ."IDSITUATIONLIB",SQ."IDMACHINELIB",SQ."ESTEXISTANTLIB",SQ."ETATLIB",SQ."IDDEPARTEMENTMAINTENANCE",SQ."IDDEPARTEMENTMAINTENANCELIB",SQ."PRIORITELIB",SQ."IDDEPARTEMENTLIB",SQ."IDOTFILLE",SQ."IDTYPEMAINTENANCE",SQ."IDTYPEMAINTENANCELIB",SQ."PERSONNELLIB",
       (NVL(TO_CHAR(ID),'') || ' | ' || NVL(TO_CHAR(IDENTITE),'') || ' | ' || NVL(TO_CHAR(IDSITUATION),'') || ' | ' || NVL(TO_CHAR(IDMACHINE),'') || ' | ' || NVL(TO_CHAR(DATY,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(DATEBESOIN,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(PRIORITE),'') || ' | ' || NVL(TO_CHAR(ESTEXISTANT),'') || ' | ' || NVL(TO_CHAR(DESCRIPTION),'') || ' | ' || NVL(TO_CHAR(ETAT),'') || ' | ' || NVL(TO_CHAR(IDDEPARTEMENT),'') || ' | ' || NVL(TO_CHAR(IDENTITELIB),'') || ' | ' || NVL(TO_CHAR(IDSITUATIONLIB),'') || ' | ' || NVL(TO_CHAR(IDMACHINELIB),'') || ' | ' || NVL(TO_CHAR(ESTEXISTANTLIB),'') || ' | ' || NVL(TO_CHAR(ETATLIB),'') || ' | ' || NVL(TO_CHAR(IDDEPARTEMENTMAINTENANCE),'') || ' | ' || NVL(TO_CHAR(IDDEPARTEMENTMAINTENANCELIB),'') || ' | ' || NVL(TO_CHAR(PRIORITELIB),'') || ' | ' || NVL(TO_CHAR(IDDEPARTEMENTLIB),'') || ' | ' || NVL(TO_CHAR(IDOTFILLE),'') || ' | ' || NVL(TO_CHAR(IDTYPEMAINTENANCE),'') || ' | ' || NVL(TO_CHAR(IDTYPEMAINTENANCELIB),'') || ' | ' || NVL(TO_CHAR(PERSONNELLIB),'')) AS MOTSCLESSS
FROM (
         SELECT
             dmd."ID", dmd."IDENTITE", dmd."IDSITUATION", dmd."IDMACHINE", dmd."DATY", dmd."DATEBESOIN", dmd."PRIORITE", dmd."ESTEXISTANT", dmd."DESCRIPTION", dmd."ETAT", dmd."IDDEPARTEMENT",
             e.VAL AS idEntiteLib,
             s.VAL AS idSituationLib,
             m.LIBELLE AS idMachineLib,
             CASE dmd.ESTEXISTANT
                 WHEN 0 THEN 'NON'
                 WHEN 1 THEN 'OUI'
                 ELSE 'Non spécifié'
                 END AS estExistantLib,
             CASE dmd.ETAT
                 WHEN 1 THEN 'CR&Eacute;&Eacute;E'
                 WHEN 11 THEN 'VALID&Eacute;E'
                 ELSE 'CR&Eacute;&Eacute;E'
                 END AS etatLib,
             d.id AS IDDEPARTEMENTMAINTENANCE,
             d.VAL AS IDDEPARTEMENTMAINTENANCELIB,
             pri.val AS prioritelib,
             departement.val AS IDDEPARTEMENTLIB,
             otf.ID AS idOtFille,
             pl.idtypemaintenance AS idtypemaintenance,
             tm.val AS idtypemaintenancelib,
             pers.NOM as personnelLib
         FROM DEMANDETRAVAUX dmd
                  LEFT JOIN ENTITE e ON e.ID = dmd.IDENTITE
                  LEFT JOIN SITUATION s ON s.ID = dmd.IDSITUATION
                  LEFT JOIN AS_INGREDIENT_MAINTENANCE m ON m.ID = dmd.IDMACHINE
                  LEFT JOIN DEPARTEMENTMAINTENANCE d ON d.ID = dmd.IDDEPARTEMENTMAINTENANCE
                  LEFT JOIN PRIORITE pri ON dmd.priorite = pri.ID
                  LEFT JOIN DEPARTEMENT departement ON departement.id = dmd.iddepartement
                  LEFT JOIN ORDRETRAVAUX o ON o.IDBC = dmd.ID
                  LEFT JOIN ORDRETRAVAUXFILLE otf ON otf.IDMERE = o.ID
                  LEFT JOIN PLANNING pl ON pl.id = dmd.idplanning
                  LEFT JOIN TYPEMAINTENANCE tm ON tm.id = pl.idtypemaintenance
                  LEFT JOIN PERSONNEL pers ON dmd.DEMANDEUR = pers.ID
     ) SQ;