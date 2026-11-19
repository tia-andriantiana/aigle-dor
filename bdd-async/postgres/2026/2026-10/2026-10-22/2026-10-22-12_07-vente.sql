CREATE OR REPLACE VIEW ventedetcalc AS
select vd.id,vd.idvente,vd.idproduit,vd.idorigine,vd.qte,vd.iddevise,vd.tauxdechange,vd.designation,vd.compte,vd.idbcfille,vd.unite,vd.poids,vd.ristourne,vd.idprevision,vd.pu,vd.remise,vd.tva,vd.puachat,vd.puvente,vd.purevient,vd.remisemontant,vd.photo,vd.reference,vd.montant,
       --         vd.idremise,vd.qte_tmp,
       cast(vd.qte * vd.pu as numeric(30, 2))                                    as montantNonRemise,
       cast(vd.qte * vd.pu *
            (1 - (1 - (coalesce(vd.remise, 0) / 100)) *
                 (1 - (coalesce(vd.ristourne, 0) / 100)) *
                 (1 - (coalesce(v.remise, 0) / 100))) as numeric(30, 2))         as montantRemiseSansTva,
       cast((vd.qte * vd.pu * (1 - (coalesce(vd.remise, 0) / 100)) * (1 - (coalesce(vd.ristourne, 0) / 100)) * (1 - (coalesce(v.remise, 0) / 100))
             - coalesce(v.fraislivraison, 0) * coalesce(vd.poids, 0) * coalesce(vd.qte, 0)) as numeric(30, 2))
                                                                                 as montantHT,
       cast(vd.pu * (1 - (coalesce(vd.remise, 0) / 100)) * (1 - (coalesce(vd.ristourne, 0) / 100)) *
            (1 - (coalesce(v.remise, 0) / 100)) as numeric(30, 2))               as puRemise,
       cast((vd.qte * vd.pu * (1 - (coalesce(vd.remise, 0) / 100)) * (1 - (coalesce(vd.ristourne, 0) / 100)) * (1 - (coalesce(v.remise, 0) / 100))
             - coalesce(v.fraislivraison, 0) * coalesce(vd.poids, 0) * coalesce(vd.qte, 0)) *
            coalesce(vd.tauxdechange, 1) as numeric(30, 2))                      as montantHTAr,
       cast((vd.qte * vd.pu * (1 - (coalesce(vd.remise, 0) / 100)) * (1 - (coalesce(vd.ristourne, 0) / 100)) * (1 - (coalesce(v.remise, 0) / 100))
             - coalesce(v.fraislivraison, 0) * coalesce(vd.poids, 0) * coalesce(vd.qte, 0)) *
            coalesce(vd.tva, 0) / 100 as numeric(30, 2))                         as montantTva,
       cast((vd.qte * vd.pu * (1 - (coalesce(vd.remise, 0) / 100)) * (1 - (coalesce(vd.ristourne, 0) / 100)) * (1 - (coalesce(v.remise, 0) / 100))
             - coalesce(v.fraislivraison, 0) * coalesce(vd.poids, 0) * coalesce(vd.qte, 0)) *
            coalesce(vd.tauxdechange, 1) * coalesce(vd.tva, 0) / 100 as numeric(30, 2))
                                                                                 as montantTvaAr,
       cast((vd.qte * vd.pu * (1 - (coalesce(vd.remise, 0) / 100)) * (1 - (coalesce(vd.ristourne, 0) / 100)) * (1 - (coalesce(v.remise, 0) / 100))
             - coalesce(v.fraislivraison, 0) * coalesce(vd.poids, 0) * coalesce(vd.qte, 0)) *
            (1 + (coalesce(vd.tva, 0) / 100)) as numeric(30, 2))                 as montantTTC,
       cast((vd.qte * vd.pu * (1 - (coalesce(vd.remise, 0) / 100)) * (1 - (coalesce(vd.ristourne, 0) / 100)) * (1 - (coalesce(v.remise, 0) / 100))
             - coalesce(v.fraislivraison, 0) * coalesce(vd.poids, 0) * coalesce(vd.qte, 0)) *
            (1 + (coalesce(vd.tva, 0) / 100)) *
            coalesce(vd.tauxdechange, 1) as numeric(30, 2))                      as montantTTCAr,
       cast(coalesce(vd.purevient * vd.qte, 0) as numeric(30, 2))                as montantRevient,
       cast((vd.qte * vd.pu * (1 - (coalesce(vd.remise, 0) / 100)) * (1 - (coalesce(vd.ristourne, 0) / 100)) * (1 - (coalesce(v.remise, 0) / 100))
             - coalesce(v.fraislivraison, 0) * coalesce(vd.poids, 0) * coalesce(vd.qte, 0)) *
            (1 + (coalesce(vd.tva, 0) / 100)) *
            coalesce(vd.tauxdechange, 1) -
            coalesce(vd.purevient * vd.qte, 0) as numeric(30, 2))                as margeBrute,
       v.etat
