CREATE OR REPLACE VIEW V_ETATSTOCK_ING_ENG AS
SELECT
   p.ID,
   p.LIBELLE AS idproduitLib,
   p.CATEGORIEINGREDIENT,
   tp.DESCE AS idtypeproduitlib,
   ms.IDMAGASIN,
   mag.VAL AS idmagasinlib,
   TO_DATE('01-01-2001', 'DD-MM-YYYY') AS dateDernierMouvement,
   CAST(ms.quantite AS NUMBER(30,5) ) AS QUANTITE,
   CAST(NVL( ms.entree, 0) AS NUMBER(30, 5))  AS ENTREE,
   CAST(NVL( ms.sortie, 0) AS NUMBER(30, 5))  AS SORTIE,
   CAST(NVL( ms.quantite, 0) AS NUMBER(30, 5))  AS reste,
   p.UNITE,
   u.DESCE AS idunitelib,
   CAST(NVL(p.PV, 0) AS NUMBER(30, 5)) AS PUVENTE,
   mag.IDPOINT,
   mag.IDTYPEMAGASIN,
   p.SEUILMIN,
   p.SEUILMAX,
   CAST(ms.montantEntree AS NUMBER(30,5)) AS montantEntree,
   CAST(ms.montantSortie AS NUMBER(30,5)) AS montantSortie,
   CAST(p.pu AS NUMBER(30,5)) AS pu,
   CAST(ms.montant AS NUMBER(30,5)) AS montantReste
FROM AS_INGREDIENTS p
        LEFT JOIN MONTANT_STOCK_eng ms ON ms.IDPRODUIT = p.ID
        LEFT JOIN CATEGORIEINGREDIENT tp ON p.CATEGORIEINGREDIENT = tp.ID
        LEFT JOIN MAGASINPOINT mag ON ms.IDMAGASIN = mag.ID
        LEFT JOIN AS_UNITE u ON p.UNITE = u.ID
WHERE NVL(ms.ENTREE, 0) > 0 OR NVL(ms.SORTIE, 0) > 0;






