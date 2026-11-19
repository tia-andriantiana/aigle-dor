select             "daty",
--                    "numeroProforma",
                   "designation",
                   "idclientlib",
                   "idcommande",
                   "reference",
                   "idmagasinlib",
                   "modelivraisonlib",
                   "datelivraison",
                   "lieulivraison",
                   "montant",
                   "montanttotal",
                   "montantremise",
                   "montantristourne",
                   "montanttva",
                   "montantttc",
                   "montantttcar",
                   "etatlib",
                   "remarque" from PROFORMA_CPL;

ALTER TABLE bondecommande_client_fille
    ADD COLUMN tauxdechange NUMERIC(30, 2);

CREATE OR REPLACE VIEW bcclientfillecalc AS
SELECT
    bcf.id,
    bcf.produit,
    bcf.idbc,
    bcf.quantite,
    bcf.pu,
    bcf.montant,
    bcf.tva,
    bcf.remise,
    bcf.iddevise,
    bcf.unite,
    bcf.designation,
    bcf.ristourne,
    bcf.tauxdechange,
    CAST(bcf.pu * bcf.quantite * (1 - COALESCE(bcf.remise / 100.0, 0)) AS NUMERIC(30, 2)) AS montantht,
    CAST(bcf.pu * bcf.quantite * COALESCE(bcf.remise / 100.0, 0) AS NUMERIC(30, 2)) AS montantremise,
    CAST(bcf.pu * bcf.quantite * (1 - COALESCE(bcf.remise / 100.0, 0)) AS NUMERIC(30, 2)) AS montanthtavecremise,
    CAST(bcf.pu * bcf.quantite * (1 - COALESCE(bcf.remise / 100.0, 0)) * COALESCE(bcf.tva / 100.0, 0) AS NUMERIC(30, 2)) AS montanttva,
    CAST(bcf.pu * bcf.quantite * (1 - COALESCE(bcf.remise / 100.0, 0)) * (1 + COALESCE(bcf.tva / 100.0, 0)) AS NUMERIC(30, 2)) AS montantttc,
    CAST(bcf.pu * bcf.quantite * (1 - COALESCE(bcf.remise / 100.0, 0)) * (1 + COALESCE(bcf.tva / 100.0, 0)) * COALESCE(bcf.tauxdechange, 1) AS NUMERIC(30, 2)) AS montantttcar
FROM bondecommande_client_fille bcf;

CREATE OR REPLACE VIEW bcclientfille_grpmontant AS
SELECT
    abf.idbc,
    CAST(COALESCE(SUM(abf.montantht), 0) AS NUMERIC(30, 2)) AS montantht,
    CAST(COALESCE(SUM(abf.montanttva), 0) AS NUMERIC(30, 2)) AS montanttva,
    CAST(COALESCE(SUM(abf.montantremise), 0) AS NUMERIC(30, 2)) AS montantremise,
    CAST(COALESCE(SUM(abf.montanthtavecremise), 0) AS NUMERIC(30, 2)) AS montanthtavecremise,
    CAST(COALESCE(SUM(abf.montantttc), 0) AS NUMERIC(30, 2)) AS montantttc,
    CAST(COALESCE(SUM(abf.montantttcar), 0) AS NUMERIC(30, 2)) AS montantttcar,
    abf.tauxdechange
FROM bcclientfillecalc abf
GROUP BY abf.idbc, abf.tauxdechange;


ALTER VIEW bondecommande_client_cpl_m
    OWNER TO postgres;

