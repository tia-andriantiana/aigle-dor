-- Bon de commande : detail avec remise, quantite recue et quantite facturee (aligne sur codal)
-- Postgres. Les colonnes existantes de AS_BONDECOMMANDE_CPL_RECEPT gardent leur ordre, les nouvelles sont ajoutees a la fin.

CREATE
OR REPLACE VIEW public.as_bcfillecalc AS
SELECT bcf.id                                                                                                      AS id,
       CAST(COALESCE(bcf.pu, 0) AS NUMERIC(30, 5))                                                                 AS pu,
       bcf.tva                                                                                                     AS tva,
       CAST(COALESCE(bcf.remise, 0) AS NUMERIC(30, 2))                                                             AS remise,
       bcf.iddevise                                                                                                AS iddevise,
       bcf.tauxdechange                                                                                            AS tauxdechange,
       CAST(COALESCE(bcf.pu, 0) * COALESCE(bcf.quantite, 0) AS NUMERIC(30, 2))                                     AS montant,
       CAST((COALESCE(bcf.pu, 0) * COALESCE(bcf.quantite, 0)) *
            (COALESCE(bcf.remise, 0) / 100) AS NUMERIC(30, 2))                                                     AS montantdelaremise,
       CAST(
               CAST(COALESCE(bcf.pu, 0) * COALESCE(bcf.quantite, 0) AS NUMERIC(30, 2))
                   - CAST((COALESCE(bcf.pu, 0) * COALESCE(bcf.quantite, 0)) *
                          (COALESCE(bcf.remise, 0) / 100) AS NUMERIC(30, 2))
           AS NUMERIC(30, 2))                                                                                      AS montantremise,
       CAST(
               (
                   CAST(COALESCE(bcf.pu, 0) * COALESCE(bcf.quantite, 0) AS NUMERIC(30, 2))
                       - CAST((COALESCE(bcf.pu, 0) * COALESCE(bcf.quantite, 0)) *
                              (COALESCE(bcf.remise, 0) / 100) AS NUMERIC(30, 2))
                   ) * (COALESCE(bcf.tva, 0) / 100)
           AS NUMERIC(30, 2))                                                                                      AS montanttva,
       CAST(
               (
                   CAST(COALESCE(bcf.pu, 0) * COALESCE(bcf.quantite, 0) AS NUMERIC(30, 2))
                       - CAST((COALESCE(bcf.pu, 0) * COALESCE(bcf.quantite, 0)) *
                              (COALESCE(bcf.remise, 0) / 100) AS NUMERIC(30, 2))
                   ) * (1 + COALESCE(bcf.tva, 0) / 100)
           AS NUMERIC(30, 2))                                                                                      AS montantttc,
       CAST(
               CAST(COALESCE(bcf.pu, 0) * COALESCE(bcf.quantite, 0) AS NUMERIC(30, 2))
                   - CAST((COALESCE(bcf.pu, 0) * COALESCE(bcf.quantite, 0)) *
                          (COALESCE(bcf.remise, 0) / 100) AS NUMERIC(30, 2))
           AS NUMERIC(30, 2))                                                                                      AS montantht
FROM public.as_bondecommande_fille AS bcf;

CREATE
OR REPLACE VIEW public.as_bondecommande_cpl_recept (
    "id", "idbc", "produitlib", "unitelib", "produit", "quantite", "qtelivrer", "qtefacturer",
    "pu", "tva", "remise", "iddevise", "tauxdechange", "montant", "montantdelaremise", "montantremise", "montanttva", "montantttc", "montantht", "montantttcar"
) AS
SELECT bc.id                                                                               AS id,
       bc.idbc                                                                             AS idbc,
       bc.produitlib                                                                       AS produitlib,
       bc.unitelib                                                                         AS unitelib,
       bc.produit                                                                          AS produit,
       COALESCE(bc.quantite, 0)                                                            AS quantite,
       COALESCE(bl.qte, 0)                                                                 AS qtelivrer,
       COALESCE(ffm.qte, 0)                                                                AS qtefacturer,
       calc.pu                                                                             AS pu,
       calc.tva                                                                            AS tva,
       calc.remise                                                                         AS remise,
       calc.iddevise                                                                       AS iddevise,
       calc.tauxdechange                                                                   AS tauxdechange,
       calc.montant                                                                        AS montant,
       calc.montantdelaremise                                                              AS montantdelaremise,
       calc.montantremise                                                                  AS montantremise,
       calc.montanttva                                                                     AS montanttva,
       calc.montantttc                                                                     AS montantttc,
       calc.montantht                                                                      AS montantht,
       CAST(calc.montantttc * COALESCE(NULLIF(calc.tauxdechange, 0), 1) AS NUMERIC(30, 2)) AS montantttcar
