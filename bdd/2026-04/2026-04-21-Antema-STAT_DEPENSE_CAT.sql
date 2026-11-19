create or replace view STAT_DEPENSE_CAT as
SELECT
    ffc.daty,
    ai.CATEGORIEINGREDIENT ,
    cat.val AS CATEGORIEINGREDIENTLIB,
    EXTRACT(MONTH FROM ffc.daty) as MOISINT,
    TRIM(TO_CHAR(ffc.daty, 'Month', 'NLS_DATE_LANGUAGE=FRENCH')) AS MOISSTRING,
    EXTRACT(YEAR FROM ffc.daty) as ANNEE,
    CAST(sum(ffc.montant) / 1000000 AS NUMERIC(30,2)) AS depense
FROM FACTUREFOURNISSEURFILLECPL  ffc
         JOIN FACTUREFOURNISSEUR fc on fc.id = ffc.idfacturefournisseur and etat >= 11
         JOIN AS_INGREDIENTS ai ON ffc.IDPRODUIT = ai.id
         LEFT JOIN CATEGORIEINGREDIENT cat ON ai.CATEGORIEINGREDIENT  = cat.id
GROUP BY
    ai.CATEGORIEINGREDIENT,
    ffc.daty,
    cat.val
ORDER BY ANNEE, MOISINT;
