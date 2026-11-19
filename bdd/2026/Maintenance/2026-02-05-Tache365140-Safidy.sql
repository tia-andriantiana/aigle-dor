CREATE OR REPLACE  VIEW SOCOBISMAINTENANCE0203 as(
    SELECT
        eim.id,
        eim.idElementInspection as idElementInspection,
        eim.idMachine as idMachine,
        ei.val      AS idElementInspectionLib,
        m.libelle       AS idMachineLib
    FROM ElementInspectionMachine eim
             LEFT JOIN ElementInspection ei
                       ON eim.idElementInspection = ei.id
             LEFT JOIN AS_INGREDIENT_MAINTENANCE  m
                       ON eim.idMachine = m.id
);