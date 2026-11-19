--Etape1: Rendre CUMP tous les produits avec typestock null avec catégorie non-service

/*
SELECT ID, LIBELLE, TYPESTOCK, IDCATEGORIEINGREDIENT, CATEGORIEINGREDIENT
FROM AS_INGREDIENTS_LIB2
WHERE TYPESTOCK IS NULL
  AND IDCATEGORIEINGREDIENT NOT IN ('CAT002',         --Main d'oeuvre
                                  'CAT006',         --Autre
                                  'CATING000001',   --Charge personnelle
                                  'CATINGSERVICE',  --Service
                                  'CATING000041');  --Frais accessoire
*/

UPDATE AS_INGREDIENTS
SET TYPESTOCK = 'CUMP'
WHERE TYPESTOCK IS NULL
  AND CATEGORIEINGREDIENT NOT IN ('CAT002',         --Main d'oeuvre
                                  'CAT006',         --Autre
                                  'CATING000001',   --Charge personnelle
                                  'CATINGSERVICE',  --Service
                                  'CATING000041');  --Frais accessoire


--Etape2: Rendre typestock null pour tous les produits de catégorie service
/*
SELECT ID, LIBELLE, TYPESTOCK, IDCATEGORIEINGREDIENT, CATEGORIEINGREDIENT
FROM AS_INGREDIENTS_LIB2
WHERE TYPESTOCK IS NULL
   AND IDCATEGORIEINGREDIENT IN ('CAT002',         --Main d'oeuvre
                              'CAT006',         --Autre
                              'CATING000001',   --Charge personnelle
                              'CATINGSERVICE',  --Service
                              'CATING000041');  --Frais accessoire
*/

UPDATE AS_INGREDIENTS
SET TYPESTOCK = NULL
WHERE CATEGORIEINGREDIENT IN ('CAT002',         --Main d'oeuvre
                              'CAT006',         --Autre
                              'CATING000001',   --Charge personnelle
                              'CATINGSERVICE',  --Service
                              'CATING000041');  --Frais accessoire


COMMIT;