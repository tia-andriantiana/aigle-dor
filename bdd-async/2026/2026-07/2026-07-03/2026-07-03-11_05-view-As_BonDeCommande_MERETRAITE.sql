  CREATE   VIEW  AS_BONDECOMMANDE_CPL_RECEPTGRP AS 
    SELECT bc.idbc, sum (bc.quantite ) AS totalCommande , sum (bc.qtelivrer ) AS totalRecept FROM AS_BONDECOMMANDE_CPL_RECEPT bc GROUP BY bc.idbc 
 ;

 CREATE   VIEW  As_BonDeCommande_MERETRAITE AS
 SELECT 
    abm.*,
    CASE
      WHEN abrcp.totalRecept = 0 THEN '0'
      WHEN abrcp.totalCommande > abrcp.totalRecept THEN '1'
      WHEN abrcp.totalCommande = abrcp.totalRecept THEN '2'
      WHEN abrcp.totalCommande < abrcp.totalRecept THEN '3'
      END AS IDTRAITE,
    CASE
        WHEN abrcp.totalRecept = 0 THEN 'Non Trait&eacute;'
        WHEN abrcp.totalCommande > abrcp.totalRecept  THEN 'Trait&eacute; Partiellement'
        WHEN abrcp.totalCommande = abrcp.totalRecept THEN 'Trait&eacute;'
        WHEN abrcp.totalCommande < abrcp.totalRecept THEN 'Trait&eacute; avec surplus'
        END AS TRAITE
  FROM As_BonDeCommande_MERECPL abm
  left join AS_BONDECOMMANDE_CPL_RECEPTGRP abrcp on abrcp.idbc = abm.id;