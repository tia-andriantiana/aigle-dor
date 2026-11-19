CREATE or replace VIEW COMPARAISONPRIXFACTBC AS
SELECT
    f.idFactureFournisseur as id,
    f.idProduit,
    f.idProduitLib,
    f.idFactureFournisseur,
    f.pu          AS puFact,
    ASB.pu        AS puBc,
    f.pu - ASB.pu AS ecart
FROM FACTUREFOURNISSEURFILLECPL f

         LEFT JOIN FACTUREFOURNISSEUR ff
                   ON ff.ID = f.IDFACTUREFOURNISSEUR

         LEFT JOIN AS_BONDECOMMANDE_CPL ASB
                   ON ASB.IDBC = ff.IDBC

WHERE ff.IDBC IS NOT NULL;
