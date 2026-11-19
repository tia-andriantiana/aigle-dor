create or replace view liaisonpaiementtotal(id2, montant) as
SELECT liaisonpaiement.id2,
       sum(COALESCE(liaisonpaiement.montant, 0::numeric)) AS montant,
       sum(COALESCE(liaisonpaiement.montant*mc.taux,0)) AS montantAr

FROM liaisonpaiement
         LEFT JOIN mouvementcaisse mc ON mc.id = id1
WHERE liaisonpaiement.etat >= 11::numeric
GROUP BY liaisonpaiement.id2;

alter table liaisonpaiementtotal
    owner to postgres;


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
       0::numeric(30, 5)                                                                                  AS reste,
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
       m.id                                                                                               AS idpoint,
       coalesce(mv.montantar, 0)::numeric(30, 2) as montantpayear,
       (coalesce(v2.montantttcar, 0) - coalesce(mv.montantar, 0) - coalesce(acg.montantttcar, 0))::numeric(30, 2) as montantrestear
FROM vente v
         LEFT JOIN client c ON c.id::text = v.idclient::text
         LEFT JOIN point m ON m.id::text = v.idmagasin::text
         LEFT JOIN zone pv ON pv.id::text = m.idzone::text
         JOIN ventemontant v2 ON v2.id::text = v.id::text
         LEFT JOIN liaisonpaiementtotal mv ON v.id::text = mv.id2::text
         LEFT JOIN avoirfcmontant acg ON acg.idvente::text = v.id::text
         LEFT JOIN referencefacture rf ON rf.idfacture::text = v.id::text
         LEFT JOIN modepaiement mp ON mp.id::text = v.modepaiement::text
         LEFT JOIN as_bondelivraison_client blc ON blc.idvente::text = v.id::text
         LEFT JOIN compta_ecriture ce ON ce.idobjet::text = v.id::text;

alter table vente_cpl
    owner to postgres;

create or replace view compta_sousecriture_lib
            (id, numero, compte, journal, idjournal, ecriture, daty, credit, debit, datecomptable, exercice, remarque,
             etat, idmere, horsexercice, od, origine, tiers, libellepiece, compte_aux, raisonsocial, folio, lettrage,
             analytique, idobjet)
as
SELECT sousecr.id,
       cpt.libelle                                      AS numero,
       cpt.compte,
       (jrn.val::text || '| '::text) || jrn.desce::text AS journal,
    jrn.id                                           AS idjournal,
       sousecr.remarque                                 AS ecriture,
       sousecr.daty,
       sousecr.credit,
       sousecr.debit,
       sousecr.daty                                     AS datecomptable,
       sousecr.exercice,
       sousecr.remarque,
       sousecr.etat,
       sousecr.idmere,
       0::numeric                                       AS horsexercice,
    '-'::character varying(50)                       AS od,
       ''::character varying(50)                        AS origine,
       ''::character varying(50)                        AS tiers,
       sousecr.libellepiece,
       sousecr.compte_aux,
       ''::character varying(100)                       AS raisonsocial,
       sousecr.folio,
       sousecr.lettrage,
       sousecr.analytique,
       ce.idobjet
FROM compta_sous_ecriture sousecr
    JOIN compta_compte cpt ON sousecr.compte::text = cpt.compte::text
    JOIN compta_journal jrn ON sousecr.journal::text = jrn.id::text
    join compta_ecriture ce on ce.id::text = sousecr.idmere::text;

alter table compta_sousecriture_lib
    owner to postgres;
