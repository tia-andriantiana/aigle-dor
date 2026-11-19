

CREATE OR REPLACE  VIEW "DMDACHATLIB_TRAITE" ("ID", "DATY", "FOURNISSEUR", "FOURNISSEURLIB", "REMARQUE", "DATELIMITE", "IDMAGASINLIB", "IDCATEGORIELIB", "ETAT", "ETATLIB", "IDOBJET", "IDSERVICELIB", "IDTRAITE", "TRAITE", "IDPROVENANCE", "IDPROVENANCELIB") AS 
  SELECT
    d.ID,
    d.DATY,
    d.FOURNISSEUR,
    d.FOURNISSEURLIB,
    d.REMARQUE,
    d.DATELIMITE,
    d.IDMAGASINLIB,
    d.IDCATEGORIELIB,
    d.ETAT,
    d.ETATLIB,
    d.IDOBJET,
    d.IDSERVICELIB,
    CASE
        WHEN suivi.totalCommande = 0 THEN '0'
        WHEN suivi.totalReste = 0 THEN '2'
        WHEN suivi.totalReste > 0 AND suivi.totalCommande > 0 THEN '1'
        ELSE '3'
        END AS IDTRAITE,
    CASE
        WHEN suivi.totalCommande = 0 THEN 'Non Trait&eacute;'
        WHEN suivi.totalReste = 0 THEN 'Trait&eacute;'
        WHEN suivi.totalReste > 0 AND suivi.totalCommande > 0 THEN 'Trait&eacute; Partiellement'
        ELSE 'Trait&eacute; avec surplus'
        END AS TRAITE,
    d.idProvenance,
    d.IDPROVENANCELIB
FROM DMDACHATLIB d
LEFT JOIN DMDACHATSUIVICOMMANDEGROUPEE suivi ON d.id = suivi.iddmdachat;