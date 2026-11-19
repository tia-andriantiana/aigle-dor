create view BL_CLIENT_FILLE_GRP_BC2 as
SELECT
    abcf.IDBC_FILLE,
    SUM(abcf.QUANTITE) AS QUANTITE
FROM
    AS_BONDELIVRAISON_CLIENT_FILLE abcf
        LEFT JOIN AS_BONDELIVRAISON_CLIENT abc ON abc.ID = abcf.NUMBL
WHERE
    abc.ETAT = 11
  AND abcf.IDBC_FILLE IS NOT NULL
  AND abcf.IDVENTEDETAIL IS NULL
GROUP BY
    abcf.IDBC_FILLE;

create or replace view vente_details_reste(id, idproduit, idunite, unitelib, qte, reste, idvente,idbcfille) as
SELECT vd.id,
       vd.idproduit,
       vd.unite                                                                                          AS idunite,
       u.val                                                                                             AS unitelib,
       vd.qte,
       COALESCE(vd.qte, 0::numeric) - COALESCE(bl.quantite, 0::numeric) - COALESCE(bl2.quantite, 0::numeric) AS reste,
       vd.idvente,
       vd.idbcfille
FROM vente_details vd
         LEFT JOIN bl_client_fille_grp_vente bl ON vd.id::text = bl.idventedetail::text
         left join BL_CLIENT_FILLE_GRP_BC2 bl2 ON vd.IDBCFILLE::text = bl2.idbc_fille::text
    LEFT JOIN as_ingredients p ON p.id::text = vd.idproduit::text
    LEFT JOIN as_unite u ON u.id::text = vd.unite::text;
--          LEFT JOIN avoirfcfille_grp_viseee avcf ON vd.id::text = avcf.idventedetails::text;

alter table vente_details_reste
    owner to postgres;



create or replace view avoirfclib
            (id, designation, idmagasin, idmagasinlib, daty, remarque, etat, idorigine, idclient, compte,
             compteauxiliaire, idvente, idventelib, idmotif, idmotiflib, idcategorie, idcategorielib, iddevise,
             tauxdechange, montantht, montanttva, montantttc, montanthtar, montanttvaar, montantttcar, idreservation,
             typeavoir, clientlib, numavoir, idristourne, montantreste, numfact, etatlib)
as
SELECT a.id,
       a.designation,
       a.idmagasin,
       m.val         AS idmagasinlib,
       a.daty,
       a.remarque,
       a.etat,
       a.idorigine,
       a.idclient,
       t.compte,
       t.compteauxiliaire,
       a.idvente,
       v.designation AS idventelib,
       a.idmotif,
       ma.val        AS idmotiflib,
       a.idcategorie,
       c.val         AS idcategorielib,
       ag.iddevise,
       ag.tauxdechange,
       ag.montantht,
       ag.montanttva,
       ag.montantttc,
       ag.montanthtar,
       ag.montanttvaar,
       ag.montantttcar,
       v.idreservation,
       ta.val        AS typeavoir,
       t.nom         AS clientlib,
       a.numavoir,
       a.idristourne,
       v.montantreste,
       v.numfact,
       CASE
           WHEN a.etat = 1::numeric THEN 'cr&eacute;&eacute;e'::text
           WHEN a.etat = 11::numeric THEN 'vis&eacute;e'::text
           WHEN a.etat = 0::numeric THEN 'annul&eacute;e'::text
           ELSE NULL::text
END                                                                                            AS etatlib
FROM avoirfc a
         LEFT JOIN magasin2 m ON m.id::text = a.idmagasin::text
         LEFT JOIN vente_cpl_sansavoir v ON v.id::text = a.idvente::text
         LEFT JOIN motifavoirfc ma ON ma.id::text = a.idmotif::text
         LEFT JOIN categorieavoirfc c ON c.id::text = a.idcategorie::text
         JOIN avoirfcfille_grp ag ON ag.idavoirfc::text = a.id::text
         LEFT JOIN tiers t ON t.id::text = a.idclient::text
         LEFT JOIN typeavoir ta ON ta.id::text = a.idtypeavoir::text;

alter table avoirfclib
    owner to postgres;


create or replace view avoirfclib_cpl
            (id, designation, idmagasin, idmagasinlib, daty, remarque, etat, idorigine, idclient, compte, idvente,
             idventelib, idmotif, idmotiflib, idcategorie, idcategorielib, iddevise, tauxdechange, montantht,
             montanttva, montantttc, montanthtar, montanttvaar, montantttcar, montantpaye, montantpayear,
             montant_reste_facture, montant_avoirs_anterieurs, reste_calcule, excedent_ar, resteapayer, resteapayerar,
             clientlib, typeavoir, numfact,numavoir, etatlib)
