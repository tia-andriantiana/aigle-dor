CREATE VIEW LIAISONCODELib AS
SELECT
    id,
    idCodeImpot,
    idCompte,
    FORMULE,
    CASE
        WHEN TAXABLE = 1 THEN 'Oui'
        WHEN TAXABLE = 0 THEN 'Non'
        ELSE NULL
        END AS TAXABLE
FROM LiaisonCodeImpot;
