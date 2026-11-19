UPDATE PREVISION
SET DESIGNATION = REPLACE(
        REPLACE(
                REPLACE(DESIGNATION, 'rattachÃ©e', 'rattachée'),
                'PrÃ©vision', 'Prévision'
        ),
        'Ã©', 'é'
                  )
WHERE DESIGNATION LIKE '%Ã©%';

UPDATE PREVISION
SET DESIGNATION = REPLACE(DESIGNATION, 'Prevision', 'Prévision')
WHERE DESIGNATION LIKE '%Prevision%';
