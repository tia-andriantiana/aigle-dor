CREATE OR REPLACE VIEW FACTUREFOURNISSEUR_PERTE  AS
SELECT f.ID,
       f.IDFOURNISSEUR,
       f.IDMODEPAIEMENT,
       f.DATY,
       f.DESIGNATION,
       f.DATEECHEANCEPAIEMENT,
       f.ETAT,
       f.REFERENCE,
       f.IDBC,
       f.DEVISE,
       f.TAUX,
       f.IDMAGASIN,
       f.IDDEVISE,
       f.ESTPREVU,
       f.DATYPREVU,
       cast (nvl(p.MONTANTAR, 0) as number(30,2)) AS MONTANTPERTEGAIN,
       f.numero ,
       f.TYPEACHAT ,
       f.IDTYPEFACTURE ,
       f.IDOBJET ,
       f.IDREF ,
       f.IDDMDACHAT ,
       f.IDFACTUREPRINCIPALE ,
       f.SERVICE ,
       f.TYPEFACTUREFOURNISSEUR
FROM FACTUREFOURNISSEUR f
         left JOIN perte_grporigine_fact p ON p.idorigine = f.id

;