from vente_details vd join vente v on v.id = vd.idvente
;

CREATE OR REPLACE VIEW ventemontant
            (id, montanttotal, montantremise, frais, montanttotalachat, montanttva, montantttc, iddevise, tauxdechange,
             montantttcar, montantrevient, idreservation, poids, colis)
AS
SELECT vd.idvente as id,
       cast(sum((vd.montantht)) as numeric(30, 2))           AS montanttotal,
       cast(sum(vd.montantremisesanstva) as numeric(30, 2))  AS montantremise,
       0::numeric                                            as frais,
       cast(sum(vd.montantnonremise) as numeric(30, 2))      AS montanttotalachat,
       cast(sum(vd.montanttva) as numeric(30, 2))            AS montantTva,
       cast(sum(vd.montantttc) as numeric(30, 2))            as montantTTC,
       coalesce(vd.iddevise, 'AR')                           AS iddevise,
       coalesce(avg(vd.tauxdechange), 1)                     AS tauxDeChange,
       cast(sum(vd.montantttcar) as numeric(30, 2))          as montantTTCAR,
       cast(sum(vd.purevient * vd.qte) as numeric(20, 2))    as montantRevient,
       ''::character varying(100)                            as idreservation,
       coalesce(sum(vd.poids * vd.qte), 0)                   as poids,
       sum(vd.qte)                                           as colis
FROM ventedetcalc vd
GROUP BY vd.idvente, vd.iddevise
;
 
create or replace view vente_cpl
            (id, designation, idmagasin, idmagasinlib, daty, remarque, etat, etatlib, montanttotal, iddevise, idclient,
             idclientlib, montanttva, montantttc, montantttcar, montantpaye, montantreste, avoir, tauxdechange,
             montantrevient, margebrute, idreservation, datyprevu, referencefacture, montantremise, montant, mois,
             annee, poids, colis, modepaiement, modepaiementlib, fraislivraison, modelivraison, modelivraisonlib, reste,
             idprovince, provincelib, idorigine, frais, referencefact, numerofacture, lieulivraison, datelivraison,
             updated_at, estprevulib, idecriture, datedelivraison, motsclesss, heuresaisie, adeclarer, factureechange,
             idpoint)
