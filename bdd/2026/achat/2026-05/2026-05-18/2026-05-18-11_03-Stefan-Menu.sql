-- Stefan

UPDATE MENUDYNAMIQUE
SET LIBELLE='Facture', ICONE='receipt_long', HREF='module.jsp?but=facturefournisseur/facturefournisseur-liste.jsp', RANG=3, NIVEAU=2, ID_PERE='MNDN000000002'
WHERE ID='MNDN000000013';

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDN000000014PROF', 'Proforma', 'description', 'module.jsp?but=facturefournisseur/proforma-saisie.jsp', 2, 2, 'MNDN000000002');

CREATE OR REPLACE VIEW DMDACHATSUIVICOMMANDEGROUPEE AS
SELECT d.IDDMDACHAT, sum (d.QUANTITEDEJACOMMANDE ) AS totalCommande , sum (d.RESTEACOMMANDER ) AS totalReste FROM DMDACHATSUIVICOMMANDE d GROUP BY d.IDDMDACHAT ;

CREATE OR REPLACE VIEW DMDACHATLIB AS
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
    pr.val AS idProvenanceLib
FROM DMDACHAT da
         LEFT JOIN FOURNISSEUR f ON f.ID = da.fournisseur
         LEFT JOIN MAGASIN2 m ON da.idMagasin = m.ID
         LEFT JOIN categorieIngredient ci ON da.idCategorie = ci.id
         LEFT JOIN SERVICE s ON da.SERVICE = s.COMPTE
         LEFT JOIN provenance pr ON da.idProvenance=pr.id
;

CREATE OR REPLACE VIEW DMDACHATLIB_TRAITE AS
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
        ELSE '0'
        END AS IDTRAITE,
    CASE
        WHEN suivi.totalCommande = 0 THEN 'Non Trait&eacute;'
        WHEN suivi.totalReste = 0 THEN 'Trait&eacute;'
        WHEN suivi.totalReste > 0 AND suivi.totalCommande > 0 THEN 'Trait&eacute; Partiellement'
        ELSE 'Non Trait&eacute;'
        END AS TRAITE,
    d.idProvenance,
    d.IDPROVENANCELIB
FROM DMDACHATLIB d
         LEFT JOIN DMDACHATSUIVICOMMANDEGROUPEE suivi ON d.id = suivi.iddmdachat;