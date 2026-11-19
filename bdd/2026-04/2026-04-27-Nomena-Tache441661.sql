CREATE OR REPLACE FORCE VIEW "SOCOBISPREPROD2704"."V_ETATSTOCK_ING" ("ID", "IDPRODUITLIB", "CATEGORIEINGREDIENT", "IDTYPEPRODUITLIB", "IDMAGASIN", "IDMAGASINLIB", "DATEDERNIERMOUVEMENT", "QUANTITE", "ENTREE", "SORTIE", "RESTE", "UNITE", "IDUNITELIB", "PUVENTE", "IDPOINT", "IDTYPEMAGASIN", "SEUILMIN", "SEUILMAX", "MONTANTENTREE", "MONTANTSORTIE", "PU", "MONTANTRESTE", "MOTSCLESSS") AS
SELECT SQ."ID",SQ."IDPRODUITLIB",SQ."CATEGORIEINGREDIENT",SQ."IDTYPEPRODUITLIB",SQ."IDMAGASIN",SQ."IDMAGASINLIB",SQ."DATEDERNIERMOUVEMENT",SQ."QUANTITE",SQ."ENTREE",SQ."SORTIE",SQ."RESTE",SQ."UNITE",SQ."IDUNITELIB",SQ."PUVENTE",SQ."IDPOINT",SQ."IDTYPEMAGASIN",SQ."SEUILMIN",SQ."SEUILMAX",SQ."MONTANTENTREE",SQ."MONTANTSORTIE",SQ."PU",SQ."MONTANTRESTE",
       (NVL(TO_CHAR(ID),'') || ' | ' || NVL(TO_CHAR(IDPRODUITLIB),'') || ' | ' || NVL(TO_CHAR(CATEGORIEINGREDIENT),'') || ' | ' || NVL(TO_CHAR(IDTYPEPRODUITLIB),'') || ' | ' || NVL(TO_CHAR(IDMAGASIN),'') || ' | ' || NVL(TO_CHAR(IDMAGASINLIB),'') || ' | ' || NVL(TO_CHAR(DATEDERNIERMOUVEMENT,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(QUANTITE),'') || ' | ' || NVL(TO_CHAR(ENTREE),'') || ' | ' || NVL(TO_CHAR(SORTIE),'') || ' | ' || NVL(TO_CHAR(RESTE),'') || ' | ' || NVL(TO_CHAR(UNITE),'') || ' | ' || NVL(TO_CHAR(IDUNITELIB),'') || ' | ' || NVL(TO_CHAR(PUVENTE),'') || ' | ' || NVL(TO_CHAR(IDPOINT),'') || ' | ' || NVL(TO_CHAR(IDTYPEMAGASIN),'') || ' | ' || NVL(TO_CHAR(SEUILMIN),'') || ' | ' || NVL(TO_CHAR(SEUILMAX),'') || ' | ' || NVL(TO_CHAR(MONTANTENTREE),'') || ' | ' || NVL(TO_CHAR(MONTANTSORTIE),'') || ' | ' || NVL(TO_CHAR(PU),'') || ' | ' || NVL(TO_CHAR(MONTANTRESTE),'')) AS MOTSCLESSS
FROM (
         SELECT
             ve.idproduit as id ,
             ve.idproduitlib,
             ve.categorieingredient,
             ve.idtypeproduitlib,
             ve.idmagasin,
             ve.idmagasinlib,
             TO_DATE('01-01-2001', 'DD-MM-YYYY') AS dateDernierMouvement,
             CAST(SUM(ve.quantite)AS NUMBER) AS quantite,
             CAST(SUM(ve.entree)AS NUMBER) AS entree,
             CAST(SUM(ve.sortie)AS NUMBER) AS sortie,
             CAST(SUM(ve.reste)AS NUMBER) AS reste,
             ve.unite,
             ve.idunitelib,
             ve.puvente,
             ve.IDPOINT,
             ve.IDTYPEMAGASIN,
             ve.SEUILMIN,
             ve.SEUILMAX,
             CAST(SUM(ve.PU * ve.MONTANTENTREE) AS NUMBER) AS MONTANTENTREE,
             CAST(SUM(ve.PU * ve.MONTANTSORTIE) AS NUMBER) AS MONTANTSORTIE,
             CAST(ve.PU AS NUMBER) AS PU,
             CAST(SUM(ve.PU * ve.MONTANTRESTE) AS NUMBER) AS MONTANTRESTE
         FROM V_ETATSTOCK_ENTREE ve
         WHERE ve.PU > 0
         GROUP BY
             ve.idproduit,
             ve.idproduitlib,
             ve.categorieingredient,
             ve.idtypeproduitlib,
             ve.idmagasin,
             ve.idmagasinlib,
             ve.unite,
             ve.idunitelib,
             ve.puvente,
             ve.IDPOINT,
             ve.IDTYPEMAGASIN,
             ve.SEUILMIN,
             ve.SEUILMAX,
             ve.PU
         ORDER BY ve.idproduit, ve.PU
     ) SQ
;