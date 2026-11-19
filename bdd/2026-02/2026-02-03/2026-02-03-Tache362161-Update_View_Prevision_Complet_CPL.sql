--Stefan
CREATE OR REPLACE VIEW PREVISION_COMPLET_CPL AS
SELECT
    p.ID,
    p.DESIGNATION,
    p.IDCAISSE,
    p.IDCAISSELIB,
    p.IDVENTEDETAIL,
    p.IDVENTE,
    p.IDVENTELIB,
    p.IDVIREMENT,
    p.DEBIT,
    p.CREDIT,
    p.DATY,
    p.ETAT,
    p.IDOP,
    p.IDOPLIB,
    p.IDORIGINE,
    p.IDDEVISE,
    p.IDDEVISELIB,
    p.TAUX,
    p.IDTIERS,
    p.COMPTE,
    NVL(pe.effectifDeb,0) AS effectifDebit,
    NVL(pe.effectifCred,0) AS effectifCredit,
    p.debit - NVL(pe.effectifDeb,0) AS depenseEcart,
    p.credit - NVL(pe.effectifCred,0) AS recetteEcart,
    COALESCE(v.id, f.id) AS idfacturemere
FROM PREVISION_CPL p
         LEFT JOIN PrevisionAvecMvtCaisse pe ON pe.id = p.id
         LEFT JOIN Vente v ON v.id = p.idfacture
         LEFT JOIN FactureFournisseur f ON f.id = p.idfacture;

