CREATE OR REPLACE  VIEW PLANNING_CPL AS
SELECT
    p.ID,
    p.REFOBJET,
    p.ESTPERIODIQUE,
    p.IDTYPEMAINTENANCE,
    p.IDMACHINE,
    p.UNITE,
    p.FREQUENCE,
    p.DATEDEBUT,
    p.DATEFIN,
    p.DUREE,
    p.ETAT,
    p.HEURE,
    p.IDSOURCE,
    ai.LIBELLE AS idMachineLib,
    t.VAL AS idTypeMaintenanceLib,
    CASE
        WHEN p.ESTPERIODIQUE = 1 THEN 'OUI'
        ELSE 'NON'
        END estPeriodiqueLib,
    CASE
        WHEN p.ETAT = 11 THEN 'VALID&Eacute;E'
        ELSE 'CR&Eacute;E'
        END etatLib,
    u.VAL AS uniteLib,
    d.priorite,
    d.prioritelib,
    d.id AS iddemandetravaux,
    o.id AS idordretravaux,
    otf.id AS idordretravauxfille,
    tr.id AS idtravaux,
    e.id AS identite,
    e.val AS identitelib,
    d.etat AS etatdemandetravaux,
    o.etat AS etatordretravaux,
    tr.etat AS etattravaux,
    CASE d.etat
        WHEN 1  THEN 'Créée'
        WHEN 11 THEN 'Visée'
        ELSE 'Aucun'
        END AS etatdemandetravauxlib,
    CASE o.etat
        WHEN 1  THEN 'Créée'
        WHEN 11 THEN 'Visée'
        ELSE 'Aucun'
        END AS etatordretravauxlib,
    CASE tr.etat
        WHEN 1  THEN 'Créée'
        WHEN 11 THEN 'Visée'
        WHEN 21 THEN 'Entamée'
        WHEN 41 THEN 'Terminée'
        ELSE 'Aucun'
        END AS etatTravauxLib,
    coalesce(SUM(fff.pu * fff.qte), 0) AS cout
FROM PLANNING p
         LEFT JOIN AS_INGREDIENT_MAINTENANCE aim ON aim.ID = p.IDMACHINE
         LEFT JOIN AS_INGREDIENTS ai ON ai.id = aim.IDINGREDIENT
         LEFT JOIN TYPEMAINTENANCE t ON t.ID = p.IDTYPEMAINTENANCE
         LEFT JOIN UNITEMAINTENANCE u ON u.ID = p.UNITE
         LEFT JOIN DEMANDETRAVAUX_CPL d ON d.ID = p.IDSOURCE
         LEFT JOIN ORDRETRAVAUX o ON o.IDBC = d.ID
         LEFT JOIN ORDRETRAVAUXFILLE otf ON otf.IDMERE = o.ID
         LEFT JOIN TRAVAUX tr ON tr.IDOFFILLE = otf.id
         LEFT JOIN TRAVAUXFILLE trf ON trf.IDMERE = tr.ID
         LEFT JOIN ENTITE e ON e.id = aim.IDENTITE
         LEFT JOIN FACTUREFOURNISSEUR f ON f.IDREF = tr.id
         LEFT JOIN FACTUREFOURNISSEURFILLE fff ON fff.IDFACTUREFOURNISSEUR = f.ID
GROUP BY
    p.ID, p.REFOBJET, p.ESTPERIODIQUE, p.IDTYPEMAINTENANCE, p.IDMACHINE, p.UNITE,
    p.FREQUENCE, p.DATEDEBUT, p.DATEFIN, p.DUREE, p.ETAT, p.HEURE, p.IDSOURCE,
    ai.LIBELLE, t.VAL, u.VAL,
    d.priorite, d.prioritelib, d.id, d.etat,
    o.id, o.etat,
    otf.id,
    tr.id, tr.etat,
    e.id, e.val;