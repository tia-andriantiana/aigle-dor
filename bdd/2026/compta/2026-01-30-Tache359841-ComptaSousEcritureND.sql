-- Antema
CREATE OR REPLACE VIEW ComptaSousEcritureND AS
SELECT cse.*
FROM COMPTA_SOUS_ECRITURE cse
         LEFT JOIN SOUSECRITUREDECLARER csed
                   ON cse.id = csed.idSousEcriture
WHERE csed.idSousEcriture IS NOT NULL;