FROM public.as_bondecommande_cpl AS bc
         LEFT JOIN public.as_bcfillecalc AS calc
                   ON calc.id = bc.id
         LEFT JOIN public.ff_fillebl_grp AS bl
                   ON bc.id = bl.idbc_fille
         LEFT JOIN public.ff_fillebc_grp_mere AS ffm
                   ON ffm.idbc = bc.idbc AND ffm.idproduit = bc.produit;



CREATE
OR REPLACE VIEW dmdachatlib
AS
SELECT da.id,
       da.daty,
       da.fournisseur,
       f.nom  AS fournisseurlib,
       da.remarque,
       da.datelimite,
       m.val  AS idmagasinlib,
       ci.val AS idcategorielib,
       da.etat,
       CASE
           WHEN da.etat = 0::numeric THEN 'annul&eacute;e'::text
            WHEN da.etat = 1::numeric THEN 'cr&eacute;&eacute;e'::text
            WHEN da.etat = 11::numeric THEN 'vis&eacute;(e)'::text
            WHEN da.etat = 3::numeric THEN 'vis&eacute;(e) par chef de fabrication'::text
            WHEN da.etat = 4::numeric THEN 'vis&eacute;(e) par le directeur'::text
            ELSE NULL::text
END
AS etatlib,
    da.idobjet,
    s.libelle AS idservicelib,
    da.idprovenance,
    pr.val AS idprovenancelib
   FROM dmdachat da
     LEFT JOIN fournisseur f ON f.id::text = da.fournisseur::text
     LEFT JOIN magasin2 m ON da.idmagasin::text = m.id::text
     LEFT JOIN categorieingredient ci ON da.idcategorie::text = ci.id::text
     LEFT JOIN service s ON da.service::text = s.compte::text
     LEFT JOIN provenance pr ON da.idprovenance::text = pr.id::text;





CREATE
OR REPLACE VIEW AS_BONDECOMMANDE_CPL_MAGASIN AS
SELECT ab.id,
       ab.daty,
       ab.etat,
       ab.remarque,
       ab.designation,
       ab.modepaiement,
       ab.fournisseur,
       ab.reference,
       ab.datelimite,
       mp.val                                                                                   AS modepaiementlib,
       f.nom                                                                                    AS fournisseurlib,
       CAST(COALESCE(abf.montanttva, 0) AS NUMERIC(30, 2))                                      AS montanttva,
       CAST(COALESCE(abf.montantht, 0) AS NUMERIC(30, 2))                                       AS montantht,
       CAST(COALESCE(abf.montantht + abf.montanttva, 0) AS NUMERIC(30, 2))                      AS montantttc,
       CAST(COALESCE((abf.montantht + abf.montanttva) * abf.tauxdechange, 0) AS NUMERIC(30, 2)) AS montantttcariary,
       d.val                                                                                    AS iddeviselib,
       d.id                                                                                     AS iddevise,
       CASE
           WHEN ab.etat = 1 THEN 'CRÉÉ'
           WHEN ab.etat = 0 THEN 'ANNULÉ'
           WHEN ab.etat = 3 THEN 'VISÉ par Magasinier'
           WHEN ab.etat = 4 THEN 'VISÉ par Chef du département'
           WHEN ab.etat = 5 THEN 'VISÉ par DAF'
           WHEN ab.etat = 11 THEN 'VISÉ par Directeur'
           END                                                                                  AS etatlib,
