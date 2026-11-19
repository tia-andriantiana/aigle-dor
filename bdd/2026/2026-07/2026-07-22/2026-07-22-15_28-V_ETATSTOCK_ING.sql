CREATE OR REPLACE VIEW v_etatstock_ing AS
SELECT
    'invdaty' as invdaty,
    cast(sum(invquantite) as number(30,2)) as invquantite,
    '' as id,
    IDPRODUIT,
    idproduitlib,
    CATEGORIEINGREDIENT,
    idtypeproduitlib,
    IDMAGASIN, typeStock,
    idmagasinlib,
    sum(ve.QUANTITE) as quantite,
    CAST(sum(ve.ENTREE) AS NUMBER(30,2)) AS ENTREE,
    CAST(sum(ve.SORTIE) AS NUMBER(30,2)) AS SORTIE,
    CAST(sum(ve.RESTE) AS NUMBER(30,2)) AS RESTE,
    cast(sum(ve.reste)* avg(ve.pu) as number(30,2)) as montantReste,
    UNITE,
    idunitelib,
    avg(ve.PU) AS pu,
    max(ve.DATY) AS daty,
    '' as IDFOURNISSEUR,
    '' as IDFOURNISSEURLIB
FROM V_ETATSTOCK_ENTREE_STANDARD ve
WHERE ve.PU > 0
and ve.reste !=0 group by IDPRODUIT, idproduitlib, CATEGORIEINGREDIENT, idtypeproduitlib, ve.IDMAGASIN, typeStock, idmagasinlib, UNITE,idunitelib;