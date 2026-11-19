CREATE OR REPLACE VIEW HistoriqueInspectionLib AS
SELECT
    hi.id,
    hi.daty,
    hi.heure,
    hi.idinspecteur,
    hi.idelement,
    hi.remarque,
    hi.etat,
    p.nom AS idInspecteurLib,
    aim.libelle AS idElementLib
FROM HISTORIQUEINSPECTIONMERE hi
         JOIN personnel p
              ON hi.idinspecteur = p.id
         JOIN as_ingredient_maintenance aim
              ON hi.idelement = aim.id;

CREATE OR REPLACE VIEW HistoriqueInspectionFilleLib AS
SELECT
    hif.id,
    hif.idmere,
    hif.idelement,
    hif.etatinspection,
    hif.remarque,
    eim.IDELEMENTINSPECTIONLIB AS idElementLib,
    ei.val  AS EtatInspectionLib
FROM historiqueinspectionfille hif
         JOIN ELEMENTINSPECTIONMACHINELIB eim
              ON hif.idelement = eim.id
         JOIN etatinspection ei
              ON hif.etatinspection = ei.id;