--    ci.val AS idcategorielib,
       ab.idmagasin,
       m2.val                                                                                   AS idmagasinlib
FROM as_bondecommande ab
         LEFT JOIN modepaiement mp
                   ON ab.modepaiement = mp.id
         LEFT JOIN fournisseur f
                   ON ab.fournisseur = f.id
         LEFT JOIN as_bondecommandefille_cpl abf
                   ON abf.idbc = ab.id
         LEFT JOIN devise d
                   ON d.id = ab.iddevise
    --LEFT JOIN categorieingredient ci
--    ON ci.id = ab.idcategorie
         LEFT JOIN magasin2 m2
                   ON m2.id = ab.idmagasin;



DROP VIEW IF EXISTS facturefournisseurcpl_tous_fae;
CREATE VIEW facturefournisseurcpl_tous_fae
AS
SELECT fcpl.id,
       fcpl.idfournisseur,
       fcpl.idfournisseurlib,
       fcpl.idmodepaiement,
       fcpl.idmodepaiementlib,
       fcpl.daty,
       fcpl.designation,
       fcpl.dateecheancepaiement,
       fcpl.etatlib,
       fcpl.reference,
       fcpl.idbc,
       fcpl.idmagasin,
       fcpl.idmagasinlib,
       fcpl.devise,
       fcpl.iddevise,
       fcpl.etat,
       fcpl.taux::numeric(30,5) AS taux, fcpl.montanttva,
       fcpl.montantht,
       fcpl.tauxdechange,
       fcpl.montantttc,
       COALESCE(fcpl.montantpaye * fcpl.tauxdechange, 0::numeric)::numeric(30,5) AS montantpaye, COALESCE(fcpl.montantreste * fcpl.tauxdechange, 0::numeric)::numeric(30,5) AS montantreste, fcpl.idobjet,
       fcpl.idref,
       fcpl.idservicelib,
       fcpl.idtypefacture,
       fcpl.idfactureprincipale,
       fcpl.typefacture,
       (fcpl.montantttc * fcpl.tauxdechange)::numeric(30,5) AS montantttcar, COALESCE(fcpl.montantpaye * fcpl.tauxdechange, 0::numeric)::numeric(30,5) AS montantpayear, COALESCE(fcpl.montantreste * fcpl.tauxdechange, 0::numeric) ::numeric(30,5) AS montantresteAr
FROM facturefournisseurcpl fcpl
         LEFT JOIN facturefournisseurcpl f2 ON f2.idfactureprincipale::text = fcpl.id::text
  WHERE f2.id IS NULL;

DROP VIEW IF EXISTS facturefournisseurcpl_mga_fae;
CREATE VIEW facturefournisseurcpl_mga_fae
AS
SELECT fcpl.id,
       fcpl.idfournisseur,
       fcpl.idfournisseurlib,
       fcpl.idmodepaiement,
       fcpl.idmodepaiementlib,
       fcpl.daty,
       fcpl.designation,
       fcpl.dateecheancepaiement,
       fcpl.etatlib,
       fcpl.reference,
       fcpl.idbc,
       fcpl.idmagasin,
       fcpl.idmagasinlib,
       fcpl.devise,
       fcpl.iddevise,
       fcpl.etat,
       fcpl.taux::numeric(30,5) AS taux, fcpl.montanttva,
       fcpl.montantht,
       fcpl.tauxdechange,
       fcpl.montantttc,
       COALESCE(fcpl.montantpaye * fcpl.tauxdechange, 0::numeric)::numeric(30,5) AS montantpaye, COALESCE(fcpl.montantreste * fcpl.tauxdechange, 0::numeric)::numeric(30,5) AS montantreste, fcpl.idobjet,
       fcpl.idref,
       fcpl.idservicelib,
       fcpl.idtypefacture,
       fcpl.idfactureprincipale,
       fcpl.typefacture,
       (fcpl.montantttc * fcpl.tauxdechange)::numeric(30,5) AS montantttcar, COALESCE(fcpl.montantpaye * fcpl.tauxdechange, 0::numeric)::numeric(30,5) AS montantpayear, COALESCE(fcpl.montantreste * fcpl.tauxdechange, 0::numeric) ::numeric(30,5) AS montantresteAr