as
SELECT v.id,
       v.designation,
       v.idmagasin,
       m.val                                                                                              AS idmagasinlib,
       v.daty,
       v.remarque,
       v.etat,
       CASE
           WHEN v.etat = 1::numeric THEN 'cr&eacute;&eacute;e'::text
           WHEN v.etat = 11::numeric THEN 'vis&eacute;e'::text
           WHEN v.etat = 0::numeric THEN 'annul&eacute;e'::text
           ELSE NULL::text
           END                                                                                            AS etatlib,
       v2.montanttotal::numeric(30, 5)                                                                    AS montanttotal,
       v2.iddevise,
       v.idclient,
       c.nom                                                                                              AS idclientlib,
       v2.montanttva::numeric(30, 5)                                                                      AS montanttva,
       v2.montantttc::numeric(30, 5)                                                                      AS montantttc,
       v2.montantttcar::numeric(30, 5)                                                                    AS montantttcar,
       COALESCE(mv.montant, 0::numeric)::numeric(30, 5)                                                   AS montantpaye,
       (COALESCE(v2.montantttc, 0::numeric) - COALESCE(mv.montant, 0::numeric) -
        COALESCE(acg.montantttcar - acg.montantpayear, 0::numeric))::numeric(30, 5)                       AS montantreste,
       COALESCE(acg.montantttcar, 0::numeric)::numeric(30, 5)                                             AS avoir,
       v2.tauxdechange::numeric(10, 2)                                                                    AS tauxdechange,
       v2.montantrevient::numeric(20, 5)                                                                  AS montantrevient,
       (v2.montantttcar - v2.montantrevient)::numeric(20, 5)                                              AS margebrute,
       v.idreservation,
       CASE
           WHEN v.datyprevu IS NULL THEN v.daty
           ELSE v.datyprevu
           END                                                                                            AS datyprevu,
       rf.reference                                                                                       AS referencefacture,
       v2.montantremise::numeric(30, 5)                                                                   AS montantremise,
       (COALESCE(v2.montanttotal, 0::numeric) + COALESCE(v2.montantremise, 0::numeric))::numeric(30, 5)   AS montant,
       date_part('month'::text, v.daty)                                                                   AS mois,
       date_part('year'::text, v.daty)                                                                    AS annee,
       v2.poids::numeric(30, 5)                                                                           AS poids,
       v2.colis::numeric(30, 5)                                                                           AS colis,
       v.modepaiement,
       mp.val                                                                                             AS modepaiementlib,
       COALESCE(v.fraislivraison, 0::numeric) *
       COALESCE(v2.poids, 0::numeric)                                                                     AS fraislivraison,
       v.modelivraison,
       CASE
           WHEN v.modelivraison = 1::numeric THEN '<span style=color: green;>livraison</span>'::text
           WHEN v.modelivraison = 2::numeric THEN '<span style=color: green;>recuperation</span>'::text
           ELSE NULL::text
           END                                                                                            AS modelivraisonlib,
       -- vr.reste::numeric(30, 5)                                                                           AS reste,
       0::numeric(30, 5) as  reste,
       pv.id                                                                                              AS idprovince,
       pv.val                                                                                             AS provincelib,
       v.idorigine,
       COALESCE(v.fraislivraison, 0::numeric)::numeric(30, 5)                                             AS frais,
       v.referencefact,
       v.numerofacture,
       v.lieulivraison,
       v.datelivraison,
       v.updated_at,
       CASE
           WHEN v.estprevu = 0::numeric THEN 'non'::text
           ELSE 'oui'::text
           END                                                                                            AS estprevulib,
       ce.id                                                                                              AS idecriture,
       COALESCE(blc.daty, v.datelivraison)                                                                AS datedelivraison,
       (((((((((((v.id::text || ''::text) || v.daty) || ''::text) || v.idclient::text) || ''::text) || c.nom::text) ||
            ''::text) || v.idmagasin::text) || ''::text) || m.val::text) || ''::text) || v.remarque::text AS motsclesss,
       v.heuresaisie,
       v.adeclarer,
       v.factureechange,
       m.id                                                                                               AS idpoint
FROM vente v
         LEFT JOIN client c ON c.id::text = v.idclient::text
         LEFT JOIN point m ON m.id::text = v.idmagasin::text
         LEFT JOIN zone pv ON pv.id::text = m.idzone::text
         JOIN ventemontant v2 ON v2.id::text = v.id::text
         LEFT JOIN liaisonpaiementtotal mv ON v.id::text = mv.id2::text
         LEFT JOIN avoirfcmontant acg ON acg.idvente::text = v.id::text
         LEFT JOIN referencefacture rf ON rf.idfacture::text = v.id::text
         LEFT JOIN modepaiement mp ON mp.id::text = v.modepaiement::text
         -- LEFT JOIN vente_reste vr ON vr.idvente::text = v.id::text
         LEFT JOIN as_bondelivraison_client blc ON blc.idvente::text = v.id::text
         LEFT JOIN compta_ecriture ce ON ce.idobjet::text = v.id::text;