as
SELECT al.id,
       al.designation,
       al.idmagasin,
       al.idmagasinlib,
       al.daty,
       al.remarque,
       al.etat,
       al.idorigine,
       al.idclient,
       al.compte,
       al.idvente,
       al.idventelib,
       al.idmotif,
       al.idmotiflib,
       al.idcategorie,
       al.idcategorielib,
       al.iddevise,
       al.tauxdechange,
       al.montantht,
       al.montanttva,
       al.montantttc,
       al.montanthtar,
       al.montanttvaar,
       al.montantttcar,
       COALESCE(m.montant, 0::numeric)                                                   AS montantpaye,
       COALESCE(m.montant, 0::numeric) * COALESCE(al.tauxdechange, 0::numeric)           AS montantpayear,
       COALESCE(vc.montantreste, 0::numeric)                                             AS montant_reste_facture,
       COALESCE(sum_precedents.montant_avoirs_precedents, 0::numeric)                    AS montant_avoirs_anterieurs,
       CASE
           WHEN COALESCE(vc.montantreste, 0::numeric) = 0::numeric THEN 0::numeric
           ELSE COALESCE(vc.montantreste, 0::numeric) - COALESCE(sum_precedents.montant_avoirs_precedents, 0::numeric) -
                COALESCE(al.montantttcar, 0::numeric)
END                                                                           AS reste_calcule,
       CASE
           WHEN COALESCE(vc.montantreste, 0::numeric) = 0::numeric THEN COALESCE(al.montantttcar, 0::numeric)
           WHEN
               (COALESCE(vc.montantreste, 0::numeric) - COALESCE(sum_precedents.montant_avoirs_precedents, 0::numeric) -
                COALESCE(al.montantttcar, 0::numeric)) < 0::numeric THEN abs(COALESCE(vc.montantreste, 0::numeric) -
                                                                             COALESCE(sum_precedents.montant_avoirs_precedents, 0::numeric) -
                                                                             COALESCE(al.montantttcar, 0::numeric))
           ELSE 0::numeric
END                                                                           AS excedent_ar,
       CASE
           WHEN COALESCE(vc.montantreste, 0::numeric) = 0::numeric THEN COALESCE(al.montantttcar, 0::numeric)
           WHEN
               (COALESCE(vc.montantreste, 0::numeric) - COALESCE(sum_precedents.montant_avoirs_precedents, 0::numeric) -
                COALESCE(al.montantttcar, 0::numeric)) < 0::numeric THEN abs(COALESCE(vc.montantreste, 0::numeric) -
                                                                             COALESCE(sum_precedents.montant_avoirs_precedents, 0::numeric) -
                                                                             COALESCE(al.montantttcar, 0::numeric))
           ELSE 0::numeric
END - COALESCE(m.montant, 0::numeric)                                         AS resteapayer,
       CASE
           WHEN COALESCE(vc.montantreste, 0::numeric) = 0::numeric THEN COALESCE(al.montantttcar, 0::numeric)
           WHEN
               (COALESCE(vc.montantreste, 0::numeric) - COALESCE(sum_precedents.montant_avoirs_precedents, 0::numeric) -
                COALESCE(al.montantttcar, 0::numeric)) < 0::numeric THEN abs(COALESCE(vc.montantreste, 0::numeric) -
                                                                             COALESCE(sum_precedents.montant_avoirs_precedents, 0::numeric) -
                                                                             COALESCE(al.montantttcar, 0::numeric))
           ELSE 0::numeric
END - COALESCE(m.montant, 0::numeric) * COALESCE(al.tauxdechange, 0::numeric) AS resteapayerar,
       al.clientlib,
       al.typeavoir,
       vc.numfact,
       al.numavoir,
       al.etatlib