FROM facturefournisseurcpl fcpl
         LEFT JOIN facturefournisseurcpl f2 ON f2.idfactureprincipale::text = fcpl.id::text
  WHERE f2.id IS NULL AND fcpl.iddevise::text = 'AR';

DROP VIEW IF EXISTS facturefournisseurcpl_eur_fae;
CREATE VIEW facturefournisseurcpl_eur_fae
AS
SELECT fcpl.id,
       fcpl.idfournisseur,
       fcpl.idfournisseurlib,
       fcpl.idmodepaiement,
       fcpl.idmodepaiementlib,
       fcpl.daty,
       fcpl.designation,
       fcpl.dateecheancepaiement,
       fcpl.etatlib,
       fcpl.reference,
       fcpl.idbc,
       fcpl.idmagasin,
       fcpl.idmagasinlib,
       fcpl.devise,
       fcpl.iddevise,
       fcpl.etat,
       fcpl.taux::numeric(30,5) AS taux, fcpl.montanttva,
       fcpl.montantht,
       fcpl.tauxdechange,
       fcpl.montantttc,
       COALESCE(fcpl.montantpaye * fcpl.tauxdechange, 0::numeric)::numeric(30,5) AS montantpaye, COALESCE(fcpl.montantreste * fcpl.tauxdechange, 0::numeric)::numeric(30,5) AS montantreste, fcpl.idobjet,
       fcpl.idref,
       fcpl.idservicelib,
       fcpl.idtypefacture,
       fcpl.idfactureprincipale,
       fcpl.typefacture,
       (fcpl.montantttc * fcpl.tauxdechange)::numeric(30,5) AS montantttcar, COALESCE(fcpl.montantpaye * fcpl.tauxdechange, 0::numeric)::numeric(30,5) AS montantpayear, COALESCE(fcpl.montantreste * fcpl.tauxdechange, 0::numeric) ::numeric(30,5) AS montantresteAr
FROM facturefournisseurcpl fcpl
         LEFT JOIN facturefournisseurcpl f2 ON f2.idfactureprincipale::text = fcpl.id::text
  WHERE f2.id IS NULL AND fcpl.iddevise::text = 'EUR';

DROP VIEW IF EXISTS facturefournisseurcpl_usd_fae;
CREATE VIEW facturefournisseurcpl_usd_fae
AS
SELECT fcpl.id,
       fcpl.idfournisseur,
       fcpl.idfournisseurlib,
       fcpl.idmodepaiement,
       fcpl.idmodepaiementlib,
       fcpl.daty,
       fcpl.designation,
       fcpl.dateecheancepaiement,
       fcpl.etatlib,
       fcpl.reference,
       fcpl.idbc,
       fcpl.idmagasin,
       fcpl.idmagasinlib,
       fcpl.devise,
       fcpl.iddevise,
       fcpl.etat,
       fcpl.taux::numeric(30,5) AS taux, fcpl.montanttva,
       fcpl.montantht,
       fcpl.tauxdechange,
       fcpl.montantttc,
       COALESCE(fcpl.montantpaye * fcpl.tauxdechange, 0::numeric)::numeric(30,5) AS montantpaye, COALESCE(fcpl.montantreste * fcpl.tauxdechange, 0::numeric)::numeric(30,5) AS montantreste, fcpl.idobjet,
       fcpl.idref,
       fcpl.idservicelib,
       fcpl.idtypefacture,
       fcpl.idfactureprincipale,
       fcpl.typefacture,
       (fcpl.montantttc * fcpl.tauxdechange)::numeric(30,5) AS montantttcar, COALESCE(fcpl.montantpaye * fcpl.tauxdechange, 0::numeric)::numeric(30,5) AS montantpayear, COALESCE(fcpl.montantreste * fcpl.tauxdechange, 0::numeric) ::numeric(30,5) AS montantresteAr
