INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENDYNA17645720669432722', 'Inspections Filles', 'list_alt', 'module.jsp?but=inspection/inspectionFille-liste.jsp', 7, 3, 'MNDNMT0134256');

CREATE OR REPLACE  VIEW INSPECTIONFILLELIB as (
  SELECT
    ifi.id,
    ifi.idmere,
    ifi.idElement,
    eis.val     AS idElementlib,
    ifi.idEtatInspection,
    ifi.remarque,
    ei.val    AS idEtatInspectionlib,
    m.libelle AS idMachinelib,
    m.id AS idMachine
FROM InspectionFille ifi
        LEFT JOIN ElementInspection eis
                   ON ifi.idElement = eis.id
        LEFT JOIN ElementInspectionMachine ai
                   ON ai.idelementinspection = ifi.idelement
        LEFT JOIN AS_INGREDIENT_MAINTENANCE m
                   ON ai.idMachine = m.id
        LEFT JOIN EtatInspection ei
                   ON ifi.idEtatInspection = ei.id);