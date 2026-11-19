CREATE OR REPLACE  VIEW AS_RECETTE_MAINTENANCE_LIB as
SELECT SQ."ID",SQ."IDPRODUITS",SQ."IDINGREDIENTS",SQ."UNITE",SQ."QUANTITE",SQ."IDPRODUITSLIB",SQ."IDINGREDIENTSLIB",SQ."IDINGREDIENTSMAINTENANCE",SQ."UNITELIB",
       (NVL(TO_CHAR(ID),'') || ' | ' || NVL(TO_CHAR(IDPRODUITS),'') || ' | ' || NVL(TO_CHAR(IDINGREDIENTS),'') || ' | ' || NVL(TO_CHAR(UNITE),'') || ' | ' || NVL(TO_CHAR(QUANTITE),'') || ' | ' || NVL(TO_CHAR(IDPRODUITSLIB),'') || ' | ' || NVL(TO_CHAR(IDINGREDIENTSLIB),'') || ' | ' || NVL(TO_CHAR(IDINGREDIENTSMAINTENANCE),'') || ' | ' || NVL(TO_CHAR(UNITELIB),'')) AS MOTSCLESSS
FROM (
         select
             ar."ID",ar."IDPRODUITS",ar."IDINGREDIENTS",ar."UNITE",ar."QUANTITE" ,
             ai2.LIBELLE AS idProduitslib,
             ai.LIBELLE  AS idIngredientsLib,
             aim.id AS idIngredientsMaintenance,
             au.val AS uniteLib
         FROM AS_recette ar
                  LEFT JOIN As_ingredients ai ON ai.id = ar.IDINGREDIENTS
                  LEFT JOIN As_ingredients ai2 ON ai2.id = ar.IDPRODUITS
                  LEFT JOIN AS_UNITE au ON ai.unite = au.id
                  JOIN AS_INGREDIENT_MAINTENANCE aim ON aim.IDINGREDIENT  = ai2.id
     ) SQ;