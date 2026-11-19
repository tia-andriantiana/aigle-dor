create or replace view RAPPROCHEMENTGLOBALE_PIE as
select c.id, c.VAL , c.DESCE ,sum(f.pu * f.qte) as montant from FACTUREFOURNISSEURFILLE  f
                                                                    left join AS_INGREDIENTS a on f.IDPRODUIT = a.ID
                                                                    left join CATEGORIEINGREDIENT c on c.ID = a.CATEGORIEINGREDIENT
where c.id is not null
group by c.id, c.VAL,c.DESCE;

create or replace view V_RAPPROCHEMENT_POURCENTAGE as
SELECT
    ID,
    VAL,
    DESCE,
    CAST(MONTANT AS NUMBER(15,2)) AS montant,
    CAST(
            CASE
                WHEN MONTANT > 0 THEN
                    MONTANT * 100.0 /
                    SUM(
                            CASE
                                WHEN MONTANT > 0 THEN MONTANT
                                ELSE 0
                                END
                    ) OVER ()
                ELSE 0
                END
        AS NUMBER(10,2)) AS pourcentage,
    CURRENT_DATE AS DATY
FROM RAPPROCHEMENTGLOBALE_PIE;


create view V_ETATSTOCK_PROD_FINI2 as
SELECT
    p.ID AS ID,
    p.LIBELLE AS idproduitLib,
    p.CATEGORIEINGREDIENT,
    tp.DESCE AS idtypeproduitlib,
    ms.IDMAGASIN,
    mag.VAL AS idmagasinlib,
    TO_DATE('01-01-2001', 'DD-MM-YYYY') AS dateDernierMouvement,
    CAST(ms.quantite AS NUMBER(30,2) ) AS QUANTITE,
    CAST(NVL( ms.entree, 0) AS NUMBER(30, 2))  AS ENTREE,
    CAST(NVL( ms.sortie, 0) AS NUMBER(30, 2))  AS SORTIE,
    CAST(NVL( ms.quantite, 0) AS NUMBER(30, 2))  AS reste,
    p.UNITE,
    u.DESCE AS idunitelib,
    CAST(NVL(p.PV, 0) AS NUMBER(30, 2)) AS PUVENTE,
    mag.IDPOINT,
    mag.IDTYPEMAGASIN,
    p.SEUILMIN,
    p.SEUILMAX,
    CAST(ms.montantEntree AS NUMBER(30,2)) AS montantEntree,
    CAST(ms.montantSortie AS NUMBER(30,2)) AS montantSortie,
    CAST(p.pu AS NUMBER(30,2)) AS pu,
    CAST(ms.montant AS NUMBER(30,2)) as montantReste,
    p.TYPEPRODUIT,
    tpp.val as typeproduitlib,
    CURRENT_DATE AS DATY
FROM AS_INGREDIENTS p
         LEFT JOIN MONTANT_STOCK ms ON ms.IDPRODUIT = p.ID
         LEFT JOIN CATEGORIEINGREDIENT tp ON p.CATEGORIEINGREDIENT = tp.ID
         LEFT JOIN MAGASINPOINT mag ON ms.IDMAGASIN = mag.ID
         LEFT JOIN AS_UNITE u ON p.UNITE = u.ID
         LEFT JOIN TYPE_PRODUIT tpp ON tpp.id = p.TYPEPRODUIT
WHERE (NVL(ms.ENTREE, 0) > 0 OR NVL(ms.SORTIE, 0) > 0) -- Parentheses ajoutees pour la logique
  AND p.CATEGORIEINGREDIENT = 'CAT008'
  AND p.actif = 1;


create view VESTOCKPRODFINI_CAT_PCENTAGE as
SELECT
    TYPEPRODUIT        AS id,
    typeproduitlib,
    CAST(SUM(quantite) AS NUMBER(30,2))  AS quantite,
    CAST(
            SUM(quantite) * 100.0
                / SUM(SUM(quantite)) OVER ()
        AS NUMBER(10,2))                     AS pourcentage,
    CURRENT_DATE AS DATY,
    CAST(SUM(montantReste) AS NUMBER(30,2))  AS montantReste
FROM V_ETATSTOCK_PROD_FINI2 where TYPEPRODUIT is not null
GROUP BY TYPEPRODUIT, typeproduitlib;