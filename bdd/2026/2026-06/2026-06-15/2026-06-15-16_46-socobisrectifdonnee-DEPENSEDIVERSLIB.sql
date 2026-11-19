CREATE OR REPLACE VIEW DEPENSEDIVERSLIB AS
SELECT
    d.ID,d.DATY,d.FOURNISSEUR,d.REMARQUE,d.IDMODEPAIEMENT,d.COMPTECHEQUE,d.ACHETEUR,d.IDMAGASIN,d.IDCATEGORIE,d.ETAT,
    f.NOM AS fournisseurLib,
    m.VAL AS IDMODEPAIEMENTLIB,
    m2.val AS idMagasinLib,
    c.VAL AS idCategorieLib,
    CASE
        WHEN d.ETAT = 0
            THEN 'ANNUL&Eacute;E'
        WHEN d.ETAT = 1
            THEN 'CR&Eacute;&Eacute;E'
        WHEN d.ETAT = 3
            THEN 'VIS&Eacute;E par Chef de D&eacutepartement'
        WHEN d.ETAT = 4
            THEN 'VIS&Eacute;E par Directeur de D&eacutepartement'
        WHEN d.ETAT = 11
            THEN 'VIS&Eacute;E par Le Directeur'
        WHEN d.ETAT = 5
            THEN 'VIS&Eacute;E par Contr&ocirc;le'
        END AS etatlib,
    s.LIBELLE AS serviceLib,
    sec.VAL AS idSectionLib,
    d.service,
    d.idSection,
    (SELECT NVL(SUM(NVL(df.QUANTITE, 0) * NVL(df.PU, 0)), 0)
        FROM DEPENSEDIVERSFILLE df
        WHERE df.IDMERE = d.ID
    ) AS montantTotal,
    (SELECT NVL(SUM(NVL(mc.DEBIT, 0)), 0)
        FROM MOUVEMENTCAISSE mc
        WHERE mc.IDORIGINE = d.ID
           OR mc.IDORIGINE IN (
            SELECT b.IDFACTUREFOURNISSEUR
            FROM AS_BONDELIVRAISON b
            WHERE b.IDDEPENSEDIVERS = d.ID
        )
    ) - (
        SELECT NVL(SUM(NVL(df.QUANTITE, 0) * NVL(df.PU, 0)), 0)
        FROM DEPENSEDIVERSFILLE df
        WHERE df.IDMERE = d.ID
    ) AS surplusTotal,
    (SELECT NVL(SUM(NVL(mc.CREDIT, 0)), 0)
        FROM MOUVEMENTCAISSE mc
        WHERE mc.IDORIGINE = d.ID
           OR mc.IDORIGINE IN (
            SELECT b.IDFACTUREFOURNISSEUR
            FROM AS_BONDELIVRAISON b
            WHERE b.IDDEPENSEDIVERS = d.ID
        )
    ) AS renduTotal
FROM DEPENSEDIVERS d
LEFT JOIN FOURNISSEUR f ON d.FOURNISSEUR = f.ID
LEFT JOIN MODEPAIEMENT m ON d.IDMODEPAIEMENT = m.ID
LEFT JOIN MAGASIN2 m2 ON d.IDMAGASIN = m2.ID
LEFT JOIN CATEGORIEINGREDIENT c ON d.IDCATEGORIE     = c.ID
LEFT JOIN SERVICE s ON s.COMPTE = d.SERVICE
LEFT JOIN SECTION sec ON sec.ID = d.IDSECTION;
