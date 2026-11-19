CREATE OR REPLACE VIEW V_ARRETTRAVAIL_LIB AS
SELECT
    at.id,
    at.DATY,
    at.DATE_FIN_ARRET,
    at.DATE_DEBUT_ARRET,
    at.ID_ACCIDENT,
    at.NOMBRE_JOUR,
    acc.id_personnel_lib as nomPersonnel,
    acc.MATRICULE,
    acc.DATY as dateAccident,
    acc.ID_PERSONNEL
FROM ARRET_TRAVAIL at
        left join V_ACCIDENT_LIB acc ON acc.id = at.ID_ACCIDENT