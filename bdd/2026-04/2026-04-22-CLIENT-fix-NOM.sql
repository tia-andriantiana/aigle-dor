UPDATE CLIENT
SET NOM = TRIM(
        REPLACE(
            REGEXP_REPLACE(NOM, '  +', ' '),
            ' '' ',
            ''''
        )
    );
