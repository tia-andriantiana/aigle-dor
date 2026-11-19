CREATE OR REPLACE  VIEW INSPECTIONFILLELIB as(
  SELECT
        ifi.id,
        ifi.idmere,
        ifi.idElement,
        eis.val     AS idElementlib,
        ifi.idEtatInspection,
        ifi.remarque,
        ei.val    AS idEtatInspectionlib,
        m.VAL AS idMachinelib
FROM InspectionFille ifi
     LEFT JOIN ElementInspectionMachine ai
               ON ifi.idElement = ai.id
    LEFT JOIN ElementInspection eis
               ON ai.idElementInspection = eis.id
    LEFT JOIN MACHINE m
               ON ai.idMachine = m.id
     LEFT JOIN EtatInspection ei
               ON ifi.idEtatInspection = ei.id
 );

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENDYNA17645720669432721001', 'Element', 'list_alt', 'module.jsp?but=maintenance/elementInspection/elementInspection-liste.jsp', 7, 3, 'MNDNMT0134256');

ALTER TABLE SOCOBISMAINTENANCE0203.ELEMENTINSPECTIONMACHINE DROP CONSTRAINT FK_MACHINE;
alter table ELEMENTINSPECTIONMACHINE add foreign key (idmachine) references AS_INGREDIENT_MAINTENANCE(ID);

