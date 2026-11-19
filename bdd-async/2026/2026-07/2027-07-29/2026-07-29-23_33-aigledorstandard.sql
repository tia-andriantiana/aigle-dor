create or replace view V_ETATSTOCK_ING as
SELECT v.ID,v.DATY,v.INVQUANTITE,v.ENTREE,v.SORTIE,v.RESTE,v.QUANTITE,v.MONTANTRESTE,v.PU,v.IDPRODUITLIB,v.IDMODELE,v.IDMODELELIB,v.IDCATEGORIEMODELE,v.IDCATEGORIEMODELELIB,v.IDSOUSCATEGORIEMODELE,v.IDSOUSCATEGORIEMODELELIB,v.IDPOINTURE,v.IDPOINTURELIB,v.CATEGORIEINGREDIENT,v.UNITE,v.TYPESTOCK,v.IDUNITELIB,v.IDTYPEPRODUITLIB,v.IDFOURNISSEUR,v.IDFOURNISSEURLIB,v.IDPRODUIT,v.IDMAGASIN,v.IDMAGASINLIB,v.INVDATY,v.REFERENCECOULEUR,v.NOMCOULEUR,v.CODECOULEUR,v.SEUIL,v.SEUILMIN,v.SEUILMAX,
           (
           NVL(CAST(v.ID AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(
                   TO_CHAR(v.DATY, 'YYYY-MM-DD HH24:MI:SS'),
                   ''
           ) || ' | ' ||
           NVL(TO_CHAR(v.INVQUANTITE), '') || ' | ' ||
           NVL(TO_CHAR(v.ENTREE), '') || ' | ' ||
           NVL(TO_CHAR(v.SORTIE), '') || ' | ' ||
           NVL(TO_CHAR(v.RESTE), '') || ' | ' ||
           NVL(TO_CHAR(v.QUANTITE), '') || ' | ' ||
           NVL(TO_CHAR(v.MONTANTRESTE), '') || ' | ' ||
           NVL(TO_CHAR(v.PU), '') || ' | ' ||
           NVL(CAST(v.IDPRODUITLIB AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(
                   CAST(v.CATEGORIEINGREDIENT AS VARCHAR2(4000)),
                   ''
           ) || ' | ' ||
           NVL(CAST(v.UNITE AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(v.TYPESTOCK AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(v.IDUNITELIB AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(v.IDTYPEPRODUITLIB AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(v.IDFOURNISSEUR AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(v.IDFOURNISSEURLIB AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(v.IDPRODUIT AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(v.IDMAGASIN AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(v.IDMAGASINLIB AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(
                   TO_CHAR(v.INVDATY, 'YYYY-MM-DD HH24:MI:SS'),
                   ''
           ) || ' | ' ||
           NVL(TO_CHAR(v.SEUIL), '') || ' | ' ||
           NVL(TO_CHAR(v.SEUILMIN), '') || ' | ' ||
           NVL(TO_CHAR(v.SEUILMAX), '')
           ) AS MOTSCLESSS
FROM V_ETATSTOCK_ING_TOUS v
WHERE v.RESTE <> 0