CREATE OR REPLACE  VIEW DMDACHATLIB ("ID", "DATY", "FOURNISSEUR", "FOURNISSEURLIB", "REMARQUE", "DATELIMITE", "IDMAGASINLIB", "IDCATEGORIELIB", "ETAT", "ETATLIB", "IDOBJET", "IDSERVICELIB", "IDPROVENANCE", "IDPROVENANCELIB", "REFPROFORMA") AS
SELECT
    da.id,
    da.daty,
    da.fournisseur,
    f.nom AS fournisseurlib,
    da.remarque,
    da.dateLimite,
    m.val AS idMagasinLib,
    ci.val AS idCategorieLib,
    da.etat,
    CASE
        WHEN da.ETAT = 0
            THEN 'ANNUL&Eacute;E'
        WHEN da.ETAT = 1
            THEN 'CR&Eacute;&Eacute;E'
        WHEN da.ETAT = 11
            THEN 'VIS&Eacute;(E) par Contr&ocirc;le'
        WHEN da.ETAT = 3
            THEN 'VIS&Eacute;(E) par Chef de Fabrication'
        WHEN da.ETAT = 4
            THEN 'VIS&Eacute;(E) par Le Directeur'
        END AS etatlib,
    da.idObjet,
    s.libelle AS idServiceLib,
    da.idProvenance,
    pr.val AS idProvenanceLib,
    bc.refproforma AS refproforma
FROM DMDACHAT da
         LEFT JOIN FOURNISSEUR f ON f.ID = da.fournisseur
         LEFT JOIN MAGASIN2 m ON da.idMagasin = m.ID
         LEFT JOIN categorieIngredient ci ON da.idCategorie = ci.id
         LEFT JOIN SERVICE s ON da.SERVICE = s.COMPTE
         LEFT JOIN provenance pr ON da.idProvenance=pr.id
         LEFT JOIN AS_BONDECOMMANDE bc ON da.id=bc.IDDMDACHAT;