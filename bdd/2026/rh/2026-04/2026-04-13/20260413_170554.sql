UPDATE PAIE_INFO_PERSONNEL
SET matricule = CASE
                    WHEN REGEXP_REPLACE(matricule, '^0+', '') IS NULL THEN '0'
                    ELSE REGEXP_REPLACE(matricule, '^0+', '')
    END;