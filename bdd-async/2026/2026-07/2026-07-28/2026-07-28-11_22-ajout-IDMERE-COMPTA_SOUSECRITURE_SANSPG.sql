 
CREATE OR REPLACE VIEW  "COMPTA_SOUSECRITURE_SANSPG" ("ID", "NUMERO", "COMPTE", "JOURNAL", "IDJOURNAL", "ECRITURE", "DATY", "CREDIT", "DEBIT", "DATECOMPTABLE", "EXERCICE", "REMARQUE", "ETAT", "HORSEXERCICE", "OD", "ORIGINE", "TIERS", "LIBELLEPIECE", "COMPTE_AUX", "RAISONSOCIAL", "FOLIO", "LETTRAGE", "ANALYTIQUE", "IDOBJET", "IDMERE") AS 
  select
    sousecr.id,
    cpt.LIBELLE,
    cpt.COMPTE,
    jrn.val||'| '|| jrn.DESCE ,
    jrn.id,
    sousecr.REMARQUE as DESIGNATION,
    sousecr.DATY,
    sousecr.CREDIT,
    sousecr.DEBIT,
    sousecr.DATY AS DATECOMPTABLE,
    sousecr.EXERCICE,
    sousecr.REMARQUE,
    sousecr.ETAT,
    cast(0 as number) AS HORSEXERCICE,
    cast('-' as varchar(50)) AS OD,
    cast('' as varchar(50)) AS ORIGINE,
    cast('' as varchar2(50)) as tiers,
    sousecr.LIBELLEPIECE,
    sousecr.COMPTE_AUX,
    cast('' as varchar(100)) as RAISONSOCIAL ,
    sousecr.folio ,
    sousecr.LETTRAGE ,
    ANALYTIQUE,
    CASE
        WHEN ce.IDOBJET= pe.id THEN pe.idorigine
        ELSE ce.idobjet
        END
        AS idobjet,
      sousecr.IDMERE
from
    COMPTA_SOUS_ECRITURE sousecr
        join COMPTA_COMPTE cpt on  sousecr.COMPTE = cpt.COMPTE
        join COMPTA_JOURNAL jrn on sousecr.JOURNAL = jrn.ID
        JOIN COMPTA_ECRITURE ce ON ce.id = sousecr.IDMERE
        LEFT JOIN PERTEGAINIMPREVUE pe ON ce.idobjet=pe.id;