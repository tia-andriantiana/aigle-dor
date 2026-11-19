CREATE OR REPLACE VIEW INSPECTIONFILLELIB  AS 
  (
  SELECT
    ifi.id,
    ifi.idmere,
    ifi.idElement,
    eis.val     AS idElementlib,
    ifi.idEtatInspection,
    ifi.remarque,
    ei.val    AS idEtatInspectionlib,
    m.VAL AS idMachinelib,
    m.id AS idMachine
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


create or replace view inspectionFillecpl as 
select 
    ifl.id,
    ifl.idMere,
    ifl.idElement ,
    ifl.idEtatInspection,
    ifl.idEtatInspectionlib ,
    ifl.idElementLib,
    ifl.remarque,
    ifl.idMachineLib,
    ifl.idMachine,
    l.id AS idLigne,
    l.VAL AS idLigneLib
from inspectionFIlleLib ifl 
join inspectionMere im on ifl.idMere = im.id
join as_ingredient_Maintenance am on im.IDELEMENT = am.id
left join ligne l on am.IDLIGNE = l.id;

