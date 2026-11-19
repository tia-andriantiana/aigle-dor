
CREATE OR REPLACE  VIEW DMDACHATSUIVICOMMANDE
(
    PRODUIT,
    PRODUITDESIGNATION,
    IDDMDACHAT,
    QUANTITEDEMANDE,
    QUANTITEDEJACOMMANDE,
    RESTEACOMMANDER
) AS
SELECT
    df.IDPRODUIT AS produit,
    df.DESIGNATION AS produitDesignation,
    df.IDMERE AS idDmdAchat,
    df.QUANTITE AS quantiteDemande,
    NVL(bcf_sum.quantiteCommande, 0) AS quantiteDejaCommande,
    df.QUANTITE - NVL(bcf_sum.quantiteCommande, 0) AS resteACommander
FROM DMDACHATFILLE df
LEFT JOIN DMDACHAT d
    ON d.ID = df.IDMERE
LEFT JOIN (
    SELECT
        bc.IDDMDACHAT,
        bcf.PRODUIT,
        SUM(bcf.QUANTITE) AS quantiteCommande
    FROM AS_BONDECOMMANDE bc
    INNER JOIN AS_BONDECOMMANDE_FILLE bcf
        ON bcf.IDBC = bc.ID
    WHERE bc.IDDMDACHAT IS NOT NULL
      AND bcf.PRODUIT IS NOT NULL
      AND bc.ETAT <> 0
    GROUP BY bc.IDDMDACHAT, bcf.PRODUIT
) bcf_sum
    ON bcf_sum.IDDMDACHAT = df.IDMERE
   AND bcf_sum.PRODUIT = df.IDPRODUIT;