CREATE OR REPLACE FORCE VIEW "OFRATTACHE"AS 
  SELECT 
  r.ID,
    ofn."IDOFFILLE",
    ofn."DATY",
    ofn."IDPRODUIT",
    ofn."IDPRODUITLIB",
    ofn."QTE",
    ofn."QTEPETRI",
    ofn."IDLIGNE",
    ofn."LIGNE",
    r.IDRELEVE,
    -- Pourcentage de QTEPETRI par IDRELEVE
    (ofn."QTEPETRI" / SUM(ofn."QTEPETRI") OVER (PARTITION BY r.IDRELEVE)) * 100 AS POURCENTAGE
FROM ofnonrattache ofn
JOIN RELEVEFAB r 
    ON r.IDFAB = ofn."IDOFFILLE";