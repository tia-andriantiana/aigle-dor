CREATE OR REPLACE VIEW mouvementcaisseautocomplete as
SELECT
    mc.ID,
    mc.DESIGNATION,
    mc.IDCAISSE,
    mc.IDVENTEDETAIL,
    mc.IDVIREMENT,
    mc.DATY,
    mc.ETAT,
    mc.IDOP,
    mc.IDORIGINE,
    mc.IDDEVISE,
    CASE
        WHEN mc.IDTIERS IS NOT NULL
            THEN mc.IDTIERS||'---'||c.nom
        END AS IDTIERS,
    mc.COMPTE,
    CASE
        WHEN mc.IDPREVISION IS NOT NULL
            THEN mc.IDPREVISION||'---'||p.designation
        END AS IDPREVISION,
    mc.IDTRAITE,
    mc.ETATVERSEMENT,
    mc.IDMODEPAIEMENT,
    mc.IDMVTCAISSEMERE,
    mc.REFERENCE,
    mc.UPDATED_AT,
    mc.DATYCOMPTABILISATION,
    mc.ACQUEREUR,
    mc.IDTYPEPAIEMENT,
    mc.DEBIT,
    mc.CREDIT,
    mc.TAUX,
    mc.HEURE
FROM mouvementcaisse mc
     LEFT JOIN CLIENT c ON c.id=mc.IDTIERS
     LEFT JOIN prevision p ON p.id=mc.IDPREVISION;

CREATE OR REPLACE  VIEW INVENTAIREFILLEUPDATE ("ID", "IDINVENTAIRE", "IDPRODUIT", "EXPLICATION", "IDJAUGE", "QUANTITETHEORIQUE", "QUANTITE", "MVTSRC", "PU", "IDFOURNISSEUR", "DATY") AS
SELECT
    inf.id,
    inf.idinventaire,
    CASE
        WHEN inf.idproduit IS NOT NULL
            THEN inf.idproduit||'---'||ai.libelle
        END AS idproduit,
    ai.LIBELLE ||' - '|| inf.explication AS explication,
    inf.idjauge,
    inf.quantitetheorique,
    inf.quantite,
    inf.mvtsrc,
    inf.pu,
    inf.idfournisseur,
    inf.daty
FROM inventairefille inf
         LEFT JOIN AS_INGREDIENTS ai ON ai.id=inf.idproduit;

CREATE OR REPLACE  VIEW INVENTAIREFILLEAUTOCOMPLETE ("ID", "IDINVENTAIRE", "IDPRODUIT", "EXPLICATION", "IDJAUGE", "QUANTITETHEORIQUE", "QUANTITE", "MVTSRC", "PU", "IDFOURNISSEUR", "DATY") AS
SELECT
    inf.id,
    inf.idinventaire,
    CASE
        WHEN inf.idproduit IS NOT NULL
            THEN inf.idproduit||'---'||ai.libelle
        END AS idproduit,
    inf.explication AS explication,
    inf.idjauge,
    inf.quantitetheorique,
    inf.quantite,
    inf.mvtsrc,
    inf.pu,
    inf.idfournisseur,
    inf.daty
FROM inventairefille inf
         LEFT JOIN AS_INGREDIENTS ai ON ai.id=inf.idproduit;