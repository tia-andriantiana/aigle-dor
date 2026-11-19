
create or replace view as_bondelivraison_client_cpl
            (id, remarque, idvente, designation, idbc, daty, etat, idmagasin, magasin, idreservation, idclientlib,
             vehicule, chauffeur, description, idclient)
as
SELECT bl.id,
       bl.remarque,
       v.id  AS idvente,
       v.designation,
       bl.idbc,
       bl.daty,
       bl.etat,
       m.id  AS idmagasin,
       m.val AS magasin,
       v.idreservation,
       c.nom AS idclientlib,
       bl.vehicule,
       bl.chauffeur,
       bl.description,
       c.id  AS idclient,
       CASE
           WHEN bl.etat = 1::numeric THEN 'cr&eacute;&eacute;e'::text
           WHEN bl.etat = 11::numeric THEN 'vis&eacute;e'::text
           WHEN bl.etat = 0::numeric THEN 'annul&eacute;e'::text
           ELSE NULL::text
END                                                                                            AS etatlib
FROM as_bondelivraison_client bl
         LEFT JOIN magasinpoint m ON bl.magasin::text = m.id::text
         LEFT JOIN vente v ON v.id::text = bl.idvente::text
         LEFT JOIN client c ON c.id::text = bl.idclient::text;

alter table as_bondelivraison_client_cpl
    owner to postgres;

CREATE OR REPLACE VIEW bl_client_fille_grp_bc (idbc_fille, quantite) AS
SELECT
    abcf.idbc_fille,
    SUM(abcf.quantite) AS quantite
FROM as_bondelivraison_client_fille abcf
         LEFT JOIN bondecommande_client b
                   ON b.id = abcf.numbl
         LEFT JOIN as_bondelivraison_client abc
                   ON abc.id = abcf.numbl
WHERE abc.etat >= 11
GROUP BY abcf.idbc_fille;

ALTER TABLE bl_client_fille_grp_bc
    OWNER TO postgres;

CREATE OR REPLACE VIEW as_bondelivraison_client_cpl2 AS
SELECT
    bl.id,
    bl.remarque,
    COALESCE(v.id, bl.idvente) AS idvente,
    v.designation,
    bl.idbc,
    bl.daty,
    bl.etat,
    m.id AS idmagasin,
    m.val AS magasin,
    v.idreservation,
    c.nom AS idclientlib,
    bl.vehicule,
    bl.chauffeur,
    bl.description,
    c.id AS idclient
FROM as_bondelivraison_client bl
         LEFT JOIN magasinpoint m
                   ON bl.magasin = m.id
         LEFT JOIN vente v
                   ON v.idorigine = bl.idbc
         LEFT JOIN client c
                   ON c.id = bl.idclient;

CREATE OR REPLACE VIEW as_bonlivrfille_client_cpl2_f AS
SELECT
    abcf.id,
    abcf.produit,
    abcf.numbl,
    abcf.quantite,
    vd.id AS idventedetail,
    abcf.unite,
    abcf.idbc_fille,
    p.libelle AS idproduitlib,
    abc.idvente AS idvente,
    abc.idbc,
    CAST(COALESCE(s.qtelivree, 0) AS NUMERIC(30,2)) AS qtelivree,
    u.val AS unitelib,
    vd.pu,
    vd.qte AS qtevente,
    COALESCE(bc_dr.reste, vdr.reste) AS qteResteALivrer
FROM as_bondelivraison_client_fille abcf
         LEFT JOIN as_ingredients p
                   ON p.id = abcf.produit
         LEFT JOIN as_bondelivraison_client_cpl2 abc
                   ON abc.id = abcf.numbl
         LEFT JOIN vente_details vd
                   ON vd.idvente = abc.idvente
                       AND vd.idproduit = abcf.produit
         LEFT JOIN sortiestockfille s
                   ON s.idproduit = abcf.produit
                       AND s.idventedetail = abcf.idventedetail
         LEFT JOIN as_unite u
                   ON u.id = abcf.unite
         LEFT JOIN bc_details_reste bc_dr
                   ON bc_dr.id = abcf.idbc_fille
         LEFT JOIN vente_details_reste vdr
                   ON vdr.id = abcf.idventedetail
WHERE p.actif = 1;

create or replace view avoirfcfille_grp
            (idavoirfc, montantht, montanttva, montantttc, montanthtar, montanttvaar, montantttcar,
             tauxdechange, iddevise, montantremise, montantremisear)
as
SELECT a.idavoirfc,
       CAST(COALESCE(SUM((a.qte * a.pu) - (a.qte * a.pu * a.remise / 100)), 0) AS NUMERIC(30, 2)) AS montantht,
       CAST(COALESCE(SUM(((a.qte * a.pu) - (a.qte * a.pu * a.remise / 100)) * a.tva / 100), 0) AS NUMERIC(30, 2)) AS montanttva,
       CAST(COALESCE(SUM(((a.qte * a.pu) - (a.qte * a.pu * a.remise / 100)) +
                         (((a.qte * a.pu) - (a.qte * a.pu * a.remise / 100)) * a.tva / 100)), 0) AS NUMERIC(30, 2)) AS montantttc,
       CAST(COALESCE(SUM(((a.qte * a.pu) - (a.qte * a.pu * a.remise / 100)) * COALESCE(a.tauxdechange, 1)), 0) AS NUMERIC(30, 2)) AS montanthtar,
       CAST(COALESCE(SUM((((a.qte * a.pu) - (a.qte * a.pu * a.remise / 100)) * a.tva / 100) * COALESCE(a.tauxdechange, 1)), 0) AS NUMERIC(30, 2)) AS montanttvaar,
       CAST(COALESCE(SUM((((a.qte * a.pu) - (a.qte * a.pu * a.remise / 100)) +
                          (((a.qte * a.pu) - (a.qte * a.pu * a.remise / 100)) * a.tva / 100)) * COALESCE(a.tauxdechange, 1)), 0) AS NUMERIC(30, 2)) AS montantttcar,
       MAX(a.tauxdechange) AS tauxdechange,
       a.iddevise,
       CAST(COALESCE(SUM(a.qte * a.pu * a.remise / 100), 0) AS NUMERIC(30, 2)) AS montantremise,
       CAST(COALESCE(SUM((a.qte * a.pu * a.remise / 100) * COALESCE(a.tauxdechange, 1)), 0) AS NUMERIC(30, 2)) AS montantremisear
FROM avoirfcfille a
GROUP BY a.idavoirfc, a.iddevise;

alter table avoirfcfille_grp
    owner to postgres;