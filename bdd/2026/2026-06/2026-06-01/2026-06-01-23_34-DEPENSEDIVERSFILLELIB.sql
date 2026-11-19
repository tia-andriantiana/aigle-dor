create or replace view DEPENSEDIVERSFILLELIB as
SELECT
    d."ID",d."IDMERE",d."IDPRODUIT",d."DESIGNATION",d."QUANTITE",d."PU",
    ail.LIBELLE AS idProduitLib,
    CAST(NVL(d."QUANTITE", 0) * NVL(d."PU", 0) AS NUMBER(30,2)) AS montant
FROM DEPENSEDIVERSFILLE d
         LEFT JOIN AS_INGREDIENTS_LIB ail ON d.IDPRODUIT = ail.ID;

create or replace view DEPENSEDIVERSLIB as
SELECT
    d.ID,d.DATY,d.FOURNISSEUR,d.REMARQUE,d.IDMODEPAIEMENT,d.COMPTECHEQUE,d.ACHETEUR,d.IDMAGASIN,d.IDCATEGORIE,d.ETAT ,
    f.NOM AS fournisseurLib,
    m.VAL AS IDMODEPAIEMENTLIB,
    m2.val AS idMagasinLib,
    c.VAL AS idCategorieLib,
    CASE
        WHEN d.ETAT = 0
            THEN 'ANNUL&Eacute;E'
        WHEN d.ETAT = 1
            THEN 'CR&Eacute;&Eacute;E'
        WHEN d.ETAT = 3
            THEN 'VIS&Eacute;E par Chef de D&eacutepartement'
        WHEN d.ETAT = 4
            THEN 'VIS&Eacute;E par Directeur de D&eacutepartement'
        WHEN d.ETAT = 11
            THEN 'VIS&Eacute;E par Le Directeur'
        WHEN d.ETAT = 5
            THEN 'VIS&Eacute;E par Contr&ocirc;le'
        END AS etatlib,
    CAST(NVL((
        SELECT SUM(NVL(df."QUANTITE", 0) * NVL(df."PU", 0))
        FROM DEPENSEDIVERSFILLE df
        WHERE df."IDMERE" = d.ID
    ), 0) AS NUMBER(30,2)) AS MONTANTTOTAL
FROM DEPENSEDIVERS d
         LEFT JOIN FOURNISSEUR f ON d.FOURNISSEUR = f.ID
         LEFT JOIN MODEPAIEMENT m ON d.IDMODEPAIEMENT = m.ID
         LEFT JOIN MAGASIN2 m2 ON d.IDMAGASIN = m2.ID
         LEFT JOIN CATEGORIEINGREDIENT c ON d.IDCATEGORIE = c.ID;
