CREATE OR REPLACE VIEW AS_BONDELIVRAISON_TRAITE AS
SELECT
    abm.*,
    CASE
        WHEN abrcp.totalFacturer = 0 THEN '0'
        WHEN abrcp.totallivrer > abrcp.totalFacturer THEN '1'
        WHEN abrcp.totalFacturer = abrcp.totallivrer THEN '2'
        WHEN abrcp.totallivrer < abrcp.totalFacturer THEN '3'
    END AS IDTRAITE,
    CASE
        WHEN abrcp.totalFacturer = 0 THEN 'Non Trait&eacute;'
        WHEN abrcp.totallivrer > abrcp.totalFacturer  THEN 'Trait&eacute; Partiellement'
        WHEN abrcp.totalFacturer = abrcp.totallivrer THEN 'Trait&eacute;'
        WHEN abrcp.totallivrer < abrcp.totalFacturer THEN 'Trait&eacute; avec surplus'
    END AS TRAITE
FROM AS_BONDELIVRAISON_LIB abm
         left join RAPPROCHEMENT_FFOURNISSEURGRP abrcp on abrcp.NUMBL = abm.id;