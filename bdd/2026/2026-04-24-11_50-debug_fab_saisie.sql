
CREATE OR REPLACE VIEW AS_RECOFFVUESTFAB AS
SELECT
  SQ."ID",
  SQ."IDINGREDIENTS",
  SQ."UNITE",
  SQ."QTEAV",
  SQ."QUANTITE",
  SQ."IDPRODUITS",
  SQ."IDUNITE",
  SQ."COMPOSE",
  SQ."NIVEAU",
  SQ."LIBINGREDIENTS",
  SQ."RESTESTOCK",
  CAST(SQ."RAF" AS NUMBER(30,10)) AS RAF,
  SQ."FABENCOURS",
  SQ."TYPESTOCK",
  (
    NVL(TO_CHAR(ID),'') || ' | ' ||
    NVL(TO_CHAR(IDINGREDIENTS),'') || ' | ' ||
    NVL(TO_CHAR(UNITE),'') || ' | ' ||
    NVL(TO_CHAR(QTEAV),'') || ' | ' ||
    NVL(TO_CHAR(QUANTITE),'') || ' | ' ||
    NVL(TO_CHAR(IDPRODUITS),'') || ' | ' ||
    NVL(TO_CHAR(IDUNITE),'') || ' | ' ||
    NVL(TO_CHAR(COMPOSE),'') || ' | ' ||
    NVL(TO_CHAR(NIVEAU),'') || ' | ' ||
    NVL(TO_CHAR(LIBINGREDIENTS),'') || ' | ' ||
    NVL(TO_CHAR(RESTESTOCK),'') || ' | ' ||
    NVL(TO_CHAR(CAST(RAF AS NUMBER(30,10))),'') || ' | ' ||
    NVL(TO_CHAR(FABENCOURS),'') || ' | ' ||
    NVL(TO_CHAR(TYPESTOCK),'')
  ) AS MOTSCLESSS
FROM (
  SELECT
    a."ID",
    a."IDINGREDIENTS",
    a."UNITE",
    a."QTEAV",
    a."QUANTITE",
    a."IDPRODUITS",
    a."IDUNITE",
    a."COMPOSE",
    a."NIVEAU",
    a."LIBINGREDIENTS",
    a."RESTESTOCK",
    CAST(a.RAF AS NUMBER(30,10)) AS RAF,
    NVL(f.FabEncours,0) AS FabEncours,
    a.TYPESTOCK
  FROM as_recOffVueResteSt a
  LEFT JOIN FabricationEncours f
    ON f.IDINGREDIENTS = a.IDINGREDIENTS
) SQ;
