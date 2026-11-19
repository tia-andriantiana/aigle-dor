create or replace view PREVISIONGROUPE as
SELECT
    COALESCE(v.id, ff.idFactureFournisseur) AS idFacture,
    CASE
        WHEN v.id IS NOT NULL
            THEN 'vente/vente-fiche.jsp&id=' || v.id
        WHEN ff.idFactureFournisseur IS NOT NULL
            THEN 'facturefournisseur/facturefournisseur-fiche.jsp&id=' || ff.idFactureFournisseur
        ELSE NULL
        END AS reference,
    p.daty,
    SUM(p.debit)  AS debit,
    SUM(p.credit) AS credit

FROM prevision p

         LEFT JOIN vente v
                   ON v.id = p.idfacture

         LEFT JOIN facturefournisseurfille ff
                   ON ff.idFactureFournisseur = p.idfacture

GROUP BY
    v.id,
    ff.idFactureFournisseur,
    p.daty

/

