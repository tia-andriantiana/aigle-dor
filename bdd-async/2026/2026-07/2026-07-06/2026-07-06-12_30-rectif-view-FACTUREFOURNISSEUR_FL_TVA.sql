create or replace view FACTUREFOURNISSEUR_FL_TVA (COMPTE, IDFACTUREFOURNISSEUR, MONTANTHT, IDDEVISE, TAUXDECHANGE) as
SELECT
    nvl(ai.compte_tva, '445600') AS compte,
    ff.idfacturefournisseur,
    cast(sum(ff.pu * ff.QTE * (ff.tva / 100)) as number(30, 2))              as montanttva,
    ff.iddevise,
    ff.tauxdechange
FROM FACTUREFOURNISSEUR_FILLECPL ff
         LEFT JOIN AS_INGREDIENTS ai ON ai.id = ff.idproduit
GROUP BY ai.compte_tva, IDFACTUREFOURNISSEUR, iddevise, tauxdechange;