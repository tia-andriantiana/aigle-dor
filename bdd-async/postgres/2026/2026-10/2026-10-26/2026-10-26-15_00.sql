
create view AS_BLCLIENTFILLEGRPBCFILLE as
select produit,IDBC_FILLE,sum(QUANTITE) as quantite from AS_BONDELIVRAISON_CLIENT_FILLE f
                                                             join AS_BONDELIVRAISON_CLIENT m on m.ID=f.NUMBL where m.ETAT>=11
group by produit, IDBC_FILLE;

create or replace view bc_client_fille_cpl_lib
            (id, produit, idbc, quantite, pu, montant, tva, remise, iddevise, unite, produitlib, compte, qtereste,
             unitelib, montanttotal, montantdelaremise, montantristourne, montantremise, montanttva, montantttc,
             ristourne, fraistransport, poidstotal, tauxdechange,qteLivre,qteFacture)
as
SELECT bcf.id,
       bcf.produit,
       bcf.idbc,
       bcf.quantite,
       bcf.pu,
       bcf.montant,
       bcf.tva,
       bcf.remise,
       bcf.iddevise,
       bcf.unite,
       i.libellevente                                                                                                                        AS produitlib,
       i.compte_vente                                                                                                                        AS compte,
       COALESCE(bcf.quantite, 0::numeric) -
       COALESCE(vdbc.qte, 0::numeric)                                                                                                        AS qtereste,
       au.val                                                                                                                                AS unitelib,
       (COALESCE(bcf.pu, 0::numeric) * COALESCE(bcf.quantite, 0::numeric))::numeric(30, 2)                                                   AS montanttotal,
    (COALESCE(bcf.pu, 0::numeric) * COALESCE(bcf.quantite, 0::numeric) *
     (bcf.remise / 100::numeric))::numeric(30, 2)                                                                                         AS montantdelaremise,
    ((COALESCE(bcf.pu, 0::numeric) * COALESCE(bcf.quantite, 0::numeric) -
      COALESCE(bcf.pu, 0::numeric) * COALESCE(bcf.quantite, 0::numeric) * (bcf.remise / 100::numeric)) *
     (bcf.ristourne / 100::numeric))::numeric(30, 2)                                                                                      AS montantristourne,
    (COALESCE(bcf.pu, 0::numeric) * COALESCE(bcf.quantite, 0::numeric) -
     COALESCE(bcf.pu, 0::numeric) * COALESCE(bcf.quantite, 0::numeric) * (bcf.remise / 100::numeric) -
     (COALESCE(bcf.pu, 0::numeric) * COALESCE(bcf.quantite, 0::numeric) -
      COALESCE(bcf.pu, 0::numeric) * COALESCE(bcf.quantite, 0::numeric) * (bcf.remise / 100::numeric)) *
     (bcf.ristourne / 100::numeric) -
     COALESCE(i.calorie * bcf.quantite * bc.fraislivraison, 0::numeric))::numeric(30, 2)                                                  AS montantremise,
    ((COALESCE(bcf.pu, 0::numeric) * COALESCE(bcf.quantite, 0::numeric) -
      (COALESCE(bcf.pu, 0::numeric) * COALESCE(bcf.quantite, 0::numeric) * (bcf.remise / 100::numeric) +
       (COALESCE(bcf.pu, 0::numeric) * COALESCE(bcf.quantite, 0::numeric) -
        COALESCE(bcf.pu, 0::numeric) * COALESCE(bcf.quantite, 0::numeric) * (bcf.remise / 100::numeric)) *
       (bcf.ristourne / 100::numeric)) - COALESCE(i.calorie * bcf.quantite * bc.fraislivraison, 0::numeric)) *
     (COALESCE(bcf.tva, 0::numeric) / 100::numeric))::numeric(30, 2)                                                                      AS montanttva,
    ((bcf.quantite * bcf.pu -
      bcf.quantite * bcf.pu * COALESCE(bcf.remise, 0::numeric) / 100::numeric)::numeric(30, 2) -
        (bcf.quantite * bcf.pu -
         bcf.quantite * bcf.pu * COALESCE(bcf.remise, 0::numeric) / 100::numeric)::numeric(30, 2) *
        COALESCE(bcf.ristourne, 0::numeric) / 100::numeric -
        COALESCE(i.calorie * bcf.quantite * bc.fraislivraison, 0::numeric) +
        COALESCE(bcf.tva, 0::numeric) / 100::numeric * ((bcf.quantite * bcf.pu -
                                                         bcf.quantite * bcf.pu * COALESCE(bcf.remise, 0::numeric) /
                                                         100::numeric)::numeric(30, 2) - (bcf.quantite * bcf.pu -
                                                                                          bcf.quantite * bcf.pu *
                                                                                          COALESCE(bcf.remise, 0::numeric) /
                                                                                          100::numeric)::numeric(30, 2) *
                                                                                         COALESCE(bcf.ristourne, 0::numeric) /
                                                                                         100::numeric -
                                                        COALESCE(i.calorie * bcf.quantite * bc.fraislivraison, 0::numeric)))::numeric(30, 2) AS montantttc,
       bcf.ristourne,
       COALESCE(i.calorie * bcf.quantite * bc.fraislivraison, 0::numeric)                                                                    AS fraistransport,
       COALESCE(i.calorie * bcf.quantite, 0::numeric)::numeric(30, 2)                                                                        AS poidstotal,
       bcf.tauxdechange,
       CAST(COALESCE(blf.QUANTITE, 0::numeric) AS numeric(30,2)) AS qteLivre,
       CAST(COALESCE(vdbc.qte, 0::numeric) AS numeric(30,2)) AS qteFacture
FROM bondecommande_client_fille bcf
    LEFT JOIN as_ingredients i ON i.id::text = bcf.produit::text
    LEFT JOIN vente_details_qte_grp vdbc ON bcf.id::text = vdbc.idbcfille::text
    LEFT JOIN as_unite au ON au.id::text = i.unite::text
    LEFT JOIN bondecommande_client bc ON bc.id::text = bcf.idbc::text
    left join as_BLClientFilleGrpBCFille blf on blf.IDBC_FILLE::text=bcf.id::text;

alter table bc_client_fille_cpl_lib
    owner to postgres;

create or replace view vente_details_reste(id, idproduit, idunite, unitelib, qte, reste, idvente) as
SELECT vd.id,
       vd.idproduit,
       vd.unite                                                                                          AS idunite,
       u.val                                                                                             AS unitelib,
       vd.qte,
       COALESCE(vd.qte, 0::numeric) - COALESCE(bl.quantite, 0::numeric) - COALESCE(avcf.qte, 0::numeric) AS reste,
       vd.idvente,
       vd.idbcfille
FROM vente_details vd
         LEFT JOIN bl_client_fille_grp_vente bl ON vd.id::text = bl.idventedetail::text
         LEFT JOIN as_ingredients p ON p.id::text = vd.idproduit::text
    LEFT JOIN as_unite u ON u.id::text = vd.unite::text
    LEFT JOIN avoirfcfille_grp_viseee avcf ON vd.id::text = avcf.idventedetails::text;

alter table vente_details_reste
    owner to postgres;

