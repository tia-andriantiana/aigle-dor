CREATE OR REPLACE TRIGGER TRG_PLANNING_PERIODIQUE
    BEFORE INSERT OR UPDATE OF FREQUENCE ON PLANNING
    FOR EACH ROW
BEGIN
    IF :NEW.FREQUENCE IS NOT NULL AND :NEW.FREQUENCE <> 0 THEN
        :NEW.ESTPERIODIQUE := 1;
ELSE
        :NEW.ESTPERIODIQUE := 0;
END IF;
END;



create or replace view ELEMENTINSPECTIONMACHINELIB as
SELECT SQ."ID",SQ."IDELEMENTINSPECTION",SQ."IDMACHINE",SQ."IDELEMENTINSPECTIONLIB",SQ."IDMACHINELIB",
       (NVL(TO_CHAR(ID),'') || ' | ' || NVL(TO_CHAR(IDELEMENTINSPECTION),'') || ' | ' || NVL(TO_CHAR(IDMACHINE),'') || ' | ' || NVL(TO_CHAR(IDELEMENTINSPECTIONLIB),'') || ' | ' || NVL(TO_CHAR(IDMACHINELIB),'')) AS MOTSCLESSS
FROM (
         SELECT
             eim.id,
             eim.idElementInspection as idElementInspection,
             eim.idMachine as idMachine,
             ei.val      AS idElementInspectionLib,
             m.DESCRIPTIONOBJET       AS idMachineLib
         FROM ElementInspectionMachine eim
                  LEFT JOIN ElementInspection ei
                            ON eim.idElementInspection = ei.id
                  LEFT JOIN AS_INGREDIENT_MAINTENANCE m
                            ON eim.idMachine = m.id

     ) SQ;

create or replace view RAPPROCHEMENTTRAVAUX as
SELECT SQ."ID",SQ."IDTRAVAUX",SQ."IDPERSONNEL",SQ."IDPERSONNELLIB",SQ."DUREEESTIMATIF_HMS",SQ."DUREEREEL_HMS",SQ."ECART_HMS",SQ."DUREEESTIMATIF_SECONDE",SQ."DUREEREEL_SECONDE",SQ."ECART_SECONDE",SQ."MONTANTESTIMATIF",SQ."MONTANTREEL",SQ."MONTANTECART",
       (NVL(TO_CHAR(ID),'') || ' | ' || NVL(TO_CHAR(IDTRAVAUX),'') || ' | ' || NVL(TO_CHAR(IDPERSONNEL),'') || ' | ' || NVL(TO_CHAR(IDPERSONNELLIB),'') || ' | ' || NVL(TO_CHAR(DUREEESTIMATIF_HMS),'') || ' | ' || NVL(TO_CHAR(DUREEREEL_HMS),'') || ' | ' || NVL(TO_CHAR(ECART_HMS),'') || ' | ' || NVL(TO_CHAR(DUREEESTIMATIF_SECONDE),'') || ' | ' || NVL(TO_CHAR(DUREEREEL_SECONDE),'') || ' | ' || NVL(TO_CHAR(ECART_SECONDE),'') || ' | ' || NVL(TO_CHAR(MONTANTESTIMATIF),'') || ' | ' || NVL(TO_CHAR(MONTANTREEL),'') || ' | ' || NVL(TO_CHAR(MONTANTECART),'')) AS MOTSCLESSS
FROM (
         SELECT
             '' AS ID,
             mo.IDTRAVAUX,
             mo.IDPERSONNEL,
             mo.idPersonnelLib,
             mo.dureeEstimatifLib AS dureeEstimatif_hms,
             pr.dureeReelHMS AS dureeReel_hms,
             -- Ecart HMS calculé avec ABS pour éviter le signe "-"
             LPAD(FLOOR(ABS(TO_NUMBER(mo.DUREEESTIMATIF - pr.dureeReel)) / 3600), 2, '0') || ':' ||
             LPAD(FLOOR(MOD(ABS(TO_NUMBER(mo.DUREEESTIMATIF - pr.dureeReel)), 3600) / 60), 2, '0') || ':' ||
             LPAD(MOD(ABS(TO_NUMBER(mo.DUREEESTIMATIF - pr.dureeReel)), 60), 2, '0')
                 AS ecart_hms,
             mo.DUREEESTIMATIF AS dureeEstimatif_seconde,
             pr.dureeReel AS dureeReel_seconde,
             -- Ecart Seconde en valeur absolue
             ABS(mo.DUREEESTIMATIF - pr.dureeReel) AS ecart_seconde,
             mo.montant AS montantEstimatif,
             ((pr.dureeReel/60)/60)*mo.TAUXHORAIRE AS montantReel,
             -- Ecart Montant en valeur absolue
             ABS(mo.montant - (((pr.dureeReel/60)/60)*mo.TAUXHORAIRE)) AS montantEcart
         FROM MOTRAVAUXLIB mo
                  LEFT JOIN ProcessMaintenanceGlobal pr ON pr.IDPERSONNEL = mo.IDPERSONNEL AND pr.IDTRAVAUX = mo.IDTRAVAUX
     ) SQ;