FROM avoirfclib al
         LEFT JOIN (SELECT m_1.id1          AS idorigine,
                           sum(m_1.montant) AS montant,
                           'AR'::text       AS iddevise
                    FROM liaisonpaiement m_1
                    WHERE m_1.etat >= 11::numeric
                      AND m_1.id1 IS NOT NULL
                    GROUP BY m_1.id1) m ON al.id::text = m.idorigine::text
         LEFT JOIN vente_cpl_sansavoir vc ON vc.id::text = al.idvente::text
         LEFT JOIN (SELECT _0.idvente,
                           _0.id AS idcourant,
                           _0.montant_avoirs_precedents
                    FROM (SELECT avoirfclib.idvente,
                                 avoirfclib.id,
                                 sum(
                                 CASE
                                     WHEN avoirfclib.etat <> 0::numeric THEN avoirfclib.montantttcar
                                     ELSE 0::numeric
                                     END)
                                 OVER (PARTITION BY avoirfclib.idvente ORDER BY avoirfclib.daty, avoirfclib.id ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS montant_avoirs_precedents
                          FROM avoirfclib avoirfclib) _0
                    WHERE NOT _0.montant_avoirs_precedents IS NULL) sum_precedents
                   ON sum_precedents.idvente::text = al.idvente::text AND sum_precedents.idcourant::text = al.id::text;

alter table avoirfclib_cpl
    owner to postgres;

create or replace view avoirfcfillelib as
SELECT af.id,
       af.idavoirfc,
       af.idproduit,
       af.idorigine,
       af.qte,
       af.pu,
       af.remise,
       af.tva,
       af.puachat,
       af.puvente,
       af.iddevise,
       af.tauxdechange,
       af.designation,
       af.idventedetails,
       p.libellevente                                                                    AS idproduitlib,
       p.calorie,
       p.calorie * af.qte                                                                AS poids,
       af.pu * af.qte                                                                    AS ptht,
       COALESCE(af.pu, 0::numeric) * COALESCE(af.qte, 0::numeric) * COALESCE(af.tva, 0::numeric) /
       100::numeric                                                                      AS montanttva,
       -- nouvelles colonnes
    cast((af.pu - (af.pu * coalesce(af.remise, 0) / 100)) * af.qte as numeric(30, 2)) AS montantht,
       cast(((af.pu * af.qte) - (af.pu * coalesce(af.remise, 0) / 100) * af.qte) * af.tva / 100
           as numeric(30, 2))                                                           AS montanttva_remise,
       cast(((af.pu - (af.pu * coalesce(af.remise, 0) / 100)) * af.qte) +
            (((af.pu * af.qte) - (af.pu * coalesce(af.remise, 0) / 100) * af.qte) * af.tva / 100)
           as numeric(30, 2))                                                           AS montantttc,
       cast((af.pu * coalesce(af.remise, 0) / 100) * af.qte as numeric(30, 2))           AS montantremise,
       cast(coalesce(((af.pu - (af.pu * coalesce(af.remise, 0) / 100)) * af.qte)
                         * coalesce(af.tauxdechange, 1), 0) as numeric(30, 2))           AS montanthtar,
       cast(coalesce((((af.pu * af.qte) - (af.pu * coalesce(af.remise, 0) / 100) * af.qte) * af.tva / 100)
                         * coalesce(af.tauxdechange, 1), 0) as numeric(30, 2))           AS montanttvaar,
       cast(coalesce(((((af.pu - (af.pu * coalesce(af.remise, 0) / 100)) * af.qte) +
                       (((af.pu * af.qte) - (af.pu * coalesce(af.remise, 0) / 100) * af.qte) * af.tva / 100))
           * coalesce(af.tauxdechange, 1)), 0) as numeric(30, 2))          AS montantttcar,
       cast(((af.pu * coalesce(af.remise, 0) / 100) * af.qte) * coalesce(af.tauxdechange, 1)
           as numeric(30, 2))                                                           AS montantremisear
FROM avoirfcfille af
         LEFT JOIN as_ingredients p ON p.id::text = af.idproduit::text;


alter table avoirfcfillelib
    owner to postgres;

create or replace view mouvementcaissecpl_v_dispatch
            (id, designation, idcaisse, idcaisselib, idventedetail, idvirement, debit, credit, montantimpute, daty,
             etat, etatlib, idvente, idorigine, idtiers, tiers, idpaiement, referencepaiement, designationpaiement,idmvtcaissemere)
as
SELECT m.id,
       m.designation,
       m.idcaisse,
       m.idcaisselib,
       m.idventedetail,
       m.idvirement,
       m.debit,
       m.credit,
       lp.montant    AS montantimpute,
       m.daty,
       m.etat,
       m.etatlib,
       m.idvente,
       lp.id2        AS idorigine,
       m.idtiers,
       m.tiers,
       lp.id1        AS idpaiement,
       m.reference   AS referencepaiement,
       m.designation AS designationpaiement,
       idmvtcaissemere
FROM liaisonpaiement lp
         LEFT JOIN mouvementcaissecpl m ON m.id::text = lp.id1::text
WHERE m.etat > 7::numeric;

alter table mouvementcaissecpl_v_dispatch
    owner to postgres;

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