FROM facturefournisseurcpl fcpl
         LEFT JOIN facturefournisseurcpl f2 ON f2.idfactureprincipale::text = fcpl.id::text
  WHERE f2.id IS NULL AND fcpl.iddevise::text = 'USD';

CREATE
OR REPLACE VIEW facturefournisseurfillecpl AS
SELECT f.id,
       f.idfacturefournisseur,
       f.idproduit,
       p.libelle                                                                                                     AS idproduitlib,
       f.qte,
       f.pu,
       f.remises,
       f.idbcdetail,
       f.tva,
       f.iddevise,
       f2.daty,
       CAST(f.qte * f.pu AS NUMERIC(30, 2))                                                                          AS montant,
       CAST(f.qte * f.pu AS NUMERIC(30, 2))                                                                          AS montanttotal,
       CAST((COALESCE(f.remises, 0) / 100) * (f.qte * f.pu) AS NUMERIC(30, 2))                                       AS montantremise,
       CAST((f.qte * f.pu) - ((COALESCE(f.remises, 0) / 100) * (f.qte * f.pu)) AS NUMERIC(30, 2))                    AS montantht,
       CAST(((f.qte * f.pu) - ((COALESCE(f.remises, 0) / 100) * (f.qte * f.pu))) * f.tva /
            100 AS NUMERIC(30, 2))                                                                                   AS montanttva,
       CAST(((f.qte * f.pu) - ((COALESCE(f.remises, 0) / 100) * (f.qte * f.pu)))
           + (((f.qte * f.pu) - ((COALESCE(f.remises, 0) / 100) * (f.qte * f.pu))) * f.tva /
              100) AS NUMERIC(30, 2))                                                                                AS montantttc,
       COALESCE(f.montantpertegain, 0)                                                                               AS fraisaccesoire,
       CAST(((f.qte * f.pu * f.tauxdechange) - ((COALESCE(f.remises, 0) / 100) * (f.qte * f.pu * f.tauxdechange)))
           +
            COALESCE(f.montantpertegain, 0) AS NUMERIC(30, 2))                                                       AS montantavecfraisaccessoire,
       CAST((((f.qte * f.pu * f.tauxdechange) - ((COALESCE(f.remises, 0) / 100) * (f.qte * f.pu * f.tauxdechange)))
           + COALESCE(f.montantpertegain, 0)) /
            NULLIF(f.qte, 0) AS NUMERIC(30, 2))                                                                      AS puavecfraisaccessoire,
       COALESCE(p.libelleextacte, p.libelle)                                                                         AS libelleexacte,
       f.idprevision,
       p2.id                                                                                                         AS idpoint,
       p2.val                                                                                                        AS idpointlib,
       m.id                                                                                                          AS idmagasin,
       m.val                                                                                                         AS idmagasinlib,
       c.id                                                                                                          AS idcategorie,
       c.val                                                                                                         AS idcategorielib,
       CAST(COALESCE(f.remises, 0) AS NUMERIC(30, 5))                                                                AS remise
FROM facturefournisseurfille f
         LEFT JOIN facturefournisseur f2 ON CAST(f2.id AS TEXT) = CAST(f.idfacturefournisseur AS TEXT)
         LEFT JOIN magasin m ON CAST(m.id AS TEXT) = CAST(f2.idmagasin AS TEXT)
         LEFT JOIN point p2 ON CAST(p2.id AS TEXT) = CAST(m.idpoint AS TEXT)
         LEFT JOIN as_ingredients p ON CAST(p.id AS TEXT) = CAST(f.idproduit AS TEXT)
         LEFT JOIN categorieingredient c ON CAST(c.id AS TEXT) = CAST(p.categorieingredient AS TEXT);



