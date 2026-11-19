create or replace view bondecommande_client_fille_v
            (id, produit, idbc, quantite, pu, montant, tva, remise, iddevise, unite, designation, unitelib, punet,
             montantht, montantttc, ristourne, calorie,tauxdechange)
as
SELECT p.id,
       p.produit,
       p.idbc,
       p.quantite,
       p.pu,
       p.montant,
       p.tva,
       p.remise,
       p.iddevise,
       p.unite,
       p.designation,
       uni.val AS unitelib,
       0       AS punet,
       0       AS montantht,
       0       AS montantttc,
       p.ristourne,
       ing.calorie,
       p.tauxdechange
FROM bondecommande_client_fille p
         LEFT JOIN as_unite uni ON p.unite::text = uni.id::text
         LEFT JOIN as_ingredients ing ON p.produit::text = ing.id::text;

alter table bondecommande_client_fille_v
    owner to postgres;

ALTER TABLE avoirfc ADD iddevise     varchar(100);






