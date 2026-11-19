UPDATE AS_BONDECOMMANDE
SET DESIGNATION = 'Bon de commande de la demande ' || REPLACE(DESIGNATION, 'Facture de la demande d''achat ', '')
WHERE DESIGNATION LIKE '%Facture de la demande%';

CREATE OR REPLACE VIEW DMDACHATLIB_TRAITE AS
SELECT
    d.ID,
    bc.DESIGNATION,
    bc.id AS idbc,
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
        WHEN bc.ID IS NULL THEN '0'
        WHEN suivi.totalReste = 0 THEN '2'
        WHEN suivi.totalReste > 0 AND suivi.totalCommande > 0 THEN '1'
        ELSE '0'
        END AS IDTRAITE,
    CASE
        WHEN bc.ID IS NULL THEN 'Non Trait&eacute;'
        WHEN suivi.totalReste = 0 THEN 'Trait&eacute;'
        WHEN suivi.totalReste > 0 AND suivi.totalCommande > 0 THEN 'Trait&eacute; Partiellement'
        ELSE 'Non Trait&eacute;'
        END AS TRAITE,
    d.idProvenance,
    d.IDPROVENANCELIB,
    d.refproforma
FROM DMDACHATLIB d
         LEFT JOIN AS_BONDECOMMANDE_MERECPL bc ON bc.idDmdAchat = d.ID
         LEFT JOIN (
    SELECT
        df.IDMERE,
        SUM(df.QUANTITE) AS totalDemande,
        SUM(NVL(bcf.qteCommande, 0)) AS totalCommande,
        SUM(df.QUANTITE - NVL(bcf.qteCommande, 0)) AS totalReste
    FROM DMDACHATFILLE df
             LEFT JOIN (
        SELECT
            bcf.PRODUIT,
            bc.IDDMDACHAT,
            SUM(bcf.QUANTITE) AS qteCommande
        FROM AS_BONDECOMMANDE_FILLE bcf
                 JOIN AS_BONDECOMMANDE bc ON bc.ID = bcf.IDBC
        GROUP BY bcf.PRODUIT, bc.IDDMDACHAT
    ) bcf ON bcf.IDDMDACHAT = df.IDMERE AND bcf.PRODUIT = df.IDPRODUIT
    GROUP BY df.IDMERE
) suivi ON suivi.IDMERE = d.ID;

CREATE OR REPLACE VIEW DMDACHATSUIVICOMMANDE AS
SELECT
    df.IDPRODUIT AS produit,
    df.DESIGNATION AS produitDesignation,
    df.IDMERE AS idDmdAchat,
    df.QUANTITE AS quantiteDemande,
    NVL(bcf_sum.quantiteCommande, 0) AS quantiteDejaCommande,
    df.QUANTITE - NVL(bcf_sum.quantiteCommande, 0) AS resteACommander
FROM DMDACHATFILLE df
         LEFT JOIN DMDACHAT d ON d.ID = df.IDMERE
         LEFT JOIN (
    SELECT
        bc.IDDMDACHAT,
        bcf.PRODUIT,
        SUM(bcf.QUANTITE) AS quantiteCommande
    FROM AS_BONDECOMMANDE bc
             INNER JOIN AS_BONDECOMMANDE_FILLE bcf ON bcf.IDBC = bc.ID
    WHERE bc.IDDMDACHAT IS NOT NULL
      AND bcf.PRODUIT IS NOT NULL
    GROUP BY bc.IDDMDACHAT, bcf.PRODUIT
) bcf_sum ON bcf_sum.IDDMDACHAT = df.IDMERE
    AND bcf_sum.PRODUIT = df.IDPRODUIT;